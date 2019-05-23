context("new_dmdSchemeData()")


# fail because of wrong type -------------------------------------------------------------

test_that(
  "new_dmdSchemeData() fails when x of wrong class",
  {
    expect_error(
      object = new_dmdSchemeData(x = "character"),
      regexp = "x has to inherit from class 'dmdSchemeData_raw'"
    )
  }
)

