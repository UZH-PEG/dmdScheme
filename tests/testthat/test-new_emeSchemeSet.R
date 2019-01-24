context("new_emeSchemeSet()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "new_emeSchemeSet() fails when x of wrong class",
  {
    expect_error(
      object = new_emeSchemeSet(x = "character"),
      regexp = " has to be of class 'emeSchemeSet_raw'"
    )
  }
)

# new_emeSchemeSet --- verbose -----------------------------------------------

test_that(
  "new_emeSchemeSet() verbose",
  {
    expect_known_output(
      object = new_emeSchemeSet( x = emeScheme_raw, verbose = TRUE ),
      file = "new_emeSchemeSet.output"
    )
  }
)
