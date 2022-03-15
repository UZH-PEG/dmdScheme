
context("12-scheme_ commands")

test_that(
  "scheme_list() returns installed schemes",
  {
    expect_identical(
      object = scheme_list(),
      expected = structure(
        list(
          name = "dmdScheme",
          version = "0.9.9"
        ),
        class = "data.frame",
        row.names = c(NA, -1L)
      )
    )
  }
)

test_that(
  "scheme_list_in_repo() returns installed schemes",
  {
    expect_identical(
      object = scheme_list_in_repo()[[1]],
      expected = list(
        name = "dmdScheme",
        version = "0.9.5",
        description = "Demo scheme from the dmdScheme package in R"
      )
    )
  }
)



test_that(
  "scheme_installed() returns FALSE when not installed",
  {
    expect_false(
      object = scheme_installed("dmdScheme", "0.9.5")
    )
  }
)


test_that(
  "scheme_installed() returns TRUE when not installed",
  {
    expect_true(
      object = scheme_installed("dmdScheme", "0.9.9")
    )
  }
)


# test_that(
#   "scheme_install() installs scheme from repo",
#   {
#     expect_message(
#       object = scheme_install("dmdScheme", "0.9.5"),
#       regexp ="name:    dmdScheme
# version: 0.9.5"
#     )
#   }
# )



# test_that(
#   "scheme_installed() returns TRUE when not installed",
#   {
#     expect_true(
#       object = scheme_installed("dmdScheme", "0.9.9")
#     )
#   }
# )
#
#
#
#
# test_that(
#   "scheme_uninstall() uninstalls scheme",
#   {
#     expect_message(
#       object = scheme_uninstall("dmdScheme", "0.9.5"),
#       regexp ="Scheme dmdScheme_0.9.5 deleted and moved to"
#     )
#   }
# )




test_that(
  "scheme_installed() returns FALSE when not installed",
  {
    expect_false(
      object = scheme_installed("dmdScheme", "0.9.5")
    )
  }
)




test_that(
  "scheme_uninstall() uninstalls gives correct error when already uninstalled",
  {
    expect_error(
      object = scheme_uninstall("dmdScheme", "0.9.5"),
      regexp ="Scheme with the name 'dmdScheme' and version `0.9.5` is not instaled"
    )
  }
)


# test_that(
#   "scheme_install() installs scheme from repo",
#   {
#     expect_message(
#       object = scheme_install("emeScheme", "0.9.5", install_package = TRUE),
#       regexp ="name:    emeScheme
# version: 0.9.5"
#     )
#   }
# )

test_that(
  "scheme_install() gives message when already installed",
  {
    expect_error(
      object = scheme_install("emeScheme", "0.9.5", install_package = TRUE, overwrite = FALSE),
      regexp ="Scheme is already installed! Use `overwrite = TRUE` if you want to overwrite it!"
    )
  }
)

test_that(
  "scheme_install() re-installs scheme from repo",
  {
    expect_message(
      object = scheme_install("emeScheme", "0.9.5", install_package = TRUE, overwrite = TRUE),
      regexp ="name:    emeScheme
version: 0.9.5"
    )
  }
)
