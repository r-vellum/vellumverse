# Extending the ecosystem

The ecosystem is layered so that each layer exposes a seam the next one
builds on. The same seams are open to you. This article walks the four
most useful extension points, from the most local (a reusable piece of
drawing) to the most structural (making the whole ecosystem understand a
new kind of object).

## 1. Reusable drawing: grob factories and scene helpers

There are two ways to package a piece of drawing for reuse, and both are
ordinary R functions: nothing to register, nothing to teach the
renderer.

The first is a **grob factory**: a function that returns a single grob.
[`datashade()`](https://r-vellum.github.io/vellum/reference/datashade.html)
is exactly this: it returns one `raster_grob`, and a function that
returns a grob is a first-class primitive that drops straight into
[`draw()`](https://r-vellum.github.io/vellum/reference/vl_scene.html),
inherits graphical parameters from its viewport, and renders to every
backend.

The second, for drawing that is more than one primitive, is a **scene
helper**: a function that takes a scene, draws into it, and returns the
scene. Because
[`draw()`](https://r-vellum.github.io/vellum/reference/vl_scene.html)
takes one grob at a time, this is how you compose several primitives
into a reusable unit that still chains in a pipe:

``` r

# a labelled marker: a filled circle with text centred on it
marker <- function(scene, x, y, label, fill = "#6b4f2c") {
  scene |>
    draw(circle_grob(x = x, y = y, r = 0.06, gp = vl_gpar(fill = fill, col = NA))) |>
    draw(text_grob(label, x = x, y = y,
                   gp = vl_gpar(col = "white", fontface = "bold", fontsize = 12)))
}

vl_scene(4, 2, bg = "white") |>
  marker(0.25, 0.5, "A") |>
  marker(0.5, 0.5, "B", fill = "#8a7350") |>
  marker(0.75, 0.5, "C")
```

![](extending-the-ecosystem_files/figure-html/composite-1.png)

Scene-in, scene-out means your helper composes with
[`draw()`](https://r-vellum.github.io/vellum/reference/vl_scene.html),
[`push()`](https://r-vellum.github.io/vellum/reference/vl_scene.html),
and [`pop()`](https://r-vellum.github.io/vellum/reference/vl_scene.html)
like any built-in verb.

## 2. Custom themes: restyle without new machinery

At the grammar layer, a theme is a function that sets styling on a plot
spec. `vellumplot` gives you `theme()` for individual elements and
`set_theme()` for the common surfaces, built from `element_text()`,
`element_line()`, and `element_rect()`. A reusable theme is a function
that applies them:

``` r

theme_parchment <- function(plot) {
  plot |>
    set_theme(
      panel_bg  = "#faf5ea",
      grid_col  = "#e6dcc4",
      label_col = "#4a371f"
    ) |>
    theme(
      plot.title     = element_text(family = "serif", size = 16),
      legend.position = "bottom"
    )
}

vplot(mtcars) |>
  mark_point(x = wt, y = mpg, color = factor(cyl)) |>
  theme_parchment()
```

![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIHZpZXdib3g9IjAgMCA1NzYgMzg0IiByb2xlPSJpbWciIGFyaWEtbGFiZWxsZWRieT0idmw4MDdmMjMxMy1kIj48ZGVzYyBpZD0idmw4MDdmMjMxMy1kIj5BIHNjYXR0ZXIgcGxvdC4gSXQgcGxvdHMgbXBnICh2ZXJ0aWNhbCBheGlzKSBhZ2FpbnN0IHd0IChob3Jpem9udGFsIGF4aXMpLCB3aGVyZSBjb2xvdXIgc2hvd3MgZmFjdG9yKGN5bCkuIEJhc2VkIG9uIDMyIG9ic2VydmF0aW9ucy48L2Rlc2M+PGRlZnM+PGNsaXBwYXRoIGlkPSJ2bDgwN2YyMzEzLWMwIiBjbGlwcGF0aHVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTTY5LjM1MTg2NzY3NTc4MTI1IDIwLjc4NzQwMTE5OTM0MDgyIEw1NTUuMjEyNTk2MDIyMjM3OSAyMC43ODc0MDExOTkzNDA4MiBMNTU1LjIxMjU5NjAyMjIzNzkgMjYwLjMzNTEzNzQxOTgxMzMgTDY5LjM1MTg2NzY3NTc4MTI1IDI2MC4zMzUxMzc0MTk4MTMzIFoiIC8+PC9jbGlwcGF0aD48L2RlZnM+PHJlY3Qgd2lkdGg9IjU3NiIgaGVpZ2h0PSIzODQiIGZpbGw9IiNmZmZmZmYiIGZpbGwtb3BhY2l0eT0iMSIgLz48ZyBkYXRhLXZlbGx1bS1wYW5lbD0icGxvdCI+PGcgZGF0YS12ZWxsdW0tcGFuZWw9InBsb3QtYmFja2dyb3VuZCI+PGcgcm9sZT0icHJlc2VudGF0aW9uIj48cGF0aCBkPSJNMCAwIEw1NzYgMCBMNTc2IDM4NCBMMCAzODQgWiIgZmlsbD0iI2ZmZmZmZiIgLz48L2c+PC9nPjxnIGRhdGEtdmVsbHVtLXBhbmVsPSJwYW5lbC1hcmVhIj48ZyBkYXRhLXZlbGx1bS1wYW5lbD0icGFuZWwtMS0xIiBjbGlwLXBhdGg9InVybCgjdmw4MDdmMjMxMy1jMCkiPjxnIGRhdGEtdmVsbHVtLXBhbj0icGFuZWwtMS0xIj48cGF0aCBkPSJNNjkuMzUgMjAuNzkgTDU1NS4yMSAyMC43OSBMNTU1LjIxIDI2MC4zNCBMNjkuMzUgMjYwLjM0IFoiIGZpbGw9IiNmYWY1ZWEiIC8+PGcgcm9sZT0iZ3JpZCI+PHBhdGggZD0iTTg5Ljk3IDI2MC4zNCBMODkuOTcgMjAuNzkgTTIwMi45IDI2MC4zNCBMMjAyLjkgMjAuNzkgTTMxNS44NCAyNjAuMzQgTDMxNS44NCAyMC43OSBNNDI4Ljc4IDI2MC4zNCBMNDI4Ljc4IDIwLjc5IE01NDEuNzEgMjYwLjM0IEw1NDEuNzEgMjAuNzkiIGZpbGw9Im5vbmUiIHN0cm9rZT0iI2U2ZGNjNCIgc3Ryb2tlLXdpZHRoPSIwLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgLz48L2c+PGcgcm9sZT0iZ3JpZCI+PHBhdGggZD0iTTY5LjM1IDIyOS45OSBMNTU1LjIxIDIyOS45OSBNNjkuMzUgMTgzLjY1IEw1NTUuMjEgMTgzLjY1IE02OS4zNSAxMzcuMzIgTDU1NS4yMSAxMzcuMzIgTTY5LjM1IDkwLjk4IEw1NTUuMjEgOTAuOTggTTY5LjM1IDQ0LjY1IEw1NTUuMjEgNDQuNjUiIGZpbGw9Im5vbmUiIHN0cm9rZT0iI2U2ZGNjNCIgc3Ryb2tlLXdpZHRoPSIwLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgLz48L2c+PGcgcm9sZT0iZ3JpZCI+PHBhdGggZD0iTTE0Ni40NCAyNjAuMzQgTDE0Ni40NCAyMC43OSBNMjU5LjM3IDI2MC4zNCBMMjU5LjM3IDIwLjc5IE0zNzIuMzEgMjYwLjM0IEwzNzIuMzEgMjAuNzkgTTQ4NS4yNCAyNjAuMzQgTDQ4NS4yNCAyMC43OSIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjZTZkY2M0IiBzdHJva2Utd2lkdGg9IjEiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgLz48L2c+PGcgcm9sZT0iZ3JpZCI+PHBhdGggZD0iTTY5LjM1IDIwNi44MiBMNTU1LjIxIDIwNi44MiBNNjkuMzUgMTYwLjQ4IEw1NTUuMjEgMTYwLjQ4IE02OS4zNSAxMTQuMTUgTDU1NS4yMSAxMTQuMTUgTTY5LjM1IDY3LjgyIEw1NTUuMjEgNjcuODIiIGZpbGw9Im5vbmUiIHN0cm9rZT0iI2U2ZGNjNCIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiIC8+PC9nPjxnIHJvbGU9InByZXNlbnRhdGlvbiI+PHBhdGggZD0iTTE0Ni40NCAyNjAuMzQgTDE0Ni40NCAyNTQuNjcgTTI1OS4zNyAyNjAuMzQgTDI1OS4zNyAyNTQuNjcgTTM3Mi4zMSAyNjAuMzQgTDM3Mi4zMSAyNTQuNjcgTTQ4NS4yNCAyNjAuMzQgTDQ4NS4yNCAyNTQuNjciIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzMzMzMzMyIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiIC8+PC9nPjxnIHJvbGU9InByZXNlbnRhdGlvbiI+PHBhdGggZD0iTTY5LjM1IDIwNi44MiBMNzUuMDIgMjA2LjgyIE02OS4zNSAxNjAuNDggTDc1LjAyIDE2MC40OCBNNjkuMzUgMTE0LjE1IEw3NS4wMiAxMTQuMTUgTTY5LjM1IDY3LjgyIEw3NS4wMiA2Ny44MiIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMzMzMzMzIiBzdHJva2Utd2lkdGg9IjEiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgLz48L2c+PGcgZGF0YS12ZWxsdW0taWQ9ImxheWVyLTEtcG9pbnQtZzEiIHJvbGU9InByZXNlbnRhdGlvbiI+PGNpcmNsZSBjeD0iMjE2LjQ2IiBjeT0iMTUxLjIyIiByPSIzLjc4IiBmaWxsPSIjMDA3MmIyIiBzdHJva2U9IiMwMDcyYjIiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMjQ1LjI1IiBjeT0iMTUxLjIyIiByPSIzLjc4IiBmaWxsPSIjMDA3MmIyIiBzdHJva2U9IiMwMDcyYjIiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMjgzLjY1IiBjeT0iMTQ3LjUxIiByPSIzLjc4IiBmaWxsPSIjMDA3MmIyIiBzdHJva2U9IiMwMDcyYjIiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMzExLjMyIiBjeT0iMTc4LjA5IiByPSIzLjc4IiBmaWxsPSIjMDA3MmIyIiBzdHJva2U9IiMwMDcyYjIiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMzA5LjA2IiBjeT0iMTY3LjkiIHI9IjMuNzgiIGZpbGw9IiMwMDcyYjIiIHN0cm9rZT0iIzAwNzJiMiIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIzMDkuMDYiIGN5PSIxODAuODciIHI9IjMuNzgiIGZpbGw9IiMwMDcyYjIiIHN0cm9rZT0iIzAwNzJiMiIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIyMzMuNCIgY3k9IjE2My4yNyIgcj0iMy43OCIgZmlsbD0iIzAwNzJiMiIgc3Ryb2tlPSIjMDA3MmIyIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjwvZz48ZyBkYXRhLXZlbGx1bS1pZD0ibGF5ZXItMS1wb2ludC1nMiIgcm9sZT0icHJlc2VudGF0aW9uIj48Y2lyY2xlIGN4PSIxODIuNTgiIGN5PSIxMzQuNTQiIHI9IjMuNzgiIGZpbGw9IiMyZjQ4NTgiIHN0cm9rZT0iIzJmNDg1OCIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIyODAuODMiIGN5PSIxMTkuNzEiIHI9IjMuNzgiIGZpbGw9IiMyZjQ4NTgiIHN0cm9rZT0iIzJmNDg1OCIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIyNzYuMzEiIGN5PSIxMzQuNTQiIHI9IjMuNzgiIGZpbGw9IiMyZjQ4NTgiIHN0cm9rZT0iIzJmNDg1OCIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIxNjkuMDIiIGN5PSI0NS41OCIgcj0iMy43OCIgZmlsbD0iIzJmNDg1OCIgc3Ryb2tlPSIjMmY0ODU4IiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjEwMi45NiIgY3k9IjY0LjExIiByPSIzLjc4IiBmaWxsPSIjMmY0ODU4IiBzdHJva2U9IiMyZjQ4NTgiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMTI3LjgiIGN5PSIzMS42OCIgcj0iMy43OCIgZmlsbD0iIzJmNDg1OCIgc3Ryb2tlPSIjMmY0ODU4IiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjE5OC45NSIgY3k9IjE0Ni41OCIgcj0iMy43OCIgZmlsbD0iIzJmNDg1OCIgc3Ryb2tlPSIjMmY0ODU4IiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjEzOS4xIiBjeT0iOTIuODQiIHI9IjMuNzgiIGZpbGw9IiMyZjQ4NTgiIHN0cm9rZT0iIzJmNDg1OCIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIxNjIuMjUiIGN5PSIxMDQuODgiIHI9IjMuNzgiIGZpbGw9IiMyZjQ4NTgiIHN0cm9rZT0iIzJmNDg1OCIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSI5MS40NCIgY3k9IjY0LjExIiByPSIzLjc4IiBmaWxsPSIjMmY0ODU4IiBzdHJva2U9IiMyZjQ4NTgiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMjM0LjUzIiBjeT0iMTQ3LjUxIiByPSIzLjc4IiBmaWxsPSIjMmY0ODU4IiBzdHJva2U9IiMyZjQ4NTgiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PC9nPjxnIGRhdGEtdmVsbHVtLWlkPSJsYXllci0xLXBvaW50LWczIiByb2xlPSJwcmVzZW50YXRpb24iPjxjaXJjbGUgY3g9IjMwOS4wNiIgY3k9IjE3Mi41MyIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjMyMy43NSIgY3k9IjIxMy4zMSIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjM4MC4yMSIgY3k9IjE5My44NSIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjM0MS44MSIgY3k9IjE4NS41MSIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjM0Ny40NiIgY3k9IjIwNC45NyIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjUxMy40OCIgY3k9IjI0OS40NSIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjUzMy4xMyIgY3k9IjI0OS40NSIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjUyNC4yMSIgY3k9IjIwOS42IiByPSIzLjc4IiBmaWxsPSIjMDA5ZTczIiBzdHJva2U9IiMwMDllNzMiIHN0cm9rZS13aWR0aD0iMSI+PC9jaXJjbGU+PGNpcmNsZSBjeD0iMzE4LjEiIGN5PSIyMDIuMTkiIHI9IjMuNzgiIGZpbGw9IiMwMDllNzMiIHN0cm9rZT0iIzAwOWU3MyIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIzMDguNSIgY3k9IjIwNC45NyIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjM1NC4yNCIgY3k9IjIyMi41NyIgcj0iMy43OCIgZmlsbD0iIzAwOWU3MyIgc3Ryb2tlPSIjMDA5ZTczIiBzdHJva2Utd2lkdGg9IjEiPjwvY2lyY2xlPjxjaXJjbGUgY3g9IjM1NC44IiBjeT0iMTY3LjkiIHI9IjMuNzgiIGZpbGw9IiMwMDllNzMiIHN0cm9rZT0iIzAwOWU3MyIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIyNzguNTciIGN5PSIxOTkuNDEiIHI9IjMuNzgiIGZpbGw9IiMwMDllNzMiIHN0cm9rZT0iIzAwOWU3MyIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48Y2lyY2xlIGN4PSIzMjMuNzUiIGN5PSIyMDYuODIiIHI9IjMuNzgiIGZpbGw9IiMwMDllNzMiIHN0cm9rZT0iIzAwOWU3MyIgc3Ryb2tlLXdpZHRoPSIxIj48L2NpcmNsZT48L2c+PC9nPjwvZz48ZyBkYXRhLXZlbGx1bS1wYW5lbD0iYXhpcy15LTEiPjx0ZXh0IHg9IjI1LjE2MjIwNDcyNDQwOTQ0MiIgeT0iMTg2LjAzMTc1MjU5Njc0OTg3IiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxIDQzLjE0MTI0IDIwLjc4NzQwMSkiIGZpbGw9IiM0YTM3MWYiIGZpbGwtb3BhY2l0eT0iMSIgZm9udC1mYW1pbHk9InNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTIiIHRleHQtYW5jaG9yPSJlbmQiIGRvbWluYW50LWJhc2VsaW5lPSJjZW50cmFsIj4xNTwvdGV4dD48dGV4dCB4PSIyNS4xNjIyMDQ3MjQ0MDk0NDIiIHk9IjEzOS42OTc1Njc2NDExNDU5MiIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSA0My4xNDEyNCAyMC43ODc0MDEpIiBmaWxsPSIjNGEzNzFmIiBmaWxsLW9wYWNpdHk9IjEiIGZvbnQtZmFtaWx5PSJzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiB0ZXh0LWFuY2hvcj0iZW5kIiBkb21pbmFudC1iYXNlbGluZT0iY2VudHJhbCI+MjA8L3RleHQ+PHRleHQgeD0iMjUuMTYyMjA0NzI0NDA5NDQyIiB5PSI5My4zNjMzODI2ODU1NDE5NSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSA0My4xNDEyNCAyMC43ODc0MDEpIiBmaWxsPSIjNGEzNzFmIiBmaWxsLW9wYWNpdHk9IjEiIGZvbnQtZmFtaWx5PSJzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiB0ZXh0LWFuY2hvcj0iZW5kIiBkb21pbmFudC1iYXNlbGluZT0iY2VudHJhbCI+MjU8L3RleHQ+PHRleHQgeD0iMjUuMTYyMjA0NzI0NDA5NDQyIiB5PSI0Ny4wMjkxOTc3Mjk5MzgwMDUiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEgNDMuMTQxMjQgMjAuNzg3NDAxKSIgZmlsbD0iIzRhMzcxZiIgZmlsbC1vcGFjaXR5PSIxIiBmb250LWZhbWlseT0ic2Fucy1zZXJpZiIgZm9udC1zaXplPSIxMiIgdGV4dC1hbmNob3I9ImVuZCIgZG9taW5hbnQtYmFzZWxpbmU9ImNlbnRyYWwiPjMwPC90ZXh0PjwvZz48ZyBkYXRhLXZlbGx1bS1wYW5lbD0iYXhpcy14LTMiPjx0ZXh0IHg9Ijc3LjA4NDI3MDUwMzQ0NTc4IiB5PSI0LjQ4OTE2MzM4NTgyNjc3OCIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSA2OS4zNTE4NyAyNjAuMzM1MTQpIiBmaWxsPSIjNGEzNzFmIiBmaWxsLW9wYWNpdHk9IjEiIGZvbnQtZmFtaWx5PSJzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkb21pbmFudC1iYXNlbGluZT0idGV4dC1iZWZvcmUtZWRnZSI+MjwvdGV4dD48dGV4dCB4PSIxOTAuMDE5OTgyOTEwNTE1OTgiIHk9IjQuNDg5MTYzMzg1ODI2Nzc4IiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxIDY5LjM1MTg3IDI2MC4zMzUxNCkiIGZpbGw9IiM0YTM3MWYiIGZpbGwtb3BhY2l0eT0iMSIgZm9udC1mYW1pbHk9InNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTIiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGRvbWluYW50LWJhc2VsaW5lPSJ0ZXh0LWJlZm9yZS1lZGdlIj4zPC90ZXh0Pjx0ZXh0IHg9IjMwMi45NTU2OTUzMTc1ODYxNiIgeT0iNC40ODkxNjMzODU4MjY3NzgiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEgNjkuMzUxODcgMjYwLjMzNTE0KSIgZmlsbD0iIzRhMzcxZiIgZmlsbC1vcGFjaXR5PSIxIiBmb250LWZhbWlseT0ic2Fucy1zZXJpZiIgZm9udC1zaXplPSIxMiIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZG9taW5hbnQtYmFzZWxpbmU9InRleHQtYmVmb3JlLWVkZ2UiPjQ8L3RleHQ+PHRleHQgeD0iNDE1Ljg5MTQwNzcyNDY1NjM1IiB5PSI0LjQ4OTE2MzM4NTgyNjc3OCIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSA2OS4zNTE4NyAyNjAuMzM1MTQpIiBmaWxsPSIjNGEzNzFmIiBmaWxsLW9wYWNpdHk9IjEiIGZvbnQtZmFtaWx5PSJzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkb21pbmFudC1iYXNlbGluZT0idGV4dC1iZWZvcmUtZWRnZSI+NTwvdGV4dD48L2c+PGcgZGF0YS12ZWxsdW0tcGFuZWw9ImF4aXMtdGl0bGUteSI+PHRleHQgeD0iMTEuMTc2OTE5MjkxMzM4NTg1IiB5PSIxMTkuNzczODY4MTEwMjM2MjQiIHRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIDEgMjAuNzg3NDAxIDIwLjc4NzQwMSkgcm90YXRlKC05MCAxMS4xNzY5MTkyOTEzMzg1ODUgMTE5Ljc3Mzg2ODExMDIzNjI0KSIgZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIxIiBmb250LWZhbWlseT0ic2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNC42NjY2NjY2NjY2NjY2NjYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGRvbWluYW50LWJhc2VsaW5lPSJjZW50cmFsIj5tcGc8L3RleHQ+PC9nPjxnIGRhdGEtdmVsbHVtLXBhbmVsPSJheGlzLXRpdGxlLXgiPjx0ZXh0IHg9IjI0Mi45MzAzNjQxNzMyMjgzNiIgeT0iMTEuMTc2OTE5MjkxMzM4NTc4IiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxIDY5LjM1MTg3IDI4NS4yNzQ5MykiIGZpbGw9IiMwMDAwMDAiIGZpbGwtb3BhY2l0eT0iMSIgZm9udC1mYW1pbHk9InNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTQuNjY2NjY2NjY2NjY2NjY2IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkb21pbmFudC1iYXNlbGluZT0iY2VudHJhbCI+d3Q8L3RleHQ+PC9nPjxnIGRhdGEtdmVsbHVtLXBhbmVsPSJsZWdlbmQiPjx0ZXh0IHg9IjAiIHk9IjEyLjAzMzc1OTg0MjUxOTY4NCIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSAyNDkuMjU0MTggMzE1LjE4Nzg0KSIgZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIxIiBmb250LWZhbWlseT0ic2Fucy1zZXJpZiIgZm9udC1zaXplPSIxMy4zMzMzMzMzMzMzMzMzMzQiIHRleHQtYW5jaG9yPSJzdGFydCIgZG9taW5hbnQtYmFzZWxpbmU9ImNlbnRyYWwiPmZhY3RvcihjeWwpPC90ZXh0PjxjaXJjbGUgY3g9IjI1Ni44MSIgY3k9IjM0NS40NSIgcj0iNy41NiIgZmlsbD0iIzJmNDg1OCI+PC9jaXJjbGU+PHRleHQgeD0iMjEuMTY1MzU0MzMwNzA4NjYiIHk9IjEwLjIwNDcyNDQwOTQ0ODgzMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSAyNDkuMjU0MTggMzM1LjI0NDEpIiBmaWxsPSIjNGEzNzFmIiBmaWxsLW9wYWNpdHk9IjEiIGZvbnQtZmFtaWx5PSJzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiB0ZXh0LWFuY2hvcj0ic3RhcnQiIGRvbWluYW50LWJhc2VsaW5lPSJjZW50cmFsIj40PC90ZXh0PjxjaXJjbGUgY3g9IjI5OC44MyIgY3k9IjM0NS40NSIgcj0iNy41NiIgZmlsbD0iIzAwNzJiMiI+PC9jaXJjbGU+PHRleHQgeD0iMjEuMTY1MzU0MzMwNzA4NjYiIHk9IjEwLjIwNDcyNDQwOTQ0ODgzMSIgdHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgMSAyOTEuMjcyOSAzMzUuMjQ0MSkiIGZpbGw9IiM0YTM3MWYiIGZpbGwtb3BhY2l0eT0iMSIgZm9udC1mYW1pbHk9InNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTIiIHRleHQtYW5jaG9yPSJzdGFydCIgZG9taW5hbnQtYmFzZWxpbmU9ImNlbnRyYWwiPjY8L3RleHQ+PGNpcmNsZSBjeD0iMzQwLjg1IiBjeT0iMzQ1LjQ1IiByPSI3LjU2IiBmaWxsPSIjMDA5ZTczIj48L2NpcmNsZT48dGV4dCB4PSIyMS4xNjUzNTQzMzA3MDg2NiIgeT0iMTAuMjA0NzI0NDA5NDQ4ODMxIiB0cmFuc2Zvcm09Im1hdHJpeCgxIDAgMCAxIDMzMy4yOTE1NiAzMzUuMjQ0MSkiIGZpbGw9IiM0YTM3MWYiIGZpbGwtb3BhY2l0eT0iMSIgZm9udC1mYW1pbHk9InNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTIiIHRleHQtYW5jaG9yPSJzdGFydCIgZG9taW5hbnQtYmFzZWxpbmU9ImNlbnRyYWwiPjg8L3RleHQ+PC9nPjwvZz48L2c+PC9zdmc+)

Since a theme is an ordinary verb in the pipe, it composes with
everything else and can be shared as a one-function package.

## 3. The interactivity contract

This is the seam that ties all three layers together, and the most
useful one to understand if you build tools on top. Interactivity is not
a feature of `vellumwidget` alone; it is a *contract* carried through
the scene:

- A `vellumplot` mark declares the reserved channels `tooltip`,
  `data_id`, `hover_group`, `hover_color`, and `selected_color`.
- Those are compiled onto the `vellum` grobs as their `key` (identity)
  and `meta` (the rest).
- `vellumwidget` reads them back out of the compiled scene (via
  [`scene_model()`](https://r-vellum.github.io/vellum/reference/scene_model.html))
  and wires up the widget.

The practical consequence: **you can make a bespoke `vellum` scene
interactive without touching `vellumwidget` at all**, just by attaching
`key` and `meta` to your grobs. Every primitive grob accepts them.

``` r

# a hand-built scene whose points are hoverable and selectable
s <- vl_scene(4, 3, bg = "white") |>
  push(vl_viewport(xscale = c(0, 10), yscale = c(0, 10))) |>
  draw(points_grob(
    x = vl_unit(c(2, 5, 8), "native"),
    y = vl_unit(c(3, 7, 4), "native"),
    gp = vl_gpar(fill = "#6b4f2c"),
    key = c("a", "b", "c"),                     # identity for selection
    meta = list(tooltip = c("Alpha", "Beta", "Gamma"))
  ))

as_widget(s)   # tooltips and selection work, no vellumplot involved
```

Because the contract lives in the scene, a mark you invent in
`vellumplot` that sets `tooltip`/`data_id` becomes interactive in
`vellumwidget` automatically, and a grob you build in `vellum` that sets
`key`/`meta` does too. Neither end has to know about the other.

## 4. Teach the ecosystem about your object

The deepest seam is
[`as_vellum_scene()`](https://r-vellum.github.io/vellum/reference/as_vellum_scene.html),
the S7 generic that every consumer calls to turn *something* into a
renderable scene. `vellumplot` registers a method for its plot spec;
that is how
[`render()`](https://r-vellum.github.io/vellum/reference/vl_scene.html)
and `as_widget()` accept a `vellumplot` plot at all. If you have your
own object (a model, a spatial structure, a domain-specific plot type),
you can register a method that compiles it into a `vellum` scene, and
from that moment it renders and becomes interactive through the same
machinery as everything else.

``` r

library(S7)

# a tiny custom object
my_plot <- function(data) structure(list(data = data), class = "my_plot")

# teach the ecosystem how to compile it into a vellum scene
method(as_vellum_scene, new_S3_class("my_plot")) <- function(x, ...) {
  vl_scene(4, 3, bg = "white") |>
    push(vl_viewport(xscale = range(x$data$x), yscale = range(x$data$y))) |>
    draw(points_grob(vl_unit(x$data$x, "native"), vl_unit(x$data$y, "native"),
                     gp = vl_gpar(fill = "#6b4f2c")))
}

p <- my_plot(data.frame(x = 1:10, y = (1:10)^2))

render(p, "custom.png")   # works: render() compiles via as_vellum_scene()
as_widget(p)              # works: vellumwidget compiles via the same seam
```

Registering that one method is what makes
[`render()`](https://r-vellum.github.io/vellum/reference/vl_scene.html),
`render_plot()`, and `as_widget()` all accept your object; they never
see `my_plot`, only the scene it compiles to.

## The picture

The four seams line up with the four layers of reuse:

| you want to reuse | the seam | where it lives |
|----|----|----|
| a piece of drawing | a function returning grobs | `vellum` |
| a look | a function applying `theme()`/`set_theme()` | `vellumplot` |
| interactivity | `key`/`meta` on grobs; `tooltip`/`data_id` on marks | the scene contract |
| a whole new plot type | an [`as_vellum_scene()`](https://r-vellum.github.io/vellum/reference/as_vellum_scene.html) method | the compiler seam |

Each is independent: a composite grob needs no theme, a theme needs no
custom object, and a custom object gets rendering and interactivity for
free the moment it can produce a scene. That independence is the point
of splitting the ecosystem into layers. See [the vellum
ecosystem](https://r-vellum.github.io/vellumverse/articles/ecosystem.md)
and [vellum’s design
principles](https://r-vellum.github.io/vellumverse/articles/design-principles.md)
for the reasoning behind the split.
