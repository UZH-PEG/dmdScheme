context("11-xml")

# Errors ------------------------------------------------------------------

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
  "dmdScheme_to_xml() raises error when trying to forced to use scheme in xml but it is not there",
  {
    expect_error(
      object = dmdScheme_to_xml(x = dmdScheme_example, output = "metadata") %>% xml_to_dmdScheme(useSchemeInXml = TRUE),
      regexp = "The xml is not exported with the option 'output = complete' and containds no scheme definition!"
    )
  }
)


# xml round trip `output = complete` ---------------------------------------

test_that(
  "xml round trip `output = complete`",
  {
    expect_equal(
      object = dmdScheme_to_xml(x = dmdScheme, output = "complete") %>% xml_to_dmdSchemeOnly(),
      expected = dmdScheme
    )
  }
)

# xml round trip `output = metadata`----------------------------------------

test_that(
  "xml round trip `output = metadata`",
  {
    expect_equal(
      object = dmdScheme_to_xml(x = dmdScheme_example, output = "metadata") %>% xml_to_dmdScheme(),
      expected = dmdScheme_example
    )
  }
)

test_that(
  "xml round trip `output = metadata` and `useSchemeInXml = FALSE`",
  {
    expect_equal(
      object = dmdScheme_to_xml(x = dmdScheme_example, output = "metadata") %>% xml_to_dmdScheme(useSchemeInXml = FALSE),
      expected = dmdScheme_example
    )
  }
)

# xml round trip `output = complete` --------------------------------------

test_that(
  "xml round trip `output = complete`",
  {
    expect_equal(
      object = dmdScheme_to_xml(x = dmdScheme_example, output = "complete") %>% xml_to_dmdScheme(),
      expected = dmdScheme_example
    )
  }
)

# xml round trip `output = complete` --------------------------------------

test_that(
  "xml round trip `output = complete`",
  {
    expect_equal(
      object = dmdScheme_to_xml(x = system.file("dmdScheme.xlsx", package = "dmdScheme"), output = "complete") %>% xml_to_dmdScheme(),
      expected = dmdScheme_example
    )
  }
)


