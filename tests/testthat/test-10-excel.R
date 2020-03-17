context("10-excel()")


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
      object = read_excel( scheme_path_xml() ),
      regexp = "If x is a file name, it has to have the extension 'xls' or 'xlsx'"
    )
  }
)


# read raw  from xlsx ----------------------------------------------------------

test_that(
  "read_excel_raw() `keepData = TRUE` and `raw = TRUE`",
  {
    expect_equal(
      object = read_excel_raw(
        file = scheme_path_xlsx(),
        checkVersion = FALSE
      ) %>% `attr<-`("fileName", "none"),
      expected = dmdScheme_raw() %>% `attr<-`("fileName", "none")
    )
  }
)

# read from xlsx --- value ----------------------------------------------------------

test_that(
  "read_excel() `keepData = TRUE` and `raw = TRUE`",
  {
    expect_equal(
      object = read_excel(
        file = scheme_path_xlsx(),
        keepData = TRUE,
        raw = TRUE,
        verbose = FALSE
      ) %>% `attr<-`("fileName", "none"),
      expected = dmdScheme_raw() %>% `attr<-`("fileName", "none")
    )
  }
)

test_that(
  "read_excel() `keepData = TRUE` and `raw = FALSE`",
  {
    expect_equal(
      object = read_excel(
        file = scheme_path_xlsx(),
        keepData = TRUE,
        raw = FALSE,
        verbose = FALSE
      ) %>% `attr<-`("fileName", "none"),
      expected = dmdScheme_example() %>% `attr<-`("fileName", "none")
    )
  }
)

test_that(
  "read_excel() `keepData = FALSE` and `raw = FALSE`",
  {
    expect_equal(
      object = read_excel(
        file = scheme_path_xlsx(),
        keepData = FALSE,
        raw = FALSE,
        verbose = FALSE
      ) %>% `attr<-`("fileName", "none"),
      expected = dmdScheme() %>% `attr<-`("fileName", "none")
    )
  }
)


# Round trip --------------------------------------------------------------

test_that(
  "read_excel() --> write_excel() roundtrip",
  {
    expect_equal(
      object = dmdScheme_example() %>% write_excel(file = tempfile(fileext = ".xlsx")) %>% read_excel() %>% `attr<-`("fileName", "none"),
      expected = dmdScheme_example() %>% `attr<-`("fileName", "none")
    )
  }
)

