context("08-validate()")

x <- dmdScheme_raw()

# returns TRUE -------------------------------------------------------------

  test_that(
    "validata_raw() returns correct value when correct",
    {
      expect_known_value(
        object = validate( x = x, errorIfStructFalse = TRUE),
        file = "ref-08-validate.dmdScheme.CORRECT.rda"
      )
    }
  )

paste0(scheme_default(), ".xlsx")

test_that(
  "validata_raw() returns correct value when correct",
  {
    expect_known_value(
      object = validate( x = scheme_path_xlsx(), errorIfStructFalse = TRUE),
      file = "ref-08-validate.character.CORRECT.rda"
    )
  }
)

# returns differences when not correct -------------------------------------

names(x)[1] <- "experiment"

test_that(
  "validata_raw() fails",
  {
    expect_known_value(
      object =  suppressMessages(validate( x = x, errorIfStructFalse = FALSE)),
      file = "ref-08-validate.DIFFERENCES.rda"
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

# all reports are correctly created -----------------------------------------------

# TODO
