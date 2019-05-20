context("dmdScheme_extract()")


# fail because of wrong arguments -------------------------------------------------------------

test_that(
  "dmdScheme_extract( ) fails",
  {
    expect_error(
      object = dmdScheme_extract( ),
      regexp = 'with no default'
    )
  }
)

test_that(
  "dmdScheme_extract( ) fails",
  {
    expect_error(
      object = dmdScheme_extract( dataFile = 1 ),
      regexp = 'dataFile has to be a string'
    )
  }
)

test_that(
  "dmdScheme_extract( ) fails",
  {
    expect_error(
      object = dmdScheme_extract( dataFile = LETTERS ),
      regexp = 'dataFile has to be of length 1'
    )
  }
)

test_that(
  "dmdScheme_extract( ) fails",
  {
    expect_error(
      object = dmdScheme_extract( dataFile = "single", x = "tomate" ),
      regexp = 'x has to be an object of type dmdScheme'
    )
  }
)

# Returns correct objects -------------------------

test_that(
  "dmdScheme_extract( ) returns empty dmdScheme",
  {
    expect_known_value(
      object = dmdScheme_extract( dataFile = "DOES_NOT_EXIST", x = dmdScheme_example ),
      file = "dmdScheme_extract_EMPTY.rds",
      update = TRUE
    )
  }
)

test_that(
  "dmdScheme_extract( ) returns correct data in dmdScheme",
  {
    expect_known_value(
      object = dmdScheme_extract( dataFile = "abundances.csv", x = dmdScheme_example ),
      file = "dmdScheme_extract_abundances.csv.rds",
      update = TRUE
    )
  }
)

