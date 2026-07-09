vellumverse_attach_message <- function(to_load) {
  if (length(to_load) == 0) {
    return(NULL)
  }

  header <- cli::rule(
    left = cli::style_bold("Attaching packages"),
    right = paste0("vellumverse ", package_version_string("vellumverse"))
  )

  versions <- vapply(to_load, function(pkg) {
    paste0(
      cli::col_green(cli::symbol$tick), " ",
      cli::col_blue(format(pkg)), " ",
      cli::ansi_align(package_version_string(pkg), width = 12)
    )
  }, character(1))

  # Lay the package/version cells out in as many columns as the console is wide.
  packages <- to_columns(versions)

  c(header, packages)
}

package_version_string <- function(pkg) {
  version <- utils::packageVersion(pkg)
  if (length(unclass(version)[[1]]) > 3) {
    cli::col_red(as.character(version))
  } else {
    cli::col_silver(as.character(version))
  }
}

# Pack the pre-formatted, ANSI-styled cells into a small grid that fits the
# current console width (falling back to a single column when narrow).
to_columns <- function(cells) {
  n <- length(cells)
  cell_width <- max(cli::ansi_nchar(cells)) + 2L
  width <- cli::console_width()
  ncol <- max(1L, min(n, width %/% cell_width))
  nrow <- ceiling(n / ncol)

  cells <- c(cells, rep("", nrow * ncol - n))
  cells <- matrix(cells, nrow = nrow, byrow = TRUE)

  apply(cells, 1, function(row) {
    paste0(cli::ansi_align(row, width = cell_width), collapse = "")
  })
}
