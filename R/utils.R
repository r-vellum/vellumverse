# Small base-R stand-ins for the handful of purrr helpers used by
# vellumverse_conflicts(), so the meta-package stays dependency-light.

purrr_set_names <- function(x) {
  stats::setNames(x, x)
}

purrr_keep <- function(x, p) {
  x[vapply(x, p, logical(1))]
}

purrr_compact <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# Turn a named list of vectors into a list keyed by the values, each entry
# collecting the names that pointed at it -- i.e. for each exported symbol,
# which packages export it.
invert <- function(x) {
  if (length(x) == 0) {
    return(list())
  }

  stacked <- utils::stack(x)
  stacked$ind <- as.character(stacked$ind)
  tapply(stacked$ind, stacked$values, list)
}
