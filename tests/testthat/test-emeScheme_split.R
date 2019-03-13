context("emeScheme_split()")


# Test Arguments -------------------------------------------------------------

test_that(
  "emeScheme_split( ) fails when x of wrong class",
  {
    expect_error(
      object = emeScheme_split( "NOT_VALID"),
      regexp = "x has to be an object of type emeScheme"
    )
  }
)

test_that(
  "emeScheme_split( ) fails when saveAsType not valid",
  {
    expect_error(
      object = emeScheme_split( emeScheme, "NOT_VALID"),
      regexp = "'saveAsType' has to be one of the following values: rds, xml, none"
    )
  }
)

# Estracts and saves without errors ---------------------------------------

## generate updated reference files by running
# emeScheme_split( emeScheme_example, c("rds", "xml"), path = here::here("tests", "testthat"))
##

test_that(
  "emeScheme_split( ) saves rds correctly",
  {
    x <- emeScheme_split( emeScheme_example, c("rds", "xml"), path = tempdir() )
    names(x) <- gsub(tempdir(), ".", x)
    expect_equivalent(
      object = md5sum(x), ## the generated ones
      expected = md5sum(names(x)) # the reference ones stored in the tests directory
    )
  }
)
