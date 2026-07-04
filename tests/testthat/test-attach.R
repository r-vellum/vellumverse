test_that("scriptorium_packages() lists the core and (optionally) itself", {
  expect_setequal(
    scriptorium_packages(include_self = FALSE),
    c("vellum", "quill", "gloss")
  )
  expect_true("scriptorium" %in% scriptorium_packages())
  expect_false("scriptorium" %in% scriptorium_packages(include_self = FALSE))
})

test_that("the attach message names the packages being loaded", {
  msg <- cli::ansi_strip(scriptorium_attach_message(c("vellum", "quill")))
  expect_match(msg[[1]], "Attaching packages")
  expect_true(any(grepl("vellum", msg)))
  expect_true(any(grepl("quill", msg)))
})

test_that("nothing to attach yields no message", {
  expect_null(scriptorium_attach_message(character()))
})

test_that("scriptorium_conflicts() returns a printable conflicts object", {
  x <- scriptorium_conflicts()
  expect_s3_class(x, "scriptorium_conflicts")
  expect_output(print(x)) # either "No conflicts." or a conflict list
})
