# Changelog

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
