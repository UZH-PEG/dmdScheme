context("03-as_dmdScheme_raw()")


# fail because of wrong type -------------------------------------------------------------

test_that(
  "as_dmdScheme_raw() fails when x of wrong class",
  {
    expect_error(
      object = as_dmdScheme_raw(x = "character"),
      regexp = "no applicable method for 'as_dmdScheme' applied to an object of class \"character\""
    )
  }
)

skip("To be implemented")

# creates correctly the dmdScheme_example object --------------------------

test_that(
  "as_dmdScheme_raw() `keepData = TRUE`",
  {
    expect_equal(
      object = as_dmdScheme_raw( x = dmdScheme_example, keepData = TRUE ),
      expect = dmdScheme_raw
    )
  }
)

test_that(
  "as_dmdScheme_raw() `keepData = FALSE`",
  {
    expect_equal(
      object = as_dmdScheme( as_dmdScheme_raw( x = dmdScheme_example, keepData = FALSE ) ),
      expect = dmdScheme
    )
  }
)
