context("11-dmdScheme_to_xml()")

test_that(
  "dmdScheme_to_xml() raises error with wrong input value",
  {
    expect_error(
      object = dmdScheme_to_xml(x = dmdScheme_raw),
      regexp = "no applicable method for 'dmdScheme_to_xml' applied to an object of class"
    )
  }
)

test_that(
  "dmdScheme_to_xml() returns expected xml for output = metadata",
  {
    expect_known_output(
      object = dmdScheme_to_xml(x = dmdScheme_example, output = "metadata"),
      file   = "ref-11-dmdScheme_to_xml_metadata.xml",
      print = TRUE,
      update = TRUE
    )
  }
)

test_that(
  "dmdScheme_to_xml() returns expected xml for output = complete",
  {
    expect_known_output(
      object = dmdScheme_to_xml(x = dmdScheme_example, output = "complete" ),
      file   = "ref-11-dmdScheme_to_xml_complete.xml",
      print = TRUE,
      update = TRUE
    )
  }
)


