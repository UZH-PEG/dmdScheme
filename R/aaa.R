.dmdScheme_cache <- new.env(FALSE, parent = globalenv())

.onAttach <- function(libname, pkgname) {

  # Assign default values ---------------------------------------------------

  scheme_repo(
    repo = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/"
  )

  dmdScheme::scheme_default(
    name = "dmdScheme",
    version = "0.9.9"
  )

  # Install and Use default scheme ------------------------------------------

  if (
    !dmdScheme::scheme_installed(
      name = dmdScheme::scheme_default()$name,
      version = dmdScheme::scheme_default()$version
    )
  ) {
    dmdScheme::scheme_install(
      name = dmdScheme::scheme_default()$name,
      version = dmdScheme::scheme_default()$version,
      repo = scheme_repo())
  }

  dmdScheme::scheme_use(
    name = dmdScheme::scheme_default()$name,
    version = dmdScheme::scheme_default()$version
  )

}
