context("addDataToEmeScheme() x is object")


# x is object -------------------------------------------------------------


test_that(
  "addDataToEmeScheme() returns expected object",
  {
    expect_known_value(
      object = addDataToEmeScheme(x = emeScheme_raw, s = emeScheme, dataCol = 1, verbose = FALSE),
      file   = "addDataToEmeScheme.rds",
      update = TRUE
    )
  }
)

test_that(
  "addDataToEmeScheme() outputs the correct info with verbose = TRUE",
  {
    expect_known_output(
      object = addDataToEmeScheme(x = emeScheme_raw, s = emeScheme, dataCol = 1, verbose = TRUE),
      file   = "addDataToEmeScheme_output.txt",
      update = TRUE
    )
  }
)


# x is character vector ---------------------------------------------------


context("addDataToEmeScheme() x is character vector")

test_that(
  "addDataToEmeScheme() raises error when x does not exist when x is string",
  {
    expect_error(
      object = addDataToEmeScheme(x = "ThisDoesNotExist", s = emeScheme, dataCol = 1, verbose = TRUE),
      regexp = "If x is a string, it needs to be the name of an existing file!"
    )
  }
)

test_that(
  "addDataToEmeScheme() raises error when x is not supported",
  {
    expect_error(
      object = addDataToEmeScheme(x = "dummy.for.test", s = emeScheme, dataCol = 1, verbose = TRUE),
      regexp = "If x is a file name, it has to have the extension '.xlsx'"
    )
  }
)

test_that(
  "addDataToEmeScheme() returns expected object",
  {
    expect_known_value(
      object = addDataToEmeScheme(x = "emeScheme.xlsx", s = emeScheme, dataCol = 1, verbose = FALSE),
      file   = "addDataToEmeScheme.rds",
      update = FALSE
    )
  }
)
