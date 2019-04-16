context("xmlToEmeScheme()")


test_that(
  "xmlToEmeScheme() produces correct emeScheme object",
  {
    expect_known_value(
      object = xmlToEmeScheme("./abundances.csv_emeScheme.xml", verbose = FALSE),
      file = "abundances.csv_emeScheme.xml.rds",
      update = TRUE
    )
  }
)


emeSchemeToXml(
  xmlToEmeScheme("./abundances.csv_emeScheme.xml", verbose = FALSE),
  confirmationCode = "secret code for testing",
  file = "./abundances.csv_emeScheme.round_robin.xml"
)

test_that(
  "xmlToEmeScheme() round trip",
  {
    expect_equivalent(
      object = md5sum( "./abundances.csv_emeScheme.round_robin.xml" ),
      expected = md5sum( "./abundances.csv_emeScheme.xml" )
    )
  }
)

