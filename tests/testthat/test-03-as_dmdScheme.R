context("03-as_dmdScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "as_dmdScheme() fails when x of wrong class",
  {
    expect_error(
      object = as_dmdScheme(x = "character"),
      regexp = "no applicable method for 'as_dmdScheme' applied to an object of class \"character\""
    )
  }
)


# creates correctly the dmdScheme_example object --------------------------

test_that(
  "as_dmdScheme() `keepData = TRUE`",
  {
    expect_equal(
      object = as_dmdScheme( x = dmdScheme_raw(), keepData = TRUE ),
      expect = dmdScheme_example()
    )
  }
)

test_that(
  "as_dmdScheme() `keepData = FALSE`",
  {
    expect_equal(
      object = as_dmdScheme( x = dmdScheme_raw(), keepData = FALSE ),
      expect = dmdScheme()
    )
  }
)

# # as_dmdScheme --- verbose -----------------------------------------------
#
# test_that(
#   "as_dmdScheme() verbose",
#   {
#     expect_known_output(
#       object = as_dmdScheme( x = dmdScheme_raw(), verbose = TRUE ),
#       file = "ref-03-as_dmdScheme.output"
#     )
#   }
# )
