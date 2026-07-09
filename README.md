
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vellumverse <img src="man/figures/logo.png" align="right" height="138" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/r-vellum/vellumverse/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-vellum/vellumverse/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**vellumverse** installs and loads the *vellum* graphics ecosystem in
one step, the way [tidyverse](https://www.tidyverse.org) does for data
science. The name is the medieval *vellumverse*, the room where
manuscripts were written and copied. Its packages carry the same
metaphor:

| package | role | analogy |
|----|----|----|
| [**vellum**](https://github.com/r-vellum/vellum) | low-level graphics backend, a Rust scene graph, unit/layout engine, and PNG/SVG/PDF renderer | `grid` |
| [**vellumplot**](https://github.com/r-vellum/vellumplot) | pipe-first grammar of graphics that compiles a plot spec into a vellum scene | `ggplot2` |
| [**vellumwidget**](https://github.com/r-vellum/vellumwidget) | client-side interactive HTML widgets for the scenes they produce | `plotly`/`htmlwidgets` |

`vellum` is the parchment, `vellumplot` is the pen, and `vellumwidget` is the
annotation revealed on the page.

## Installation

The ecosystem compiles a Rust crate (in `vellum`), so you need a Rust
toolchain (`cargo`/`rustc`) alongside R. Then:

``` r
# install.packages("pak")
pak::pak("r-vellum/vellumverse")
```

## Usage

``` r
library(vellumverse)
#> ── Attaching packages ──────────────────────────────────── vellumverse 0.1.0 ──
#> ✔ vellum 0.1.0   ✔ vellumplot 0.1.0   ✔ vellumwidget 0.1.0
```

That single call attaches all three core packages, so you can go from a
data frame to an interactive plot in one pipeline:

``` r
library(vellumverse)

df <- data.frame(wt = mtcars$wt, mpg = mtcars$mpg, model = rownames(mtcars))

vplot(df) |>                                     # vellumplot: grammar of graphics
  mark_point(x = wt, y = mpg, color = mpg,
             tooltip = model, data_id = model) |>
  scale_color_continuous() |>
  as_widget()                                    # vellumwidget: interactive widget
```

`vplot()`, `mark_point()`, and the scales come from **vellumplot**;
`as_widget()` comes from **vellumwidget**; both compile down to a **vellum**
scene.

## Helpers

``` r
vellumverse_packages()    # the packages vellumverse bundles
vellumverse_conflicts()   # functions masked across the ecosystem
```

To load the packages without the startup banner, set
`options(vellumverse.quiet = TRUE)` before attaching.
