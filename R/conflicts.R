#' Conflicts between the vellum ecosystem and other packages
#'
#' `vellumverse_conflicts()` lists every function exported by a core
#' vellum-ecosystem package that is masked by, or masks, a function of the
#' same name attached elsewhere on the search path. It is the equivalent of
#' `tidyverse::tidyverse_conflicts()`, and is also reported automatically
#' when `vellumverse` is attached.
#'
#' Overlaps *within* the ecosystem (a vellumplot function masking a vellum
#' function of the same name that does something different, such as
#' `pdf_pages()`) are by design: they are summarised on a single line rather
#' than listed as conflicts. Identical re-exports are not reported at all.
#'
#' @return An S3 object of class `"vellumverse_conflicts"`, a named list with
#'   one entry per conflicted function: its `name`, the `pkgs` that export it
#'   (in search-path order), and `family`, `TRUE` when every one of those
#'   packages belongs to the vellum ecosystem. Has a print method.
#' @export
#' @examples
#' vellumverse_conflicts()
vellumverse_conflicts <- function() {
  envs <- grep("^package:", search(), value = TRUE)
  envs <- purrr_set_names(envs)
  objs <- invert(lapply(envs, ls_env))

  conflicts <- purrr_keep(objs, function(x) length(x) > 1)

  pkgs <- paste0("package:", vellumverse_packages())
  conflict_funs <- purrr_keep(conflicts, function(pkgs_with) {
    any(pkgs_with %in% pkgs)
  })

  conflict_funs <- lapply(names(conflict_funs), confirm_conflict, conflict_funs)
  conflict_funs <- purrr_compact(conflict_funs)

  structure(
    stats::setNames(conflict_funs, vapply(conflict_funs, function(x) x$name, character(1))),
    class = "vellumverse_conflicts"
  )
}

vellumverse_conflict_message <- function(x) {
  if (length(x) == 0) {
    return(NULL)
  }

  family <- vapply(x, function(conflict) isTRUE(conflict$family), logical(1))
  external <- x[!family]

  lines <- NULL
  if (length(external)) {
    header <- cli::rule(
      left = cli::style_bold("Conflicts"),
      right = "vellumverse_conflicts()"
    )

    pkgs <- lapply(external, function(conflict) conflict$pkgs)
    others <- lapply(pkgs, function(p) p[-1])
    winner <- vapply(pkgs, function(p) p[[1]], character(1))
    funs <- format(vapply(external, function(conflict) conflict$name, character(1)))
    pkg_names <- vapply(others, function(p) {
      paste0(cli::col_blue(p), collapse = ", ")
    }, character(1))

    lines <- c(
      header,
      paste0(
        cli::col_red(cli::symbol$cross), " ",
        cli::col_blue(winner), "::", funs, " masks ", pkg_names
      )
    )
  }

  c(lines, family_conflict_line(x[family]))
}

# One line summarising the overlaps inside the ecosystem (e.g. vellumplot's
# pdf_pages() masking vellum's), which are by design and not worth a line each.
family_conflict_line <- function(x) {
  if (length(x) == 0) {
    return(NULL)
  }
  winners <- vapply(x, function(conflict) conflict$pkgs[[1]], character(1))
  masked <- unique(unlist(lapply(x, function(conflict) conflict$pkgs[-1])))
  funs <- paste0(
    cli::col_blue(winners), "::",
    vapply(x, function(conflict) conflict$name, character(1)), "()"
  )
  paste0(
    cli::col_cyan(cli::symbol$info), " ",
    "Within the family, ", paste(funs, collapse = ", "),
    " mask", if (length(x) == 1) "s" else "", " ",
    paste(cli::col_blue(masked), collapse = ", "), "'s version",
    if (length(x) == 1) "" else "s", " (by design)."
  )
}

confirm_conflict <- function(name, conflicts) {
  pkgs <- conflicts[[name]]

  # Only interested in functions
  objs <- lapply(pkgs, function(pkg) get(name, pos = pkg))
  objs <- purrr_keep(objs, is.function)
  if (length(objs) <= 1) {
    return(NULL)
  }

  # And only when they are actually different functions
  if (length(unique(objs)) == 1) {
    return(NULL)
  }

  pkgs <- gsub("^package:", "", pkgs)
  list(
    name = name,
    pkgs = pkgs,
    family = all(pkgs %in% vellumverse_packages())
  )
}

#' @export
print.vellumverse_conflicts <- function(x, ...) {
  msg <- vellumverse_conflict_message(x)
  if (is.null(msg)) {
    cli::cli_inform("{cli::col_green(cli::symbol$tick)} No conflicts.")
  } else {
    cli::cat_line(msg)
  }
  invisible(x)
}

ls_env <- function(env) {
  ls(pos = env)
}
