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
