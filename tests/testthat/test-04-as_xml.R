context("04-as_xml")

# Errors ------------------------------------------------------------------

test_that(
  "as_xml() raises error with wrong input value",
  {
    expect_error(
      object = as_xml(x = dmdScheme_raw()),
      regexp = "no applicable method for 'as_xml' applied to an object of class"
    )
  }
)

test_that(
  "as_xml() raises error when trying to forced to use scheme in xml but it is not there",
  {
    expect_error(
      object = as_xml(x = dmdScheme_example(), output = "metadata") %>% as_dmdScheme(useSchemeInXml = TRUE),
      regexp = "The xml is not exported with the option 'output = complete' and containds no scheme definition!"
    )
  }
)


# xml round trip `output = complete` ---------------------------------------

test_that(
  "xml round trip `output = complete`",
  {
    expect_equal(
      object = as_xml(x = dmdScheme_example(), output = "complete") %>% as_dmdScheme(keepData = FALSE),
      expected = dmdScheme()
    )
  }
)

# xml round trip `output = metadata`----------------------------------------

test_that(
  "xml round trip `output = metadata`",
  {
    expect_equal(
      object = as_xml(x = dmdScheme_example(), output = "metadata") %>% as_dmdScheme(),
      expected = dmdScheme_example()
    )
  }
)

test_that(
  "xml round trip `output = metadata` and `useSchemeInXml = FALSE`",
  {
    expect_equal(
      object = as_xml(x = dmdScheme_example(), output = "metadata") %>% as_dmdScheme(useSchemeInXml = FALSE),
      expected = dmdScheme_example()
    )
  }
)

# xml round trip `output = complete` --------------------------------------

test_that(
  "xml round trip `output = complete`",
  {
    expect_equal(
      object = as_xml(x = dmdScheme_example(), output = "complete") %>% as_dmdScheme(),
      expected = dmdScheme_example()
    )
  }
)



