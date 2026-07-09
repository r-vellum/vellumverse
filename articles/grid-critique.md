# A critical appraisal of grid

R has, in effect, two graphics systems. Base graphics draws directly to
a device as each call is made. `grid`, introduced by Paul Murrell, keeps
a model of the scene and a real layout engine, and it is the foundation
that `lattice`, `ggplot2`, `gtable`, and most of the modern plotting
ecosystem are built on. That foundation has held up for two decades,
which is itself the strongest argument in its favour. This article looks
at both sides: what `grid` got right, and the recurring friction that
the packages layered on top of it expose.

## What grid gets right

It helps to be concrete about the strengths, because they are
substantial and they are the reason the ecosystem exists at all.

**A real scene and layout model.** Unlike base graphics, `grid`
represents a plot as objects (grobs) arranged inside a system of nested
regions. This is what makes complex, reusable graphics possible. A
faceted plot with aligned panels, shared axes, and a common legend is a
layout problem, and `grid` has an engine to solve it rather than a pile
of manual coordinate arithmetic.

**Viewports.** The viewport is `grid`’s central good idea. It is a
rectangular region with its own coordinate systems, clipping, and layout
context, and viewports nest. Drawing inside a viewport with its own
`xscale`/`yscale` means you can work in data coordinates in one place
and normalized coordinates in another, without recomputing transforms by
hand. Almost everything expressive in `ggplot2`’s rendered output rests
on this.

**The unit system.** `grid` can express a length in centimetres, in a
fraction of the current region, as the width of a string, as the width
of another grob, or in data-native coordinates, and mix them. Being able
to say “make this margin as wide as the widest axis label” is powerful,
and no simpler model would capture it.

**Device independence.** A `grid` scene targets an abstract device, so
the same code renders to screen, PDF, PNG, and SVG. The engine handles
clipping, colour, and the display list; the device handles
rasterization. That separation is clean and it is why one plotting call
can produce many output formats.

**It enabled an ecosystem.** The clearest evidence that `grid` is a good
engine is everything built on it. `ggplot2` is one of the most
successful data-analysis tools in any language, and it is a grammar of
graphics compiled down to grobs and viewports. `grid` deserves a large
share of that credit.

None of what follows should be read as denying these points. The
critique is narrower: `grid` is a strong *engine* with a demanding
*interface*, and the distance between the two is where the difficulty
lives.

## The missing middle layer

The ecosystem has excellent high-level APIs and capable low-level
primitives, but the layer between them is thin. At the top, you write:

``` r

ggplot(df, aes(x, y)) + geom_point() + facet_wrap(~group)
```

At the bottom, you manipulate grobs, units, and viewports directly.
There is no comfortable middle ground for the requests that fall between
the two: “move this legend inside the third panel but don’t clip it”,
“align this annotation to the rendered axis title”, “reserve space for a
custom element”. These are not grammar-level questions and they are not
really primitive-level questions either, and answering them usually
means dropping from the semantic layer into implementation details: grob
names, viewport paths, `gtable` cells, clipping flags.

That descent is the recurring theme. When a plot doesn’t do exactly what
you want, the fix often lives a layer or two below where you were
working.

## Viewports are stateful

The viewport model is powerful, but the API is built around a mutable
stack:

``` r

pushViewport(vp)
grid.draw(g)
popViewport()
```

The meaning of a drawing call depends on the current state of that
stack. If the stack is not what you assumed, the call targets the wrong
region without complaint, or fails in a way that is hard to trace back
to its cause. This is the usual cost of stateful APIs: correctness
depends on invisible context, and that context is easy to get wrong in
code that builds plots programmatically. The model itself, regions with
their own coordinate systems, is sound; it is the *stateful* way of
navigating it that creates fragility.

## Units: powerful, and hard to reason about

The same unit system that is a strength is also a common source of
confusion. Unit expressions can mix absolute, relative, text-derived,
and grob-derived measurements, and many of those values are not knowable
until layout or device-rendering time. That is inherent to the problem
(a string has no width until a font and device exist), but it means
questions like “why is this panel this width?” or “which measurement
forced this margin?” are difficult to answer from the outside. The power
and the opacity come from the same place: lengths that resolve late.

## Composition happens after the fact

