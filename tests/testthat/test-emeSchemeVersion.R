context("emeSchemeVersion()")


# Test Arguments -------------------------------------------------------------

test_that(
  "emeSchemeVersion()$emeScheme is equal to the version in the emeScheme",
  {
    expect_equal(
      object = emeSchemeVersions()$emeScheme,
      expected = as.numeric_version(attr(emeScheme, "emeSchemeVersion"))
    )
  }
)

test_that(
  "emeSchemeVersion()$package is equal to packageVersion('emeScheme')",
  {
    expect_equal(
      object = emeSchemeVersions()$package,
      expected = packageVersion("emeScheme")
    )
  }
)
