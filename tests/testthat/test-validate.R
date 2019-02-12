context("validate()")


# returns TRUE -------------------------------------------------------------

test_that(
  "validata_raw() returns correct value when correct",
  {
    expect_known_value(
      object = validate( x = emeScheme_raw, errorIfStructFalse = TRUE),
      file = "validate.CORRECT.rda"
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
      object =  validate( x = x, errorIfStructFalse = FALSE),
      file = "validate.DIFFERENCES.rda"
    )
  }
)

# Fails when not correct -----------------------------------------------

test_that(
  "validata_raw() fails",
  {
    expect_error(
      object = validate( x = x, errorIfStructFalse = TRUE),
      regexp = ("Structure of the object to be evaluated is wrong. See the info above for details.")
    )
  }
)

