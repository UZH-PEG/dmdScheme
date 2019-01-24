context("new_emeSchemeData()")


# fail because of wrong type -------------------------------------------------------------

test_that(
  "new_emeSchemeData() fails when x of wrong class",
  {
    expect_error(
      object = new_emeSchemeData(x = "character"),
      regexp = "x has to be of class 'emeSchemeData_raw'"
    )
  }
)

