context("format_dmdScheme_xlsx()")

# fail because of file -------------------------------------------------------------

test_that(
  "format_dmdScheme_xlsx() fails when file does not exist",
  {
    expect_error(
      object = format_dmdScheme_xlsx("DOES_NOT_EXIST"),
      regexp = "File does not exist"
    )
  }
)

#
# test_that(
#   "read_from_excel() fails when file does not have right extension",
#   {
#     expect_error(
#       object = read_from_excel(system.file("Dummy_for_tests", package = "dmdScheme")),
#       regexp = "If x is a file name, it has to have the extension 'xls' or 'xlsx'"
#     )
#   }
# )
#
#
# # read from xlsx --- value ----------------------------------------------------------
#
# test_that(
#   "read_from_excel() keepData and raw",
#   {
#     expect_known_value(
#       object = read_from_excel(
#         file = "dmdScheme.xlsx",
#         keepData = TRUE,
#         raw = TRUE,
#         verbose = FALSE
#       ),
#       file = "dmdScheme_data_raw.rda"
#     )
#   }
# )
#
# test_that(
#   "read_from_excel() keepData and raw",
#   {
#     expect_known_value(
#       object = read_from_excel(
#         file = "dmdScheme.xlsx",
#         keepData = FALSE,
#         raw = FALSE,
#         verbose = FALSE
#       ),
#       file = "dmdScheme.rda"
#     )
#   }
# )
# #
#
# # # read from xlsx --- output -----------------------------------------------
# #
# # test_that(
# #   "read_from_excel() keepData and raw",
# #   {
# #     expect_known_output(
# #       object = read_from_excel(
# #         file = system.file("dmdScheme.xlsx", package = "dmdScheme"),
# #         keepData = TRUE,
# #         raw = TRUE,
# #         verbose = TRUE
# #       ),
# #       file = "dmdScheme_data_raw.output"
# #     )
# #   }
# # )
#
