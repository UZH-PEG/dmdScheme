context("emeSchemeToXml()")


test_that(
  "emeSchemeToXml() raises error with wrong input value",
  {
    expect_error(
      object = emeSchemeToXml(x = emeScheme_raw),
      regexp = "no applicable method for 'emeSchemeToXml' applied to an object of class"
    )
  }
)

test_that(
  "emeSchemeToXml() returns expected xml for output = metadata",
  {
    expect_known_value(
      object = emeSchemeToXml(x = emeScheme_example, output = "metadata"  ),
      file   = "emeSchemeToXml_metadata.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeSchemeToXml() returns expected xml for output = complete",
  {
    expect_known_value(
      object = emeSchemeToXml(x = emeScheme_example, output = "complete"  ),
      file   = "emeSchemeToXml_complete.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeSchemeToXml() raises warning with space in tag name",
  {
    expect_warning(
      object = emeSchemeToXml( x = emeScheme_example, tag = "a test" ),
      regexp = "Spaces are not allowed in tag names!"
    )
  }
)

