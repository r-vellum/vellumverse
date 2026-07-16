# Changelog

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
