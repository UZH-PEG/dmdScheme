context("print.emeScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "print.emeScheme() gives the correct output FFF",
  {
    expect_known_output(
      object = print(emeScheme_example, printAttr = FALSE, printExtAttr = FALSE, printData = FALSE),
      file = "print.emeScheme.FFF.txt"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TFF",
  {
    expect_known_output(
      object = print(emeScheme_example, printAttr = TRUE, printExtAttr = FALSE, printData = FALSE),
      file = "print.emeScheme.TFF.txt"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TTF",
  {
    expect_known_output(
      object = print(emeScheme_example, printAttr = TRUE, printExtAttr = TRUE, printData = FALSE),
      file = "print.emeScheme.TTF.txt"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output TTT",
  {
    expect_known_output(
      object = print(emeScheme, printAttr = TRUE, printExtAttr = TRUE, printData = TRUE),
      file = "print.emeScheme.TTT.txt"
    )
  }
)

test_that(
  "print.emeScheme() gives the correct output with no data in some TTT",
  {
    expect_known_output(
      object = print(emeScheme, printAttr = TRUE, printExtAttr = TRUE, printData = TRUE),
      file = "print.emeScheme.TTT.EMPTY.txt"
    )
  }
)
