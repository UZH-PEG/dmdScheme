context("04-1-as_eml")

# Errors ------------------------------------------------------------------

test_that(
  "as_eml() raises error with wrong input value",
  {
    expect_error(
      object = as_eml(x = dmdScheme_raw()),
      regexp = "he conversion of the object x of the class `dmdSchemeSet_raw, list` is not supported!"
    )
  }
)





