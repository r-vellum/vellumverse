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

An S3 object of class `"vellumverse_conflicts"`, a named list with one
entry per conflicted function: its `name`, the `pkgs` that export it (in
search-path order), and `family`, `TRUE` when every one of those
packages belongs to the vellum ecosystem. Has a print method.

## Details

Overlaps *within* the ecosystem (a vellumplot function masking a vellum
function of the same name that does something different, such as
`pdf_pages()`) are by design: they are summarised on a single line
rather than listed as conflicts. Identical re-exports are not reported
at all.

## Examples

``` r
vellumverse_conflicts()
#> ℹ Within the family, vellumplot::pdf_pages(), vellumplot::render_all() mask vellum's versions (by design).
```
