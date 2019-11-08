context("13-upgrade_old_files()")


test_that(
  "upgrade_old_files() raises error if file is of wrong extension",
  {
    expect_error(
      object = upgrade_old_files(file = tempfile(fileext = ".xxx")),
      regexp = "x has to have the extension 'xls' 'xlsx' or 'xml'"
    )
  }
)



test_that(
  "upgrade_old_files() gives warning and returns `NULL` if same version as current",
  {
    expect_warning(
      object = upgrade_old_files(file = system.file("installedSchemes", paste0(scheme_default(), ".xlsx"), package = "dmdScheme")),
      regexp = "File has same version as the installed package. No conversion necessary!"
    )
    expect_null(
      object = suppressWarnings(upgrade_old_files(file = system.file("installedSchemes", paste0(scheme_default(), ".xlsx"), package = "dmdScheme")))
    )
  }
)

