context("upgrade_old_files()")


test_that(
  "upgrade_old_files() raises error if file is of wrong extension",
  {
    expect_error(
      object = upgrade_old_files(file = system.file("Dummy_for_tests", package = "dmdScheme")),
      regexp = "x has to have the extension 'xls' 'xlsx' or 'xml'"
    )
  }
)

test_that(
  "upgrade_old_files() raises error if file is of wrong scheme",
  {
    expect_error(
      object = upgrade_old_files(file = system.file("emeScheme.xlsx", package = "dmdScheme")),
      regexp = "The scheme is in a not in a loaded scheme definition."
    )
  }
)

test_that(
  "upgrade_old_files() gives warning and returns `NULL` if same version as current",
  {
    expect_warning(
      object = upgrade_old_files(file = system.file("dmdScheme.xlsx", package = "dmdScheme")),
      regexp = "File has same version as the installed package. No conversion necessary!"
    )
    expect_null(
      object = suppressMessages(upgrade_old_files(file = system.file("dmdScheme.xlsx", package = "dmdScheme")))
    )
  }
)

