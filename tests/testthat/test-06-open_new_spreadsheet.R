context("06-open_new_spreadsheet()")

# x is object -------------------------------------------------------------

fn <- tempfile()

test_that(
  "open_new_spreadsheet() returns path after saving to file and opening - `format = TRUE`",
  {
    expect_equal(
      object = suppressWarnings(open_new_spreadsheet(file = fn, format = TRUE, .skipBrowseURL = TRUE)),
      expected = fn,
    )
  }
)

test_that(
  "open_new_spreadsheet() reports error when file exist",
  {
    expect_error(
      object = suppressWarnings(open_new_spreadsheet(file = fn, format = FALSE, .skipBrowseURL = TRUE)),
      regexp = "Error during copying of the file from"
    )
  }
)

test_that(
  "open_new_spreadsheet() returns path when file exist and overwrite = TRUE",
  {
    expect_equal(
      object = suppressWarnings(open_new_spreadsheet(file = fn, format = FALSE, overwrite = TRUE, .skipBrowseURL = TRUE)),
      expected = fn,
    )
  }
)

##

test_that(
  "open_new_spreadsheet() creates file",
  {
    expect_true(
      object = file.exists( suppressWarnings(open_new_spreadsheet(file = NULL, format = FALSE, open = TRUE, overwrite = FALSE, .skipBrowseURL = TRUE) ) )
    )
  }
)

unlink(fn)

