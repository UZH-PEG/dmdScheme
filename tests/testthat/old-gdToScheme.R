context("gdToScheme")

test_that(
  "gdToScheme() returns expected scheme from dmdScheme test data",
  {
    expect_known_value(
      object = gdToScheme( x = readRDS("dmdScheme_raw.rds"), debug = FALSE ),
      file   = "dmdScheme.rds",
      update = TRUE
    )
  }
)

test_that(
  "gdToScheme() outputs the correct info with debug = TRUE",
  {
    expect_known_output(
      object = gdToScheme( x = readRDS("dmdScheme_raw.rds"), debug = TRUE ),
      file   = "dmdScheme_output.txt",
      update = TRUE
    )
  }
)
