context("extract_emeScheme_for_datafile()")

test_that(
  "extract_emeScheme_for_datafile() fails when file is not in dataFile field",
  {
    expect_error(
      object = extract_emeScheme_for_datafile(x = emeScheme_example, file = "not.there"),
      regexp = "'file' has to be file name from the ones specified in"
    )
  }
)


test_that(
  "extract_emeScheme_for_datafile() extracted correctly",
  {
    expect_known_hash(
      object = extract_emeScheme_for_datafile(x = emeScheme_example, file = "data1.csv"),
      hash = "f66fe0fd3c"
    )
  }
)

test_that(
  "extract_emeScheme_for_datafile() extracted correctly even when no data in property set",
  {
    expect_known_hash(
      object = extract_emeScheme_for_datafile(x = emeScheme_example, file = "vid.zip"),
      hash = "abc60ada4c"
    )
  }
)



