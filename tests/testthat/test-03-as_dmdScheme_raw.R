context("03-as_dmdScheme_raw()")


# fail because of wrong type -------------------------------------------------------------

test_that(
  "as_dmdScheme_raw() fails when x of wrong class",
  {
    expect_error(
      object = as_dmdScheme_raw(x = "character"),
      regexp = "no applicable method for 'as_dmdScheme_raw' applied to an object of class \"character\""
    )
  }
)


# From dmdScheme ----------------------------------------------------------

test_that(
  "as_dmdScheme_raw.dmdScheme()",
  {
    expect_equal(
      object = as_dmdScheme_raw( x = dmdScheme_example() ),
      expect = dmdScheme_raw()
    )
  }
)


# From xml_document -------------------------------------------------------

test_that(
  "as_dmdScheme_raw.xml_document()",
  {
    expect_equal(
      object = as_dmdScheme( x = as_xml(dmdScheme_example()) ),
      expect = dmdScheme_example()
    )
  }
)

test_that(
  "as_dmdScheme_raw.xml_document()",
  {
    expect_equal(
      object = as_dmdScheme_raw( x = as_xml(dmdScheme_example()) ),
      expect = dmdScheme_raw()
    )
  }
)



