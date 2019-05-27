context("xmlTodmdScheme()")


test_that(
  "xmlTodmdScheme() produces correct dmdScheme object",
  {
    expect_equal(
      object = xmlTodmdScheme("./ref-11-dmdSchemeToXml_metadata.xml", verbose = FALSE),
      expected = dmdScheme_example
    )
  }
)

