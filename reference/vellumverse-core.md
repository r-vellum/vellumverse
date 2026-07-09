# The core of the vellum ecosystem

`vellumverse` bundles the packages that make up the *vellum* graphics
ecosystem so they can be installed and loaded in one step, the way
`tidyverse` bundles the data-science packages. Attaching `vellumverse`
attaches the three core packages:

## Details

- [vellum](https://rdrr.io/pkg/vellum/man/vellum-package.html), the
  low-level graphics backend (a Rust scene graph, unit/layout engine,
  and multi-backend renderer).

- [vellumplot](https://rdrr.io/pkg/vellumplot/man/vellumplot-package.html),
  a pipe-first grammar of graphics that compiles an inspectable plot
  spec into a vellum scene.

- [vellumwidget](https://rdrr.io/pkg/vellumwidget/man/vellumwidget-package.html),
  client-side interactive HTML widgets for the scenes that vellum and
  vellumplot produce.
