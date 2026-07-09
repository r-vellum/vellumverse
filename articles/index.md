# Articles

### Get started

- [Getting
  started](https://r-vellum.github.io/vellumverse/articles/getting-started.md):

  From a data frame to a rendered plot to an interactive widget, in one
  pipeline, using the whole vellum ecosystem through vellumverse.

- [The vellum
  ecosystem](https://r-vellum.github.io/vellumverse/articles/ecosystem.md):

  How vellum, vellumplot, and vellumwidget fit together, from a
  low-level scene graph, to a grammar of graphics, to an interactive
  widget.

- [Coming from
  ggplot2](https://r-vellum.github.io/vellumverse/articles/coming-from-ggplot2.md):

  A translation guide for ggplot2 users: the same plots built both ways,
  side by side, and the handful of concepts that differ.

### Using the ecosystem

- [One scene, three
  outputs](https://r-vellum.github.io/vellumverse/articles/one-scene-three-outputs.md):

  The ecosystem’s central move: a plot is compiled once into a vellum
  scene, then rendered to raster, to vector, or to an interactive widget
  from the same object.

- [Performance and big
  data](https://r-vellum.github.io/vellumverse/articles/performance.md):

  Why the ecosystem stays fast as data grows, and how datashade renders
  millions of points by aggregating before it draws.

- [Extending the
  ecosystem](https://r-vellum.github.io/vellumverse/articles/extending-the-ecosystem.md):

  The seams the three layers agree on, and how to build on them:
  composite grobs, custom themes, the interactivity contract, and
  teaching the ecosystem about your own objects.

### Background

- [A critical appraisal of
  grid](https://r-vellum.github.io/vellumverse/articles/grid-critique.md):

  What R’s grid graphics system does well, where it becomes hard to work
  with, and what the ecosystem of packages built on top of it reveals
  about its gaps. An even-handed look, not a takedown.

- [vellum's design
  principles](https://r-vellum.github.io/vellumverse/articles/design-principles.md):

  The architectural choices behind vellum (a retained scene graph, eager
  metrics, an explicit layout pass, and a single render walk to many
  backends), and the trade-offs each one accepts.
