context("validate_raw()")


# returns TRUE -------------------------------------------------------------

test_that(
  "validata_raw() returns correct value when correct",
  {
    expect_known_value(
      object = validate_raw( x = emeScheme_raw, errorIfFalse = TRUE),
      file = "validate_raw.CORRECT.rda"
    )
  }
)


# returns differences when nt correct -------------------------------------

x <- emeScheme_raw
names(x)[1] <- "experiment"

test_that(
  "validata_raw() fails",
  {
    expect_known_value(
      object =  validate_raw( x = x, errorIfFalse = FALSE),
      file = "validate_raw.DIFFERENCES.rda"
    )
  }
)

# Fails when not correct -----------------------------------------------

test_that(
  "validata_raw() fails",
  {
    expect_error(
      object = validate_raw( x = x, errorIfFalse = TRUE),
      regexp = ("x would result in a scheme which is not identical to the emeScheme!")
    )
  }
)

