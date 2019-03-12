context("emeScheme_split()")


# fail because of wrong type -------------------------------------------------------------

test_that(
  "emeScheme_split( ) fails when x of wrong class",
  {
    expect_error(
      object = emeScheme_split( "tomate"),
      regexp = "x has to be an object of type emeScheme"
    )
  }
)

