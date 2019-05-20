context("dmdSchemeToXml()")

test_that(
  "dmdSchemeToXml() raises error with wrong confirmationCode",
  {
    expect_error(
      object = dmdSchemeToXml(x = dmdScheme_example, confirmationCode = "This is wrong!!!!"),
      regexp = "The supplied confirmation code is not correct. Re-generate the report from the same raw data used for this export."
    )
  }
)

test_that(
  "dmdSchemeToXml() raises error with wrong input value",
  {
    expect_error(
      object = dmdSchemeToXml(x = dmdScheme_raw, confirmationCode = digest::digest(object = dmdScheme_raw, algo = "sha1")),
      regexp = "no applicable method for 'dmdSchemeToXml' applied to an object of class"
    )
  }
)

test_that(
  "dmdSchemeToXml() returns expected xml for output = metadata",
  {
    expect_known_value(
      object = dmdSchemeToXml(x = dmdScheme_example, output = "metadata", confirmationCode = digest::digest(object = dmdScheme_example, algo = "sha1") ),
      file   = "dmdSchemeToXml_metadata.rds",
      update = TRUE
    )
  }
)

test_that(
  "dmdSchemeToXml() returns expected xml for output = complete",
  {
    expect_known_value(
      object = dmdSchemeToXml(x = dmdScheme_example, output = "complete", confirmationCode = digest::digest(object = dmdScheme_example, algo = "sha1") ),
      file   = "dmdSchemeToXml_complete.rds",
      update = TRUE
    )
  }
)

test_that(
  "dmdSchemeToXml() raises warning with space in tag name",
  {
    expect_warning(
      object = dmdSchemeToXml( x = dmdScheme_example, tag = "a test", confirmationCode = digest::digest(object = dmdScheme_example, algo = "sha1") ),
      regexp = "Spaces are not allowed in tag names!"
    )
  }
)

