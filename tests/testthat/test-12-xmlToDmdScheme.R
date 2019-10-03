context("12-xml_to_dmdScheme()")


test_that(
  "xml_to_dmdScheme() produces correct dmdScheme object",
  {
    expect_equal(
      object = xml_to_dmdScheme("./ref-11-dmdScheme_to_xml_metadata.xml", verbose = FALSE),
      expected = dmdScheme_example
    )
  }
)

