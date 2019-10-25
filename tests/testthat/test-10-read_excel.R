context("10-read_excel()")


# fail because of file -------------------------------------------------------------

test_that(
  "read_excel() fails when file does not exist",
  {
    expect_error(
      object = read_excel("DOES_NOT_EXIST"),
      regexp = "No such file or directory"
    )
  }
)


test_that(
  "read_excel() fails when file does not have right extension",
  {
    expect_error(
      object = read_excel(system.file("Dummy_for_tests", package = "dmdScheme")),
      regexp = "If x is a file name, it has to have the extension 'xls' or 'xlsx'"
    )
  }
)


# read from xlsx --- value ----------------------------------------------------------

test_that(
  "read_excel() `keepData = TRUE` and `raw = TRUE`",
  {
    expect_equal(
      object = read_excel(
        file = system.file("dmdScheme.xlsx", package = "dmdScheme"),
        keepData = TRUE,
        raw = TRUE,
        verbose = FALSE
      ),
      expected = dmdScheme_raw
    )
  }
)

test_that(
  "read_excel() `keepData = TRUE` and `raw = FALSE`",
  {
    expect_equal(
      object = read_excel(
        file = system.file("dmdScheme.xlsx", package = "dmdScheme"),
        keepData = TRUE,
        raw = FALSE,
        verbose = FALSE
      ),
      expected = dmdScheme_example
    )
  }
)

test_that(
  "read_excel() `keepData = FALSE` and `raw = FALSE`",
  {
    expect_equal(
      object = read_excel(
        file = system.file("dmdScheme.xlsx", package = "dmdScheme"),
        keepData = FALSE,
        raw = FALSE,
        verbose = FALSE
      ),
      expected = dmdScheme
    )
  }
)


# Round trip --------------------------------------------------------------

test_that(
  "read_excel() --> write_excel() roundtrip",
  {
    expect_equal(
      object = read_excel( file = write_excel(dmdScheme_example, file = tempfile(fileext = ".xlsx")) ),
      expected = dmdScheme_example
    )
  }
)

