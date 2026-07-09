# List the core vellum-ecosystem packages

`vellumverse_packages()` returns the names of the packages that
[`library(vellumverse)`](https://r-vellum.github.io/vellumverse/)
attaches.

## Usage

``` r
vellumverse_packages(include_self = TRUE)
```

## Arguments

- include_self:

  Whether to include `vellumverse` itself in the list.

## Value

A character vector of package names.

## Examples

``` r
vellumverse_packages()
#> [1] "vellum"       "vellumplot"   "vellumwidget" "vellumverse" 
```
