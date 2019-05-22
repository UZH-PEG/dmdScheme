context("print.dmdScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "print.dmdScheme() gives the correct output FFF",
  {
    expect_known_output(
      object = print(dmdScheme_example, printAttr = FALSE, printExtAttr = FALSE, printData = FALSE),
      file = "print.dmdScheme.FFF.txt"
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output TFF",
  {
    expect_known_output(
      object = print(dmdScheme_example, printAttr = TRUE, printExtAttr = FALSE, printData = FALSE),
      file = "print.dmdScheme.TFF.txt"
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output TTF",
  {
    expect_known_output(
      object = print(dmdScheme_example, printAttr = TRUE, printExtAttr = TRUE, printData = FALSE),
      file = "print.dmdScheme.TTF.txt"
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output TTT",
  {
    expect_known_output(
      object = print(dmdScheme, printAttr = TRUE, printExtAttr = TRUE, printData = TRUE),
      file = "print.dmdScheme.TTT.txt"
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output with no data in some TTT",
  {
    expect_known_output(
      object = print(dmdScheme, printAttr = TRUE, printExtAttr = TRUE, printData = TRUE),
      file = "print.dmdScheme.TTT.EMPTY.txt"
    )
  }
)
