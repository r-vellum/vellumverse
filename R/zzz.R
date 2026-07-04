.onAttach <- function(libname, pkgname) {
  # Respect the tidyverse convention: opt-out of the startup banner.
  needed <- core_unloaded()
  if (length(needed) == 0 || isTRUE(getOption("scriptorium.quiet"))) {
    return()
  }

  scriptorium_attach()

  x <- scriptorium_conflicts()
  msg <- scriptorium_conflict_message(x)
  if (!is.null(msg)) {
    packageStartupMessage(paste(msg, collapse = "\n"))
  }
}
