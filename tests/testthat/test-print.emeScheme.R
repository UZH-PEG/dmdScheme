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
      hash = "f936b94001"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TTF",
  {
    expect_known_hash(
      object = capture_output(print(emeScheme_example, printAttr = TRUE, printExtAttr = TRUE, printData = FALSE)),
      hash = "6fc7d3c2d5"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TTT",
  {
    expect_known_hash(
      object = capture_output(print(emeScheme_example, printAttr = TRUE, printExtAttr = TRUE, printData = TRUE)),
      hash = "849a4748e0"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output with no data in some TTT",
  {
    expect_known_hash(
      object = capture_output(print(extract_emeScheme_for_datafile(emeScheme_example, "vid.zip"), printAttr = TRUE, printExtAttr = TRUE, printData = TRUE)),
      hash = "589cf99183"
    )
  }
)
