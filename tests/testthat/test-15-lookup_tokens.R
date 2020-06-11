context("15-lookup_tokens()")


# Errors ------------------------------------------------------------------


test_that(
  "wrong scheme argument)",
  {
    expect_error(
      object = lookup_tokens(
        tokens = "irrelevant",
        scheme = letters
      ),
      regexp = "scheme must be a decendant from `dmdSchemeSet`"
    )
  }
)


test_that(
  "non tokens (errors)",
  {
    expect_identical(
      object = lookup_tokens(
        tokens = c(
          "%%*%%",
          "%%ThisIsAnError%%",
          "%%Experiment.ThisIsAnError%%",
          "%%Experiment.ThisIsAnError.2%%",
          "%%Experiment.light.x%%",
          "%%Experiment.light.99%%"
        ),
        scheme = dmdScheme_example()
      ),
      expected = list(
        `%%*%%` = "%%*%%error%%",
        `%%ThisIsAnError%%` = "%%ThisIsAnError.*.*%%error_propertySet%%",
        `%%Experiment.ThisIsAnError%%` = "%%Experiment.ThisIsAnError.*%%error_valueProperty%%",
        `%%Experiment.ThisIsAnError.2%%` = "%%Experiment.ThisIsAnError.2%%error_valueProperty%%",
        `%%Experiment.light.x%%` = "%%Experiment.light.x%%error_index%%",
        `%%Experiment.light.99%%` = "%%Experiment.light.99%%indexToLarge%%"
      )
    )
  }
)


# Special Tokens ----------------------------------------------------------


test_that(
  "special tokens",
  {
    expect_identical(
      object = lookup_tokens(
        tokens = c("%%DATE%%", "%%AUTHOR%%"),
        scheme = dmdScheme_example(),
        author = "Peter Tester"
      ),
      expected = list(
        `%%DATE%%` = format(Sys.Date(), "%Y%-%m-%d"),
        `%%AUTHOR%%` = "Peter Tester"
      )
    )
  }
)


# Normal Tokens -----------------------------------------------------------


test_that(
  "other tokens and wildcards",
  {
    tokens <- c(
      "%%MdAuthors%%",
      "%%MdAuthors.*%%",
      "%%MdAuthors.*.*%%",
      "%%MdAuthors.familyName%%",
      "%%MdAuthors.familyName.*%%",
      "%%MdAuthors.familyName.2%%",
      "%%MdAuthors.*.2%%"
    )
    expect_known_output(
      object = lookup_tokens(
        tokens = tokens,
        scheme = dmdScheme_example(),
        author = "Peter Tester"
      ),
      print = TRUE,
      file = "ref-15-lookup_tokens.txt"
    )
  }
)


# Commans -----------------------------------------------------------------


test_that(
  "other tokens and wildcards",
  {
    tokens <- c(
      "%%MdAuthors.familyName%%",
      "%%!sort!MdAuthors.familyName%%"
    )
    expect_identical(
      object = lookup_tokens(
        tokens = tokens,
        scheme = dmdScheme_example(),
        author = "Peter Tester"
      ),
      expected = list(
        `%%MdAuthors.familyName%%` = c("Petchey", "Krug"),
        `%%!sort!MdAuthors.familyName%%` = c("Krug", "Petchey")
      )
    )
  }
)


