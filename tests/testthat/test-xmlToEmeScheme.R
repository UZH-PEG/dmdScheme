context("xmlToEmeScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "xmlToEmeScheme() fails because not implemented yet",
  {
    expect_error(
      object = xmlToEmeScheme(),
      regexp = "not implemented yet!"
    )
  }
)

