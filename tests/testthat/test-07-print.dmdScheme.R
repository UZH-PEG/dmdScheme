context("07-print.dmdScheme()")


# fail because of erong type -------------------------------------------------------------

test_that(
  "print.dmdScheme() gives the correct output FFF",
  {
    skip_on_os("windows")
    skip_on_cran()
    expect_known_output(
      object = print(dmdScheme_example(), printAttr = FALSE, printExtAttr = FALSE, printData = FALSE, width = 300),
      file = "ref-07-print.dmdScheme.FFF.txt",
      update = TRUE
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output TFF",
  {
    skip_on_os("windows")
    skip_on_cran()
    expect_known_output(
      object = print(dmdScheme_example(), printAttr = TRUE, printExtAttr = FALSE, printData = FALSE, width = 300),
      file = "ref-07-print.dmdScheme.TFF.txt",
      update = TRUE
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output TTF",
  {
    skip_on_os("windows")
    skip_on_cran()
    expect_known_output(
      object = print(dmdScheme_example(), printAttr = TRUE, printExtAttr = TRUE, printData = FALSE, width = 300),
      file = "ref-07-print.dmdScheme.TTF.txt",
      update = TRUE
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output TTT",
  {
    skip_on_os("windows")
    skip_on_cran()
    expect_known_output(
      object = print(dmdScheme(), printAttr = TRUE, printExtAttr = TRUE, printData = TRUE, width = 300),
      file = "ref-07-print.dmdScheme.TTT.txt",
      update = TRUE
    )
  }
)

test_that(
  "print.dmdScheme() gives the correct output with no data in some TTT",
  {
    skip_on_os("windows")
    skip_on_cran()
    expect_known_output(
      object = print(dmdScheme(), printAttr = TRUE, printExtAttr = TRUE, printData = TRUE, width = 300),
      file = "ref-07-print.dmdScheme.TTT.EMPTY.txt",
      update = TRUE
    )
  }
)
