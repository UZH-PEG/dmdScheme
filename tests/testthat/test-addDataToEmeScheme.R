context("addDataToEmeScheme()")

test_that(
  "addDataToEmeScheme() returns expected object",
  {
    expect_known_value(
      object = addDataToEmeScheme(x = emeScheme_gd, s = emeScheme, dataCol = 1, verbose = FALSE),
      file   = "addDataToEmeScheme.rds",
      update = FALSE
    )
  }
)

test_that(
  "addDataToEmeScheme() outputs the correct info with verbose = TRUE",
  {
    expect_known_output(
      object = addDataToEmeScheme(x = emeScheme_gd, s = emeScheme, dataCol = 1, verbose = TRUE),
      file   = "addDataToEmeScheme_output.txt",
      update = FALSE
    )
  }
)
