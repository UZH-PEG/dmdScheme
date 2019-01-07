context("emeSchemeToXml")


test_that(
  "emeSchemeToXml() raises error with wrong output value",
  {
    expect_error(
      object = emeSchemeToXml(x = addDataToEmeScheme(x = emeScheme_gd, s = emeScheme, dataCol = 1, verbose = FALSE), output = "nonsense"  ),
      regexp = "Wrong value for 'output'. 'output' has to be one of the following values:"
    )
  }
)

test_that(
  "emeSchemeToXml() returns expected xml for output = metadata",
  {
    expect_known_value(
      object = emeSchemeToXml(x = addDataToEmeScheme(x = emeScheme_gd, s = emeScheme, dataCol = 1, verbose = FALSE), output = "metadata"  ),
      file   = "emeSchemeToXml_metadata.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeSchemeToXml() returns expected xml for output = complete",
  {
    expect_known_value(
      object = emeSchemeToXml(x = addDataToEmeScheme(x = emeScheme_gd, s = emeScheme, dataCol = 1, verbose = FALSE), output = "complete"  ),
      file   = "emeSchemeToXml_complete.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeSchemeToXml() raises warning with space in tag name",
  {
    expect_warning(
      object = emeSchemeToXml(
        x = addDataToEmeScheme(x = emeScheme_gd, s = emeScheme, dataCol = 1, verbose = FALSE),
        tag = "a test",
        output = "metadata"
      ),
      regexp = "Spaces are not allowed in tag names!"
    )
  }
)
