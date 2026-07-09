#' The core of the vellum ecosystem
#'
#' `vellumverse` bundles the packages that make up the *vellum* graphics
#' ecosystem so they can be installed and loaded in one step, the way
#' `tidyverse` bundles the data-science packages. Attaching `vellumverse`
#' attaches the three core packages:
#'
#' - [vellum][vellum::vellum-package], the low-level graphics backend (a
#'   Rust scene graph, unit/layout engine, and multi-backend renderer).
#' - [vellumplot][vellumplot::vellumplot-package], a pipe-first grammar of graphics that
#'   compiles an inspectable plot spec into a vellum scene.
#' - [vellumwidget][vellumwidget::vellumwidget-package], client-side interactive HTML widgets for
#'   the scenes that vellum and vellumplot produce.
#'
#' @keywords internal
#' @name vellumverse-core
NULL

core <- c("vellum", "vellumplot", "vellumwidget")

core_unloaded <- function() {
  search <- paste0("package:", core)
  core[!search %in% search()]
}

# Attaching the core, quietly enough that a startup message can be printed
# without a stack of "The following objects are masked" warnings.
same_library <- function(pkg) {
  loc <- if (pkg %in% loadedNamespaces()) dirname(getNamespaceInfo(pkg, "path"))
  library(pkg, lib.loc = loc, character.only = TRUE, warn.conflicts = FALSE)
}

vellumverse_attach <- function() {
  to_load <- core_unloaded()
  if (length(to_load) == 0) {
    return(invisible())
  }

  cli::cli_inform(
    vellumverse_attach_message(to_load),
    class = "packageStartupMessage"
  )

  suppressPackageStartupMessages(
    lapply(to_load, same_library)
  )

  invisible(to_load)
}

#' List the core vellum-ecosystem packages
#'
#' `vellumverse_packages()` returns the names of the packages that
#' `library(vellumverse)` attaches.
#'
#' @param include_self Whether to include `vellumverse` itself in the list.
#' @return A character vector of package names.
#' @export
#' @examples
#' vellumverse_packages()
vellumverse_packages <- function(include_self = TRUE) {
  names <- core
  if (include_self) {
    names <- c(names, "vellumverse")
  }
  names
}
