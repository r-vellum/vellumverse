#' The core of the vellum ecosystem
#'
#' `scriptorium` bundles the packages that make up the *vellum* graphics
#' ecosystem so they can be installed and loaded in one step, the way
#' `tidyverse` bundles the data-science packages. Attaching `scriptorium`
#' attaches the three core packages:
#'
#' - [vellum][vellum::vellum-package], the low-level graphics backend (a
#'   Rust scene graph, unit/layout engine, and multi-backend renderer).
#' - [quill][quill::quill-package], a pipe-first grammar of graphics that
#'   compiles an inspectable plot spec into a vellum scene.
#' - [gloss][gloss::gloss-package], client-side interactive HTML widgets for
#'   the scenes that vellum and quill produce.
#'
#' @keywords internal
#' @name scriptorium-core
NULL

core <- c("vellum", "quill", "gloss")

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

scriptorium_attach <- function() {
  to_load <- core_unloaded()
  if (length(to_load) == 0) {
    return(invisible())
  }

  cli::cli_inform(
    scriptorium_attach_message(to_load),
    class = "packageStartupMessage"
  )

  suppressPackageStartupMessages(
    lapply(to_load, same_library)
  )

  invisible(to_load)
}

#' List the core vellum-ecosystem packages
#'
#' `scriptorium_packages()` returns the names of the packages that
#' `library(scriptorium)` attaches.
#'
#' @param include_self Whether to include `scriptorium` itself in the list.
#' @return A character vector of package names.
#' @export
#' @examples
#' scriptorium_packages()
scriptorium_packages <- function(include_self = TRUE) {
  names <- core
  if (include_self) {
    names <- c(names, "scriptorium")
  }
  names
}
