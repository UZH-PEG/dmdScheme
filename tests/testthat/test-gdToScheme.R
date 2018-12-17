context("gdToScheme")

test_that(
  "gdToScheme() returns expected scheme from emeScheme test data",
  {
    expect_known_value(
      object = gdToScheme( x = readRDS("emeScheme_gd.rds"), debug = FALSE ),
      file   = "emeScheme.rds",
      update = FALSE
    )
  }
)

test_that(
  "gdToScheme() outputs the correct info with debug = TRUE",
  {
    expect_known_output(
      object = gdToScheme( x = readRDS("emeScheme_gd.rds"), debug = TRUE ),
      file   = "emeScheme_output.txt",
      update = FALSE
    )
  }
)
