context("09-print.dmdScheme.validation()")

x <- validate( x = dmdScheme_raw, errorIfStructFalse = TRUE)

test_that(
  "print.dmdScheme.validation() raises error with wrong type",
  {
    expect_error(
      object = print(x, type = "doodle"),
      regexp = "type has to be `default`, summary` or `details`!"
    )
  }
)



test_that(
  "print.dmdScheme.validation() printscorrectly",
  {
    expect_output_file(
      object = print(x),
      file = "ref-09-print.dmdScheme.validation..txt"
    )
  }
)


test_that(
  "print.dmdScheme.validation() prints 'type = summary' correctly",
  {
    expect_output_file(
      object = print(x, type = "summary"),
      file = "ref-09-print.dmdScheme.validation.summary.txt"
    )
  }
)


test_that(
  "print.dmdScheme.validation() prints 'type = details' correctly",
  {
    expect_output_file(
      object = print(x, type = "details"),
      file = "ref-09-print.dmdScheme.validation.details.txt"
    )
  }
)
