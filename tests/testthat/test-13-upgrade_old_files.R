context("13-upgrade_old_files()")


fn <- tempfile(fileext = ".xxx")
file.create(fn)
test_that(
  "upgrade_old_files() raises error if file is of wrong extension",
  {
    expect_error(
      object = upgrade_old_files(file = fn),
      regexp = "x has to have the extension 'xls' 'xlsx' or 'xml'"
    )
  }
)
unlink(fn)



test_that(
  "upgrade_old_files() gives warning and returns `NULL` if same version as current",
  {
    expect_warning(
      object = upgrade_old_files(file = scheme_path_xlsx()),
      regexp = "File has same version as the installed package. No conversion necessary!"
    )
    expect_null(
      object = suppressWarnings(upgrade_old_files(file = scheme_path_xlsx()))
    )
  }
)

