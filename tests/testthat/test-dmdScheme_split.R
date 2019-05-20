context("dmdScheme_split()")


# Test Arguments -------------------------------------------------------------

test_that(
  "dmdScheme_split( ) fails when x of wrong class",
  {
    expect_error(
      object = dmdScheme_split( "NOT_VALID"),
      regexp = "x has to be an object of type dmdScheme"
    )
  }
)

test_that(
  "dmdScheme_split( ) fails when saveAsType not valid",
  {
    expect_error(
      object = dmdScheme_split( dmdScheme, "NOT_VALID"),
      regexp = "'saveAsType' has to be one of the following values: rds, xml, none"
    )
  }
)

# Estracts and saves without errors ---------------------------------------

## generate updated reference files by running
# dmdScheme_split( dmdScheme_example, c("rds", "xml"), path = here::here("tests", "testthat"))
##

test_that(
  "dmdScheme_split( ) saves rds correctly",
  {
    x <- dmdScheme_split( dmdScheme_example, "rds", path = tempdir() )
    ref <- gsub(tempdir(), ".", x)
    expect_equal(
      object = lapply(x, readRDS), ## the generated ones
      expected = lapply(ref, readRDS) # the reference ones stored in the tests directory
    )
  }
)

test_that(
  "dmdScheme_split( ) saves xml correctly",
  {
    x <- dmdScheme_split( dmdScheme_example, "xml", path = tempdir() )
    ref <- gsub(tempdir(), ".", x)
    expect_equal(
      object = lapply(x, readLines), ## the generated ones
      expected = lapply(ref, readLines) # the reference ones stored in the tests directory
    )
  }
)
