context("enter_new_metadata()")


# x is object -------------------------------------------------------------

fn <- tempfile()

test_that(
  "enter_new_metadata() returns path after saving to file and opening",
  {
    expect_equal(
      object = suppressWarnings(enter_new_metadata(file = fn, .skipBrowseURL = TRUE)),
      expected = fn,
    )
  }
)

test_that(
  "enter_new_metadata() reports error when file exist",
  {
    expect_error(
      object = suppressWarnings(enter_new_metadata(file = fn, .skipBrowseURL = TRUE)),
      regexp = "Error during copying of the file from"
    )
  }
)

test_that(
  "enter_new_metadata() returns path when file exist and overwrite = TRUE",
  {
    expect_equal(
      object = suppressWarnings(enter_new_metadata(file = fn, overwrite = TRUE, .skipBrowseURL = TRUE)),
      expected = fn,
    )
  }
)

##

test_that(
  "enter_new_metadata() returns path when opening template",
  {
    expect_true(
      object = file.exists( suppressWarnings(enter_new_metadata(file = NULL, open = TRUE, overwrite = FALSE, .skipBrowseURL = TRUE) ) )
    )
  }
)

fn <- "test.xlsx"
unlink(fn)
test_that(
  "enter_new_metadata() reports correct output when opening file after saving with verbose = TRUE",
  {
    expect_known_output(
      object = suppressWarnings((nfn <- enter_new_metadata(file = fn, open = TRUE, overwrite = FALSE, verbose = FALSE, .skipBrowseURL = TRUE))),
      file   = "enter_new_metadata_output.txt",
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
#   "enter_new_metadata() has correct output",
#   {
#     expect_known_output(
#       object = enter_new_metadata(verbose = TRUE, .skipBrowseURL = TRUE),
#       file = "enter_new_metadata.output",
#       update = TRUE
#     )
#   }
# )

