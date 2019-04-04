context("read_from_excel()")


# fail because of file -------------------------------------------------------------

test_that(
  "read_from_excel() fails when file does not exist",
  {
    expect_error(
      object = read_from_excel("DOES_NOT_EXIST"),
      regexp = "No such file or directory"
    )
  }
)


test_that(
  "read_from_excel() fails when file does not have right extension",
  {
    expect_error(
      object = read_from_excel(system.file("Dummy_for_tests", package = "emeScheme")),
      regexp = "If x is a file name, it has to have the extension 'xls' or 'xlsx'"
    )
  }
)


# read from xlsx --- value ----------------------------------------------------------

test_that(
  "read_from_excel() keepData and raw",
  {
    expect_known_value(
      object = read_from_excel(
        file = "emeScheme.xlsx",
        keepData = TRUE,
        raw = TRUE,
        verbose = FALSE
      ),
      file = "emeScheme_data_raw.rda"
    )
  }
)

test_that(
  "read_from_excel() keepData and raw",
  {
    expect_known_value(
      object = read_from_excel(
        file = "emeScheme.xlsx",
        keepData = FALSE,
        raw = FALSE,
        verbose = FALSE
      ),
      file = "emeScheme.rda"
    )
  }
)
#

# # read from xlsx --- output -----------------------------------------------
#
# test_that(
#   "read_from_excel() keepData and raw",
#   {
#     expect_known_output(
#       object = read_from_excel(
#         file = system.file("emeScheme.xlsx", package = "emeScheme"),
#         keepData = TRUE,
#         raw = TRUE,
#         verbose = TRUE
#       ),
#       file = "emeScheme_data_raw.output"
#     )
#   }
# )

