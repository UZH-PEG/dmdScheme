context("06-open_new_spreadsheet()")


# x is object -------------------------------------------------------------

fn <- tempfile()

test_that(
  "open_new_spreadsheet() raises error when schemeName is not specified",
  {
    expect_error(
      object = suppressWarnings(open_new_spreadsheet(file = fn, .skipBrowseURL = TRUE)),
      regexp = "Missing schemeName - please provide schemeName!"
    )
  }
)

test_that(
  "open_new_spreadsheet() returns path after saving to file and opening",
  {
    expect_equal(
      object = suppressWarnings(open_new_spreadsheet(schemeName = "dmdScheme", file = fn, .skipBrowseURL = TRUE)),
      expected = fn,
    )
  }
)

test_that(
  "open_new_spreadsheet() reports error when file exist",
  {
    expect_error(
      object = suppressWarnings(open_new_spreadsheet(schemeName = "dmdScheme", file = fn, .skipBrowseURL = TRUE)),
      regexp = "Error during copying of the file from"
    )
  }
)

test_that(
  "open_new_spreadsheet() returns path when file exist and overwrite = TRUE",
  {
    expect_equal(
      object = suppressWarnings(open_new_spreadsheet(schemeName = "dmdScheme", file = fn, overwrite = TRUE, .skipBrowseURL = TRUE)),
      expected = fn,
    )
  }
)

##

test_that(
  "open_new_spreadsheet() returns path when opening template",
  {
    expect_true(
      object = file.exists( suppressWarnings(open_new_spreadsheet(schemeName = "dmdScheme", file = NULL, open = TRUE, overwrite = FALSE, .skipBrowseURL = TRUE) ) )
    )
  }
)

fn <- "test.xlsx"
unlink(fn)
test_that(
  "open_new_spreadsheet() reports correct output when opening file after saving with verbose = TRUE",
  {
    expect_known_output(
      object = suppressWarnings((nfn <- open_new_spreadsheet(schemeName = "dmdScheme", file = fn, open = TRUE, overwrite = FALSE, verbose = FALSE, .skipBrowseURL = TRUE))),
      file   = "ref-06-open_new_spreadsheet_output.txt",
      update = TRUE
    )
    expect_true(
      object = file.exists(nfn),
    )
  }
)
unlink(fn)
#
# test_that(
#   "open_new_spreadsheet() has correct output",
#   {
#     expect_known_output(
#       object = open_new_spreadsheet(verbose = TRUE, .skipBrowseURL = TRUE),
#       file = "open_new_spreadsheet",
#       update = TRUE
#     )
#   }
# )