`gtable` is the layer `ggplot2` uses to turn a plot into a renderable
grid of cells, and it is indispensable. But manipulating a `gtable`
directly tends to feel like operating on an internal representation: you
locate grobs by name, splice rows and columns, edit cells, and re-render
to see whether it worked.

The strongest evidence that composition was not fully solved at the core
is the number of packages that exist to provide it: `gridExtra`,
`cowplot`, `patchwork`, `egg`, `ggplotify`, and others. Each is well
made and widely used, and their collective existence says that combining
plots, sharing a legend across them, or adding a caption is common
enough, and awkward enough at the `grid`/`gtable` level, to be worth a
package. A system where a plot were a composable layout object from the
start would need fewer of them. (`grid` predates the demand; composition
of whole plots was not a design target in the 1990s.)

## Clipping and coordinate systems can surprise

Advanced plots run into clipping and coordinate questions: an annotation
that should escape its panel, an inset, an arrow between regions, a
label that must not be clipped. In `grid`, clipping is tied to
viewports, and its behaviour can interact with transformations such as
rotation in ways that are not obvious in advance.

Underneath, several distinct coordinate spaces coexist (data, panel,
plot, page, physical device), but they are implicit. You generally learn
which one you are in by trying something and seeing where it lands. The
spaces are real and well-defined; they are not surfaced as first-class,
named concepts, so working across them is more trial-and-error than it
needs to be.

## Styling is fragmented

Controlling appearance means meeting several styling systems:
[`gpar()`](https://rdrr.io/pkg/vellum/man/gpar.html) in `grid`, themes
in `ggplot2`, base graphics parameters, device-specific font handling,
and, for HTML output, CSS. Each is reasonable on its own. Together they
mean that setting something as ordinary as a consistent font or line
width across a composed figure can require understanding more than one
model. There is no single cascading style layer that spans plot types
and composition.

## Performance scales with the object tree

Many `ggplot2` plots produce a large number of grobs, and the cost of
building, laying out, and drawing them is not always dominated by data
size; sometimes it is the object count and tree depth. Because `grid`
lives in interpreted R and replays its display list on resize, a complex
figure can feel heavy in a way that is about tree overhead rather than
the data. This is a consequence of the era and the language it was
written in as much as of the design; it is a real cost nonetheless.

## Devices leak into the result

Output depends on the target device (screen, PDF, `cairo`, `ragg`,
`quartz`, and so on), and font metrics, antialiasing, text shaping, and
rasterization can differ between them. Some variation is unavoidable
when different backends render the same scene. But the assumptions a
given render made (which fonts were resolved, which metrics were used,
what was rasterized) are hard to inspect, which makes reproducing a
figure exactly across machines harder than one would like.

## What ggplot2 inherited

`ggplot2` is worth singling out because it shows the split clearly. Its
grammar (data, aesthetics, geoms, stats, scales, coordinates, facets,
themes) is excellent, and for the great majority of plots you never
touch anything below it. But once a `ggplot` object becomes a rendered
layout, the `grid`-level characteristics reappear: legend placement can
turn into grob manipulation, facet customization into `gtable` editing,
panel-specific annotation stays awkward, and composition reaches for an
external package. `ggplot2` solves the grammar of statistical graphics
very well. The grammar of graphical *layout and composition* is the part
that remains harder than the high-level API suggests.

## An even-handed conclusion

A fair summary is less a verdict than a shape:

``` text
Easy things are very easy.
Medium-hard things are surprisingly hard.
Hard things require knowing internals.
```

That shape is not evidence that `grid` is bad. It is a powerful,
principled engine that has supported an enormous amount of excellent
work and continues to. The friction is concentrated in a specific place,
the interface between the expressive high-level APIs and the low-level
machinery, and much of it traces to a single fact: in `grid`, a grob’s
size and content cannot be known until a device and a viewport exist at
draw time. That one constraint is what makes units resolve late, what
motivates the deferred grob-drawing protocol, and what forces the
display-list replay. Most of the individual complaints above are
downstream of it.

That observation is also the starting point for [vellum’s design
principles](https://r-vellum.github.io/vellumverse/articles/design-principles.md),
which describe one set of choices a low-level graphics layer can make if
it removes that constraint, while trying to keep the strengths
catalogued at the top of this page.
