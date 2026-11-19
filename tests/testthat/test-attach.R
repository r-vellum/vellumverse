test_that("vellumverse_packages() lists the core and (optionally) itself", {
  expect_setequal(
    vellumverse_packages(include_self = FALSE),
    c("vellum", "vellumplot", "vellumwidget")
  )
  expect_true("vellumverse" %in% vellumverse_packages())
  expect_false("vellumverse" %in% vellumverse_packages(include_self = FALSE))
})

test_that("the attach message names the packages being loaded", {
  msg <- cli::ansi_strip(vellumverse_attach_message(c("vellum", "vellumplot")))
  expect_match(msg[[1]], "Attaching packages")
  expect_true(any(grepl("vellum", msg)))
  expect_true(any(grepl("vellumplot", msg)))
})

test_that("nothing to attach yields no message", {
  expect_null(vellumverse_attach_message(character()))
})

test_that("vellumverse_conflicts() returns a printable conflicts object", {
  x <- vellumverse_conflicts()
  expect_s3_class(x, "vellumverse_conflicts")
  expect_output(print(x)) # either "No conflicts." or a conflict list
})

test_that("vellumverse.quiet silences the banner but still attaches the core", {
  attached <- character()
  local_mocked_bindings(
    core_unloaded = function() setdiff(c("vellum", "vellumplot"), attached),
    same_library = function(pkg) attached <<- c(attached, pkg)
  )
  withr::local_options(vellumverse.quiet = TRUE)

  expect_silent(.onAttach(NULL, "vellumverse"))
  expect_setequal(attached, c("vellum", "vellumplot"))
})

test_that("without vellumverse.quiet the banner names the packages", {
  attached <- character()
  local_mocked_bindings(
    core_unloaded = function() setdiff("vellum", attached),
    same_library = function(pkg) attached <<- c(attached, pkg),
    vellumverse_conflicts = function() structure(list(), class = "vellumverse_conflicts"),
    vellumverse_conflict_message = function(x) NULL,
    # expect_message() widens cli's console to integer.max, which a rule
    # cannot render; the banner's own layout is tested above.
    vellumverse_attach_message = function(to_load) "Attaching packages"
  )
  withr::local_options(vellumverse.quiet = NULL)

  expect_message(.onAttach(NULL, "vellumverse"), "Attaching packages")
  expect_equal(attached, "vellum")
})

.fake_conflicts <- function(...) {
  x <- list(...)
  structure(
    stats::setNames(x, vapply(x, function(c) c$name, character(1))),
    class = "vellumverse_conflicts"
  )
}

test_that("conflicts inside the family are summarised on one line", {
  x <- .fake_conflicts(
    list(name = "pdf_pages", pkgs = c("vellumplot", "vellum"), family = TRUE),
    list(name = "render_all", pkgs = c("vellumplot", "vellum"), family = TRUE)
  )
  msg <- cli::ansi_strip(vellumverse_conflict_message(x))
  expect_length(msg, 1L)
  expect_match(msg, "Within the family")
  expect_match(msg, "vellumplot::pdf_pages(), vellumplot::render_all()", fixed = TRUE)
  expect_match(msg, "mask vellum's versions (by design)", fixed = TRUE)
  expect_false(any(grepl("Conflicts", msg)))
})

test_that("a single family overlap reads in the singular", {
  x <- .fake_conflicts(
    list(name = "pdf_pages", pkgs = c("vellumplot", "vellum"), family = TRUE)
  )
  msg <- cli::ansi_strip(vellumverse_conflict_message(x))
  expect_match(msg, "masks vellum's version (by design)", fixed = TRUE)
})

test_that("conflicts with other packages are still listed one per line", {
  x <- .fake_conflicts(
    list(name = "filter", pkgs = c("vellumplot", "stats"), family = FALSE),
    list(name = "pdf_pages", pkgs = c("vellumplot", "vellum"), family = TRUE)
  )
  msg <- cli::ansi_strip(vellumverse_conflict_message(x))
  expect_match(msg[[1]], "Conflicts")
  expect_true(any(grepl("vellumplot::filter masks stats", msg, fixed = TRUE)))
  expect_false(any(grepl("pdf_pages masks", msg, fixed = TRUE)))
  expect_match(msg[[length(msg)]], "Within the family")
})

test_that("vellumverse_conflicts() flags family-only conflicts", {
  x <- vellumverse_conflicts()
  for (conflict in x) {
    expect_identical(
      conflict$family,
      all(conflict$pkgs %in% vellumverse_packages())
    )
  }
})
