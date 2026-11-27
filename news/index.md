# Changelog

## vellumverse (development version)

### Documentation

- “One scene, three outputs” is now “One scene, many outputs”
  (`articles/one-scene-many-outputs.html`; the old address redirects).
  It gains “Output 4: editable slides”: `render_plot(p, "x.pptx")`,
  [`vellum::pptx_pages()`](https://r-vellum.github.io/vellum/reference/pptx_pages.html),
  and
  [`vellum::as_dml()`](https://r-vellum.github.io/vellum/reference/as_dml.html)
  with `officer::ph_with()`, linking vellum’s PowerPoint article. Get
  started, Coming from ggplot2 and Performance link to the new title
  (D-30).
- Get started states the current mapping rule: a column or an expression
  is mapped, a single value (literal or in a variable that is not a
  column) is a setting, [`I()`](https://rdrr.io/r/base/AsIs.html) forces
  a setting and `.env$x` a mapping (D-31).
- Coming from ggplot2 gains rows for labellers (`label_parsed`,
  `label_wrap_gen()`), `guide_axis()`, plotmath labels,
  `element_text(weight =)`, `theme(strip.clip =)`, and a gganimate and
  patchwork table (`transition_*()`, `animate()`, `anim_save()`,
  `hconcat()`, `vconcat()`, `concat(heights =)`, `inset(align_to =)`,
  `compose_annotation(tag_levels =)`), with notes on `vconcat()`
  heights, untitled unaligned compositions, PowerPoint output and the
  ggplot2-style dropping of missing values. Table cells holding `|>` no
  longer show a stray backslash (D-32).
- The README no longer shows a version-stamped attach banner, and the
  README and The vellum ecosystem list PPTX among vellum’s outputs
  (D-33).
- Performance gains “Interactive at scale” (vellumwidget’s raster mode,
  its WebGL2 tier and `max_marks`, linking the big-data article) and
  notes on SVG size and parallel GIF encoding; Design principles and The
  vellum ecosystem mention the DrawingML (PowerPoint) backend (D-34).

## vellumverse 0.3.27

- Requires vellum 0.18.0 and vellumplot 0.25.1. vellum adds editable
  PowerPoint output: `officer::ph_with()` for scenes and plots (via
  [`as_dml()`](https://r-vellum.github.io/vellum/reference/as_dml.html)),
  and `render(x, "deck.pptx")` /
  [`pptx_pages()`](https://r-vellum.github.io/vellum/reference/pptx_pages.html)
  without officer. It also fixes a crash where PDF output aborted R on a
  missing point size. vellumplot drops rows with a missing `size` with a
  warning, as ggplot2 does, and a continuous size legend no longer shows
  an “NA” key. vellumwidget (\>= 0.20.1) is unchanged.

## vellumverse 0.3.26

- Requires vellumplot 0.25.0: text layout uses the theme’s font, face
  and weight everywhere it reserves space (legends, axis labels, strips,
  titles, tags, mark labels), facet strip text is clipped to its strip
  (new `theme(strip.clip =)` to turn that off), end tick labels get room
  when the plot margin can’t hold them, and `theme()` on an unthemed
  plot follows `options(vellumplot.brand)` at draw time. vellum (\>=
  0.17.0) and vellumwidget (\>= 0.20.1) are unchanged.

## vellumverse 0.3.25

- Requires vellum 0.17.0 (numeric font weights) and vellumplot 0.24.0
  (`theme_brand()`: plot themes from a brand.yml file, the format of
  Quarto’s `_brand.yml`). vellumwidget (\>= 0.20.1) is unchanged.

## vellumverse 0.3.24

- Requires vellum 0.16.0 (math labels:
  [`tex()`](https://r-vellum.github.io/vellum/reference/tex.html),
  inline `$...$` in
  [`md()`](https://r-vellum.github.io/vellum/reference/md.html),
  [`plotmath()`](https://r-vellum.github.io/vellum/reference/plotmath.html)),
  vellumplot 0.23.0 and vellumwidget 0.20.1.

## vellumverse 0.3.23

- Bumped the pinned vellumwidget to (\>= 0.20.0): big raster widgets
  draw their zoomed-in marks, lines and polygons with WebGL2. vellumplot
  is pinned to (\>= 0.22.1); vellum (\>= 0.15.0) is unchanged.

## vellumverse 0.3.22

- Bumped the pinned vellum to (\>= 0.15.0), vellumplot to (\>= 0.22.0)
  and vellumwidget to (\>= 0.19.1). vellumplot 0.22.0 has breaking
  changes: a length-1 variable passed to a mark argument is a constant,
  `inset()` honours `align_to` (default `"panel"`), and `theme_void()`
  has no plot margin.

## vellumverse 0.3.21

- Bumped the pinned vellumplot to (\>= 0.21.1): point legend keys of
  plots with tiny points no longer shrink below a readable minimum
  (`theme(legend.key.point.min =)`).

## vellumverse 0.3.20

- Bumped the pinned vellumplot to (\>= 0.21.0); vellum (\>= 0.14.0) and
  vellumwidget (\>= 0.19.0) are unchanged.
  - vellumplot 0.21.0: all 26 numeric point shapes draw as in ggplot2
    (open, solid and bordered styles, R’s per-symbol sizes, composite
    glyphs for 7-14), legend keys take the layer’s point colour, size
    and shape and line keys its ink, `mark_crossbar(width =)` is in data
    units with a wider middle line, date axes judge each label pair by
    its own widths and keep short labels when sparse, and mapping
    `shape` to SVG paths warns.

## vellumverse 0.3.19

- Bumped the pinned versions to the latest releases: vellumplot (\>=
  0.20.0) and vellumwidget (\>= 0.19.0); vellum stays at (\>= 0.14.0).
  - vellumplot 0.20.0: `mark_bar(width =)` and `mark_errorbar(width =)`
    are in data units (error bars default to 0.9 of the band, as in
    ggplot2), tiles and rasters keep their end cells, open and bordered
    numeric point shapes draw as in ggplot2, `drop =` on size and alpha
    scales, date breaks account for label angle, dodged rows and legend
    width and keep at least two labels, edge-bundle legend keys are
    lines, and flow-map tooltips name their destinations.
  - vellumwidget 0.19.0: legends with two aesthetics ship up to 4x
    smaller payloads, and hollow marks draw as outlines in the fallback
    dots.

## vellumverse 0.3.18

- Bumped the pinned versions to the latest releases: vellum (\>=
  0.14.0), vellumplot (\>= 0.19.0) and vellumwidget (\>= 0.18.0).
  - vellum 0.14.0: tweens match marks by data key with enter/exit fades,
    lines with different vertex counts morph, labels change per frame,
    animated SVGs are namespaced and share their gradients and clip
    paths (a five-bar colour bar animation drops from 2.9 MB to 0.9 MB),
    exact fps, faster GIF encoding, and bars, tiles and boxes on a
    reversed axis are drawn again.
  - vellumplot 0.19.0: animation identity by data_id/group, frame
    variables in labs() and mark_text(), transition_reveal() along any
    variable, Date/POSIXct times, facets, start/end pauses and rewind,
    anim_frame(), .apng output; unused factor levels are dropped from
    legends, bars on a continuous x keep their end widths, date breaks
    fit their labels, nudges follow coord_flip(), and effect underlays
    keep their series.
  - vellumwidget 0.18.0: play/pause and a scrubber for animations,
    render_options(autoplay, loop), per-row alpha in conditions, shaped
    fallback dots above max_marks, and keyboard focus kept on a raised
    mark.

## vellumverse 0.3.17

- Bumped the pinned versions to the latest releases: vellumplot (\>=
  0.18.1) and vellumwidget (\>= 0.17.0); vellum stays at (\>= 0.13.0).
  - vellumplot 0.18.1: a per-row `if_false` colour reaches the widget as
    colours, condition tags no longer collide across composition cells,
    and a contour-style line with a constant colour per series draws as
    one path (about 100x fewer records on volcano contours).
  - vellumwidget 0.17.0: selected marks draw above the rest of their
    layer, a per-row `if_false` colours non-members, a constant
    `if_false` on `alpha` dims them to that opacity, brush and lasso hit
    constant-size marks where they are drawn, selection rings follow
    zoom and stay inside their panel, raster payloads with lines and
    polygons are up to 60% smaller, and a zoomed y axis moves its title
    clear of longer labels.

## vellumverse 0.3.16

- Bumped the pinned versions to the latest releases: vellum (\>=
  0.13.0), vellumplot (\>= 0.18.0) and vellumwidget (\>= 0.16.0).
  - vellumplot 0.18.0: legend keys take the layer alpha (filled, point
    and line keys), faceted flow maps keep each panel’s own edges,
    flow-map branches are keyed for hover and selection, and two
    `condition()`s on one selection in different layers no longer
    collide.
  - vellumwidget 0.16.0: the browser payload is about half its former
    size (compact coordinates, binary keys, more tooltip patterns), zoom
    is capped at 100x by default (`render_options(max_zoom =)`),
    `max_marks` defaults to 2e6, rotated text and axis labels keep their
    rotation under axis zoom, and labels drawn from images keep their
    size when zoomed.
  - vellum 0.13.0: compact display-list coordinates, blend groups
    isolate in PDF output, and a blend inside a cached viewport renders
    correctly.

## vellumverse 0.3.15

- Bumped the pinned versions to the latest releases: vellum (\>=
  0.12.0), vellumplot (\>= 0.17.1) and vellumwidget (\>= 0.15.0).
  - Interactive builds are faster: a 200k-point widget builds in about 1
    s (1.5 s before), a 1M-point one in about 4.5 s (8.4 s before), and
    faceted plots gain the most.
  - The 200k-point widget payload is less than half its former size (6.1
    MB to 2.7 MB): element keys ship once and repeated or numbered
    tooltips are compressed. Hover text is unchanged.
  - Large clouds of filled circles render faster and closer to exact in
    PNG output.

## vellumverse 0.3.14

- Bumped the pinned versions to the latest patch releases: vellum (\>=
  0.11.1) and vellumwidget (\>= 0.14.1). vellumplot stays at (\>=
  0.17.0).
  - vellum 0.11.1 fixes
    [`scene_svg()`](https://r-vellum.github.io/vellum/reference/scene_svg.html)
    dropping blend modes, masks and layer effects inside panels, so a
    layer `blend`, `clip_layer()` or layer effect now shows in
    `plot_svg()` and the widget’s SVG mode.
  - vellumwidget 0.14.1 lets filters, conditions and dimming reach marks
    the display list can’t draw, and composites blend-mode marks in the
    zoomed tiers.

## vellumverse 0.3.13

- Bumped the pinned versions to the latest releases: vellum (\>=
  0.11.0), vellumplot (\>= 0.17.0) and vellumwidget (\>= 0.14.0).
  - vellum 0.11.0 adds display-list version 2 (gradients, path clips,
    opacity groups) and a flagged-marks layer, so the widget can draw
    more marks exactly when zoomed.
  - vellumplot 0.17.0 follows ggplot2’s default area fill, recolours
    more defaults on dark themes, fixes faceted dodging, graph facets
    and jitterdodge, and lightens the default density fill. See its NEWS
    for the behaviour changes.
  - vellumwidget 0.14.0 exports conditions, filters and dimming as
    shown, keeps furniture constant-size under axis zoom, and draws
    gradients, clips and flagged marks in the zoomed tiers.

## vellumverse 0.3.12

- Bumped the pinned versions to the latest releases: vellum (\>=
  0.10.1), vellumplot (\>= 0.16.0) and vellumwidget (\>= 0.13.1).
  - vellum 0.10.1 errors clearly on a missing or non-finite text size
    instead of measuring it as a huge negative width on Linux (0 on
    macOS).
  - vellumplot 0.16.0 adds `element_geom()`: themes set the default
    colours of unmapped marks, so `theme_cyberpunk()` no longer draws
    black points on its dark panel. Legends in aligned compositions
    follow their guide or theme position, and per-panel legends are
    collected when they would squeeze the panels. Several defaults now
    match ggplot2 or changed on purpose; see its NEWS under “Behaviour
    changes”: dodging splits each x between the groups present there,
    discrete alpha/size/linewidth group a layer, and default element
    keys name the panel, layer and row.
  - vellumwidget 0.13.1 ships the new default keys as compactly as plain
    row numbers.

## vellumverse 0.3.11

- Bumped the pinned versions to the latest releases: vellum (\>=
  0.10.0), vellumplot (\>= 0.15.1) and vellumwidget (\>= 0.13.0).
  - vellum 0.10.0 can render a scene’s marks and furniture as separate
    layers
    ([`scene_svg()`](https://r-vellum.github.io/vellum/reference/scene_svg.html)/[`scene_png()`](https://r-vellum.github.io/vellum/reference/scene_png.html)
    `layer =`, including paint order) and export the marks as a display
    list
    ([`scene_display_list()`](https://r-vellum.github.io/vellum/reference/scene_display_list.html)).
    Large scatter plots rasterise much faster.
  - vellumplot 0.15.1 compiles big plots faster and no longer keys
    `annotate()` layers just because the plot declares a selection.
  - vellumwidget 0.13.0 makes large raster plots fully interactive: axis
    zoom, the navigator and linked zoom work, zooming draws exact marks,
    and zoomed in far enough the marks become real SVG nodes.
    Selections, `condition()` and `filter_by()` show at every zoom
    level, and the payload is up to 5x smaller. A 200k-point widget
    builds in about 1.6 s instead of 7 s.

## vellumverse 0.3.10

- Bumped the pinned versions to the latest releases: vellum (\>= 0.9.0),
  vellumplot (\>= 0.15.0) and vellumwidget (\>= 0.12.0).
  - vellum 0.9.0 writes one SVG element per filled-and-outlined shape
    (about half the size for scatter plots) and adds a cached spatial
    index with
    [`vl_brush()`](https://r-vellum.github.io/vellum/reference/vl_brush.html)
    and
    [`vl_lasso()`](https://r-vellum.github.io/vellum/reference/vl_brush.html)
    for region queries;
    [`vl_nearest()`](https://r-vellum.github.io/vellum/reference/vl_nearest.html)
    is much faster.
  - vellumplot 0.15.0 gives `color` and `fill` separate scales and
    legends, as in ggplot2, and works alongside an attached ggplot2
    again. It adds brush-driven linked zoom (`bind_scale()`,
    `select_interval(bind = "scales")`), legends beside each facet panel
    (`guide_legend(position = "panel")`) and `guide_bins()`, and groups
    layers by all their discrete aesthetics. Several defaults changed;
    see its NEWS under “Behaviour changes”.
  - vellumwidget 0.12.0 supports one-element points and linked zoom, and
    fixes zoomed gridlines, brushed lines and the selection colour on
    dark plots.

## vellumverse 0.3.9

- Bumped the vellumplot pin to the latest release, vellumplot (\>=
  0.14.0). vellumplot 0.14.0 adds ggplot2’s remaining common scale
  constructors (manual shape/linetype/size/alpha, hue, grey, fermenter,
  log10/sqrt/reverse and more), new marks (`mark_rect()`,
  `mark_polygon()`, `mark_path()`, `mark_curve()`, `mark_spoke()`,
  `mark_density_2d()`, `mark_quantile()`), `guide_axis()`, and
  independent colour/size legends per facet panel via `resolve_scale()`.
  A `color` given with a `fill` now outlines filled marks, as in
  ggplot2; see its NEWS under “Behaviour changes”.

## vellumverse 0.3.8

- Bumped the pinned versions to the latest releases: vellum (\>= 0.8.1),
  vellumplot (\>= 0.13.0) and vellumwidget (\>= 0.11.0).
  - vellum 0.8.1 writes smaller SVG and gives SVG ids that are stable
    across renders and unique between plots on one page.
  - vellumplot 0.13.0 closes many ggplot2 parity gaps: histogram
    binning, `mark_freqpoly()`, `mark_summary(fun.data)`, horizontal box
    plots and violins, facet labellers,
    `scale_*_discrete(breaks, labels, drop)`, `oob`, and legends inside
    the panel. Several defaults now match ggplot2; see its NEWS under
    “Behaviour changes”.
  - vellumwidget 0.11.0 groups `as_widget()` settings into option
    helpers (`tooltip_options()`, `export_options()`,
    `navigator_options()`, `render_options()`), reports zoom per panel,
    and fixes linking after a group change.
- [`library(vellumverse)`](https://r-vellum.github.io/vellumverse/) no
  longer reports a block of conflicts inside the family. vellumplot now
  re-exports vellum’s
  [`md()`](https://r-vellum.github.io/vellum/reference/md.html),
  [`vl_pattern()`](https://r-vellum.github.io/vellum/reference/vl_pattern.html),
  [`sketch()`](https://r-vellum.github.io/vellum/reference/sketch.html),
  [`linear_gradient()`](https://r-vellum.github.io/vellum/reference/gradients.html)
  and
  [`radial_gradient()`](https://r-vellum.github.io/vellum/reference/gradients.html)
  rather than wrapping them, so those are identical and not reported at
  all. The two that genuinely differ, vellumplot’s
  [`pdf_pages()`](https://r-vellum.github.io/vellum/reference/pdf_pages.html)
  and
  [`render_all()`](https://r-vellum.github.io/vellum/reference/render_all.html),
  are summarised on one line. Conflicts with packages outside the family
  are listed as before.
  [`vellumverse_conflicts()`](https://r-vellum.github.io/vellumverse/reference/vellumverse_conflicts.md)
  entries gain a `family` flag (VV-2).

## vellumverse 0.3.7

- Bumped the pinned versions to the latest releases: vellum (\>= 0.8.0),
  vellumplot (\>= 0.12.0) and vellumwidget (\>= 0.10.0).
  - vellum 0.8.0 has one breaking change: a bare number now means
    `"npc"` in every constructor.
    [`lines_grob()`](https://r-vellum.github.io/vellum/reference/grob.html),
    [`polygon_grob()`](https://r-vellum.github.io/vellum/reference/grob.html),
    [`segments_grob()`](https://r-vellum.github.io/vellum/reference/grob.html),
    [`path_grob()`](https://r-vellum.github.io/vellum/reference/grob.html)
    and the curve and hexagon/sector size arguments used `"native"`.
    Pass `default_units = "native"` for the old behaviour. Inputs are
    now validated with clear errors.
  - vellumplot 0.12.0 adds `select_interval()`, bivariate choropleths,
    tapered mapped linewidth, `spec_diagnose()` and `rel()`. It also
    fixes stacking, NA categories and facets, legend merging, and date
    breaks.
  - vellumwidget 0.10.0 adds a data-value brush and re-ticks log, date
    and discrete axes under zoom.

## vellumverse 0.3.6

- Bumped the pinned versions to the latest releases: vellum (\>= 0.7.2),
  vellumplot (\>= 0.11.1) and vellumwidget (\>= 0.9.1). Every geometry
  query and the widget now pick what is actually drawn (a polygon’s hole
  is no longer a hit, offset and capped lines are picked where they are
  drawn), and PNG, SVG and PDF agree on dashes and pattern strokes.

## vellumverse 0.3.5

- Bumped the pinned vellumplot version to the latest release (\>=
  0.11.0), which brings the `group` aesthetic, dodge/stack for every
  mark, and ggplot2 `color`/`fill` semantics on box plots, violins and
  ridgelines.

## vellumverse 0.3.4

- Bumped the pinned ecosystem versions to the latest releases: vellum
  (\>= 0.7.1), vellumplot (\>= 0.10.0), and vellumwidget (\>= 0.9.0).

- **`options(vellumverse.quiet = TRUE)` no longer stops the core
  packages from being attached.** The option returned from the attach
  hook before anything was loaded, so
  [`library(vellumverse)`](https://r-vellum.github.io/vellumverse/) put
  only vellumverse itself on the search path. As in tidyverse, the
  option now only silences the startup banner and the conflict report;
  vellum, vellumplot and vellumwidget are attached either way.

## vellumverse 0.3.3

- Bumped the pinned ecosystem versions to the latest releases: vellum
  (\>= 0.6.6), vellumplot (\>= 0.9.0), and vellumwidget (\>= 0.8.0).

## vellumverse 0.3.2

- Bumped the pinned ecosystem versions to the latest releases:
  vellumplot (\>= 0.8.0) and vellumwidget (\>= 0.7.0); vellum stays at
  (\>= 0.5.1).

## vellumverse 0.3.1

- Bumped the pinned ecosystem versions to the latest releases: vellum
  (\>= 0.5.0), vellumplot (\>= 0.6.0), and vellumwidget (\>= 0.6.0).

## vellumverse 0.3.0

- Bumped the pinned ecosystem versions to the latest releases: vellum
  (\>= 0.4.0), vellumplot (\>= 0.5.0), and vellumwidget (\>= 0.5.0).

## vellumverse 0.2.1

- Maintenance release. Declared the `stats` dependency (used when
  reporting ecosystem conflicts), dropped the unused `rlang` dependency
  to keep the meta-package dependency-light, and removed a dead
  `startup` argument from the
  [`vellumverse_conflicts()`](https://r-vellum.github.io/vellumverse/reference/vellumverse_conflicts.md)
  print method.

## vellumverse 0.2.0

- Adopted vellum’s renamed `vl_*` graphics primitives (grid collision
  fix).

## vellumverse 0.1.0

First release.

- [`library(vellumverse)`](https://r-vellum.github.io/vellumverse/)
  attaches the core of the vellum graphics ecosystem (vellum,
  vellumplot, and vellumwidget) in one step and reports which versions
  were loaded.
- [`vellumverse_packages()`](https://r-vellum.github.io/vellumverse/reference/vellumverse_packages.md)
  lists the bundled packages and
  [`vellumverse_conflicts()`](https://r-vellum.github.io/vellumverse/reference/vellumverse_conflicts.md)
  surfaces functions masked across the ecosystem.
- Set `options(vellumverse.quiet = TRUE)` to attach without the startup
  banner.
