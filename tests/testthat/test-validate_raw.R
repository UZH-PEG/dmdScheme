context("validate_raw()")


# returns TRUE -------------------------------------------------------------

test_that(
  "validata_raw() returns TRUE when correct",
  {
    expect_true(
      object = validate_raw( x = emeScheme_raw, errorIfFalse = TRUE)
    )
  }
)


# Fails when not correct -----------------------------------------------

x <- emeScheme_raw
names(x)[1] <- "experiment"
test_that(
  "validata_raw() fails",
  {
    expect_error(
      object = capture.output( validate_raw( x = x, errorIfFalse = TRUE) ),
      regexp = ("x would result in a scheme which is not identical to the emeScheme!")
    )
  }
)

# returns differences when nt correct -------------------------------------

test_that(
  "validata_raw() fails",
  {
    expect_known_value(
      object = validate_raw( x = x, errorIfFalse = FALSE),
      file = "validate_raw.rda",
      update = TRUE
    )
  }
)

