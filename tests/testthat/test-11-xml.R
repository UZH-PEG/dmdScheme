context("10-xml()")


# fail because of file -------------------------------------------------------------

test_that(
  "read_xml() fails when file does not exist",
  {
    expect_error(
      object = read_xml("DOES_NOT_EXIST"),
      regexp = "'DOES_NOT_EXIST' does not exist in current working directory"
    )
  }
)


test_that(
  "read_xml() fails when file does not have right extension",
  {
    expect_error(
      object = read_xml( scheme_path_xlsx() ),
      regexp = "Start tag expected"
    )
  }
)


# read from xml --- value -----------------------------------------------------------

test_that(
  "read_xml()",
  {
    expect_equal(
      object = read_xml(
        file = scheme_path_xml()
      ),
      expected = dmdScheme_example()
    )
  }
)

# Round trip --------------------------------------------------------------

test_that(
  "read_xml() --> write_xml() roundtrip",
  {
    expect_equal(
      object = dmdScheme_example() %>% write_xml(file = tempfile(fileext = ".xml")) %>% read_xml() %>% `attr<-`("fileName", "none"),
      expected = dmdScheme_example() %>% `attr<-`("fileName", "none")
    )
  }
)

