context("gdToScheme")

test_that(
  "gdToScheme returns expected scheme from emeScheme test data",
  {
    expect_known_value(
      object = gdToScheme( readRDS("emeScheme_gd.rds") ),
      file   = "emeScheme.rds",
      update = FALSE
    )
  }
)
