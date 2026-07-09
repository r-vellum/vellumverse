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
