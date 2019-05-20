context("xmlTodmdScheme()")


test_that(
  "xmlTodmdScheme() produces correct dmdScheme object",
  {
    expect_known_value(
      object = xmlTodmdScheme("./abundances.csv_dmdScheme.xml", verbose = FALSE),
      file = "abundances.csv_dmdScheme.xml.rds",
      update = TRUE
    )
  }
)


dmdSchemeToXml(
  xmlTodmdScheme("./abundances.csv_dmdScheme.xml", verbose = FALSE),
  confirmationCode = "secret code for testing",
  file = "./abundances.csv_dmdScheme.round_robin.xml"
)

test_that(
  "xmlTodmdScheme() round trip",
  {
    expect_equivalent(
      object = md5sum( "./abundances.csv_dmdScheme.round_robin.xml" ),
      expected = md5sum( "./abundances.csv_dmdScheme.xml" )
    )
  }
)

