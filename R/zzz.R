.onAttach <- function(libname, pkgname) {
  # Respect the tidyverse convention: `vellumverse.quiet` silences the startup
  # banner and the conflict report, but the core packages are still attached.
  quiet <- isTRUE(getOption("vellumverse.quiet"))
  if (length(core_unloaded()) == 0) {
    return()
  }

  vellumverse_attach(quiet = quiet)
  if (quiet) {
    return()
  }

  x <- vellumverse_conflicts()
  msg <- vellumverse_conflict_message(x)
  if (!is.null(msg)) {
    packageStartupMessage(paste(msg, collapse = "\n"))
  }
}
