context("dmdSchemeToXml")


test_that(
  "dmdSchemeToXml() raises error with wrong output value",
  {
    expect_error(
      object = dmdSchemeToXml(x = addDataTodmdScheme(x = dmdScheme_raw, s = dmdScheme, dataCol = 1, verbose = FALSE), output = "nonsense"  ),
      regexp = "Wrong value for 'output'. 'output' has to be one of the following values:"
    )
  }
)

test_that(
  "dmdSchemeToXml() returns expected xml for output = metadata",
  {
    expect_known_value(
      object = dmdSchemeToXml(x = addDataTodmdScheme(x = dmdScheme_raw, s = dmdScheme, dataCol = 1, verbose = FALSE), output = "metadata"  ),
      file   = "dmdSchemeToXml_metadata.rds",
      update = TRUE
    )
  }
)

test_that(
  "dmdSchemeToXml() returns expected xml for output = complete",
  {
    expect_known_value(
      object = dmdSchemeToXml(x = addDataTodmdScheme(x = dmdScheme_raw, s = dmdScheme, dataCol = 1, verbose = FALSE), output = "complete"  ),
      file   = "dmdSchemeToXml_complete.rds",
      update = TRUE
    )
  }
)

test_that(
  "dmdSchemeToXml() raises warning with space in tag name",
  {
    expect_warning(
      object = dmdSchemeToXml(
        x = addDataTodmdScheme(x = dmdScheme_raw, s = dmdScheme, dataCol = 1, verbose = FALSE),
        tag = "a test",
        output = "metadata"
      ),
      regexp = "Spaces are not allowed in tag names!"
    )
  }
)
