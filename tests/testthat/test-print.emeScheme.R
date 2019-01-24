context("print.emeScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "print.emeScheme() gives the correct output FFF",
  {
    expect_known_hash(
      object = capture_output(print(emeScheme_example, printAttr = FALSE, printExtAttr = FALSE, printData = FALSE)),
      hash = "ba35cdeb0a"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TFF",
  {
    expect_known_hash(
      object = capture_output(print(emeScheme_example, printAttr = TRUE, printExtAttr = FALSE, printData = FALSE)),
      hash = "3bd168a73d"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TTF",
  {
    expect_known_hash(
      object = capture_output(print(emeScheme_example, printAttr = TRUE, printExtAttr = TRUE, printData = FALSE)),
      hash = "d9cdecd7ee"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TTT",
  {
    expect_known_hash(
      object = capture_output(print(emeScheme_example, printAttr = TRUE, printExtAttr = TRUE, printData = TRUE)),
      hash = "b45c60070d"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output with no data in some TTT",
  {
    expect_known_hash(
      object = capture_output(print(extract_emeScheme_for_datafile(emeScheme_example, "vid.zip"), printAttr = TRUE, printExtAttr = TRUE, printData = TRUE)),
      hash = "a32e772546"
    )
  }
)
