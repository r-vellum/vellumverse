# Changelog

## vellumverse (development version)

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
