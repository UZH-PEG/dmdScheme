context("addDataTodmdScheme() x is object")


# x is object -------------------------------------------------------------


test_that(
  "addDataTodmdScheme() returns expected object",
  {
    expect_known_value(
      object = addDataTodmdScheme(x = dmdScheme_raw, s = dmdScheme, dataCol = 1, verbose = FALSE),
      file   = "addDataTodmdScheme.rds",
      update = TRUE
    )
  }
)

test_that(
  "addDataTodmdScheme() outputs the correct info with verbose = TRUE",
  {
    expect_known_output(
      object = addDataTodmdScheme(x = dmdScheme_raw, s = dmdScheme, dataCol = 1, verbose = TRUE),
      file   = "addDataTodmdScheme_output.txt",
      update = TRUE
    )
  }
)


# x is character vector ---------------------------------------------------


context("addDataTodmdScheme() x is character vector")

test_that(
  "addDataTodmdScheme() raises error when x does not exist when x is string",
  {
    expect_error(
      object = addDataTodmdScheme(x = "ThisDoesNotExist", s = dmdScheme, dataCol = 1, verbose = TRUE),
      regexp = "If x is a string, it needs to be the name of an existing file!"
    )
  }
)

test_that(
  "addDataTodmdScheme() raises error when x is not supported",
  {
    expect_error(
      object = addDataTodmdScheme(x = "dummy.for.test", s = dmdScheme, dataCol = 1, verbose = TRUE),
      regexp = "If x is a file name, it has to have the extension '.xlsx'"
    )
  }
)

test_that(
  "addDataTodmdScheme() returns expected object",
  {
    expect_known_value(
      object = addDataTodmdScheme(x = "dmdScheme.xlsx", s = dmdScheme, dataCol = 1, verbose = FALSE),
      file   = "addDataTodmdScheme.rds",
      update = FALSE
    )
  }
)
