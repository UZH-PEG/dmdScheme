context("emeSchemeToXml()")

test_that(
  "emeSchemeToXml() raises error with wrong confirmationCode",
  {
    expect_error(
      object = emeSchemeToXml(x = emeScheme_example, confirmationCode = "This is wrong!!!!"),
      regexp = "The supplied confirmation code is not correct. Re-generate the report from the same raw data used for this export."
    )
  }
)

test_that(
  "emeSchemeToXml() raises error with wrong input value",
  {
    expect_error(
      object = emeSchemeToXml(x = emeScheme_raw, confirmationCode = digest::digest(object = emeScheme_raw, algo = "sha1")),
      regexp = "no applicable method for 'emeSchemeToXml' applied to an object of class"
    )
  }
)

test_that(
  "emeSchemeToXml() returns expected xml for output = metadata",
  {
    expect_known_value(
      object = emeSchemeToXml(x = emeScheme_example, output = "metadata", confirmationCode = digest::digest(object = emeScheme_example, algo = "sha1") ),
      file   = "emeSchemeToXml_metadata.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeSchemeToXml() returns expected xml for output = complete",
  {
    expect_known_value(
      object = emeSchemeToXml(x = emeScheme_example, output = "complete", confirmationCode = digest::digest(object = emeScheme_example, algo = "sha1") ),
      file   = "emeSchemeToXml_complete.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeSchemeToXml() raises warning with space in tag name",
  {
    expect_warning(
      object = emeSchemeToXml( x = emeScheme_example, tag = "a test", confirmationCode = digest::digest(object = emeScheme_example, algo = "sha1") ),
      regexp = "Spaces are not allowed in tag names!"
    )
  }
)

