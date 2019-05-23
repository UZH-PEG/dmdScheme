context("new_dmdSchemeSet()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "new_dmdSchemeSet() fails when x of wrong class",
  {
    expect_error(
      object = new_dmdSchemeSet(x = "character"),
      regexp = "x has to be inherit from class 'dmdSchemeSet_raw'"
    )
  }
)

# new_dmdSchemeSet --- verbose -----------------------------------------------

test_that(
  "new_dmdSchemeSet() verbose",
  {
    expect_known_output(
      object = new_dmdSchemeSet( x = dmdScheme_raw, verbose = TRUE ),
      file = "new_dmdSchemeSet.output"
    )
  }
)
