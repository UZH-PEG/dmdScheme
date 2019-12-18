context("09-print.dmdScheme.validation()")

x <- validate( x = dmdScheme_raw(), errorIfStructFalse = TRUE)

test_that(
  "print.dmdScheme.validation() raises error with wrong type",
  {
    expect_error(
      object = print(x, type = "doodle", width = 300),
      regexp = "type has to be `default`, summary` or `details`!"
    )
  }
)


# because does not workl in oldrel
# test_that(
#   "print.dmdScheme.validation() printscorrectly",
#   {
#     expect_output_file(
#       object = print(x, width = 300),
#       file = "ref-09-print.dmdScheme.validation..txt"
#     )
#   }
# )


test_that(
  "print.dmdScheme.validation() prints 'type = summary' correctly",
  {
    expect_output_file(
      object = print(x, type = "summary", width = 300),
      file = "ref-09-print.dmdScheme.validation.summary.txt"
    )
  }
)


test_that(
  "print.dmdScheme.validation() prints 'type = details' correctly",
  {
    expect_output_file(
      object = print(x, type = "details", width = 300),
      file = "ref-09-print.dmdScheme.validation.details.txt"
    )
  }
)
