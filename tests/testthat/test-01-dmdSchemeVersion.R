context("dmdSchemeVersion()")


# Test Arguments -------------------------------------------------------------

test_that(
  "dmdSchemeVersion()$dmdScheme is equal to the version in the dmdScheme",
  {
    expect_equal(
      object = dmdScheme_versions()$scheme,
      expected = as.numeric_version(attr(dmdScheme, "dmdSchemeVersion"))
    )
  }
)

test_that(
  "dmdSchemeVersion()$package is equal to packageVersion('dmdScheme')",
  {
    expect_equal(
      object = dmdScheme_versions()$package,
      expected = packageVersion("dmdScheme")
    )
  }
)
