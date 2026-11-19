# vellumverse 0.3.7

* Bumped the pinned versions to the latest releases: vellum (>= 0.8.0),
  vellumplot (>= 0.12.0) and vellumwidget (>= 0.10.0).
  * vellum 0.8.0 has one breaking change: a bare number now means `"npc"`
    in every constructor. `lines_grob()`, `polygon_grob()`,
    `segments_grob()`, `path_grob()` and the curve and hexagon/sector size
    arguments used `"native"`. Pass `default_units = "native"` for the old
    behaviour. Inputs are now validated with clear errors.
  * vellumplot 0.12.0 adds `select_interval()`, bivariate choropleths,
    tapered mapped linewidth, `spec_diagnose()` and `rel()`. It also fixes
    stacking, NA categories and facets, legend merging, and date breaks.
  * vellumwidget 0.10.0 adds a data-value brush and re-ticks log, date and
    discrete axes under zoom.

# vellumverse 0.3.6

* Bumped the pinned versions to the latest releases: vellum (>= 0.7.2),
  vellumplot (>= 0.11.1) and vellumwidget (>= 0.9.1). Every geometry query
  and the widget now pick what is actually drawn (a polygon's hole is no
  longer a hit, offset and capped lines are picked where they are drawn), and
  PNG, SVG and PDF agree on dashes and pattern strokes.

# vellumverse 0.3.5

* Bumped the pinned vellumplot version to the latest release (>= 0.11.0),
  which brings the `group` aesthetic, dodge/stack for every mark, and
  ggplot2 `color`/`fill` semantics on box plots, violins and ridgelines.

# vellumverse 0.3.4

* Bumped the pinned ecosystem versions to the latest releases: vellum
  (>= 0.7.1), vellumplot (>= 0.10.0), and vellumwidget (>= 0.9.0).

* **`options(vellumverse.quiet = TRUE)` no longer stops the core packages from
  being attached.** The option returned from the attach hook before anything
  was loaded, so `library(vellumverse)` put only vellumverse itself on the
  search path. As in tidyverse, the option now only silences the startup
  banner and the conflict report; vellum, vellumplot and vellumwidget are
  attached either way.

# vellumverse 0.3.3

* Bumped the pinned ecosystem versions to the latest releases: vellum
  (>= 0.6.6), vellumplot (>= 0.9.0), and vellumwidget (>= 0.8.0).

# vellumverse 0.3.2

* Bumped the pinned ecosystem versions to the latest releases: vellumplot
  (>= 0.8.0) and vellumwidget (>= 0.7.0); vellum stays at (>= 0.5.1).

# vellumverse 0.3.1

* Bumped the pinned ecosystem versions to the latest releases: vellum
  (>= 0.5.0), vellumplot (>= 0.6.0), and vellumwidget (>= 0.6.0).

# vellumverse 0.3.0

* Bumped the pinned ecosystem versions to the latest releases: vellum
  (>= 0.4.0), vellumplot (>= 0.5.0), and vellumwidget (>= 0.5.0).

# vellumverse 0.2.1

* Maintenance release. Declared the `stats` dependency (used when reporting
  ecosystem conflicts), dropped the unused `rlang` dependency to keep the
  meta-package dependency-light, and removed a dead `startup` argument from the
  `vellumverse_conflicts()` print method.

# vellumverse 0.2.0

* Adopted vellum's renamed `vl_*` graphics primitives (grid collision fix).

# vellumverse 0.1.0

First release.

* `library(vellumverse)` attaches the core of the vellum graphics ecosystem
  (vellum, vellumplot, and vellumwidget) in one step and reports which versions were loaded.
* `vellumverse_packages()` lists the bundled packages and
  `vellumverse_conflicts()` surfaces functions masked across the ecosystem.
* Set `options(vellumverse.quiet = TRUE)` to attach without the startup banner.
