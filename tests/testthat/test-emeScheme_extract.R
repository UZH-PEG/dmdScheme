context("emeScheme_extract()")


# fail because of wrong arguments -------------------------------------------------------------

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

# Returns correct objects -------------------------

test_that(
  "emeScheme_extract( ) returns empty emeScheme",
  {
    expect_known_value(
      object = emeScheme_extract( dataFile = "DOES_NOT_EXIST", x = emeScheme_example ),
      file = "emeScheme_extract_EMPTY.rds",
      update = TRUE
    )
  }
)

test_that(
  "emeScheme_extract( ) returns correct data in emeScheme",
  {
    expect_known_value(
      object = emeScheme_extract( dataFile = "abundances.csv", x = emeScheme_example ),
      file = "emeScheme_extract_abundances.csv.rds",
      update = TRUE
    )
  }
)

