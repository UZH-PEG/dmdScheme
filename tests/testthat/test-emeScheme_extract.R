context("emeScheme_extract()")


# fail because of wrong type -------------------------------------------------------------

test_that(
  "emeScheme_extract( ) fails",
  {
    expect_error(
      object = emeScheme_extract( ),
      regexp = 'with no default'
    )
  }
)

test_that(
  "emeScheme_extract( ) fails",
  {
    expect_error(
      object = emeScheme_extract( dataFile = 1 ),
      regexp = 'dataFile has to be a string'
    )
  }
)

test_that(
  "emeScheme_extract( ) fails",
  {
    expect_error(
      object = emeScheme_extract( dataFile = LETTERS ),
      regexp = 'dataFile has to be of length 1'
    )
  }
)

test_that(
  "emeScheme_extract( ) fails",
  {
    expect_error(
      object = emeScheme_extract( dataFile = "single", x = "tomate" ),
      regexp = 'x has to be an object of type emeScheme'
    )
  }
)
