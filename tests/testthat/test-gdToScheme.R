context("gdToScheme")

test_that(
  "gdToScheme returns expected scheme from emeScheme test data",
  {
    expect_known_value(
      object = gdToScheme( x = readRDS("emeScheme_gd.rds"), debug = FALSE  ),
      file   = "emeScheme.rds",
      update = FALSE
    )
  }
)
