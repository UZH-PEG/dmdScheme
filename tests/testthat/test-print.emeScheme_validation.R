context("print.emeScheme.validation()")

x <- validate( x = emeScheme_raw, errorIfStructFalse = TRUE)

test_that(
  "print.emeScheme.validation() raises error with wrong type",
  {
    expect_error(
      object = print(x, type = "doodle"),
      regexp = "type has to be `summary` or `details`!"
    )
  }
)



test_that(
  "print.emeScheme.validation() printscorrectly",
  {
    expect_output_file(
      object = print(x),
      file = "print.emeScheme.validation..txt"
    )
  }
)


test_that(
  "print.emeScheme.validation() prints 'type = summary' correctly",
  {
    expect_output_file(
      object = print(x, type = "summary"),
      file = "print.emeScheme.validation.summary.txt"
    )
  }
)


test_that(
  "print.emeScheme.validation() prints 'type = details' correctly",
  {
    expect_output_file(
      object = print(x, type = "details"),
      file = "print.emeScheme.validation.details.txt"
    )
  }
)
