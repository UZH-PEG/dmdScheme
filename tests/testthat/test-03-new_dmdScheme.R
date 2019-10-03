context("03-new_dmdScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "new_dmdScheme() fails when x of wrong class",
  {
    expect_error(
      object = new_dmdScheme(x = "character"),
      regexp = "no applicable method for 'new_dmdScheme' applied to an object of class \"character\""
    )
  }
)

# new_dmdScheme --- verbose -----------------------------------------------

test_that(
  "new_dmdScheme() verbose",
  {
    expect_known_output(
      object = new_dmdScheme( x = dmdScheme_raw, verbose = TRUE ),
      file = "ref-03-new_dmdScheme.output"
    )
  }
)
