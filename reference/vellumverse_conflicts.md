# Conflicts between the vellum ecosystem and other packages

`vellumverse_conflicts()` lists every function exported by a core
vellum-ecosystem package that is masked by, or masks, a function of the
same name attached elsewhere on the search path. It is the equivalent of
`tidyverse::tidyverse_conflicts()`, and is also reported automatically
when `vellumverse` is attached.

## Usage

``` r
vellumverse_conflicts()
```

## Value

An S3 object of class `"vellumverse_conflicts"`, a named list mapping
each conflicted function to the packages that export it (in search-path
order). Has a print method.

## Examples

``` r
vellumverse_conflicts()
#> ── Conflicts ──────────────────────────────────────── vellumverse_conflicts() ──
#> ✖ vellumplot::linear_gradient masks vellum
#> ✖ vellumplot::md              masks vellum
#> ✖ vellumplot::radial_gradient masks vellum
#> ✖ vellumplot::sketch          masks vellum
```
