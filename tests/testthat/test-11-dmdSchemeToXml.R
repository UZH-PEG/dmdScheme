context("dmdSchemeToXml()")

test_that(
  "dmdSchemeToXml() raises error with wrong input value",
  {
    expect_error(
      object = dmdSchemeToXml(x = dmdScheme_raw),
      regexp = "no applicable method for 'dmdSchemeToXml' applied to an object of class"
    )
  }
)

test_that(
  "dmdSchemeToXml() returns expected xml for output = metadata",
  {
    expect_known_output(
      object = dmdSchemeToXml(x = dmdScheme_example, output = "metadata"),
      file   = "dmdSchemeToXml_metadata.xml",
      print = TRUE,
      update = TRUE
    )
  }
)

test_that(
  "dmdSchemeToXml() returns expected xml for output = complete",
  {
    expect_known_output(
      object = dmdSchemeToXml(x = dmdScheme_example, output = "complete" ),
      file   = "dmdSchemeToXml_complete.xml",
      print = TRUE,
      update = TRUE
    )
  }
)

test_that(
  "dmdSchemeToXml() raises warning with space in tag name",
  {
    expect_warning(
      object = dmdSchemeToXml( x = dmdScheme_example, tag = "a test" ),
      regexp = "Spaces are not allowed in tag names!"
    )
  }
)

