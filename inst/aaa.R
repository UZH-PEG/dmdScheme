.onAttach <- function(libname, pkgname) {

  assign(
    x = "scheme_repo",
    value = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/",
    envir = .dmdScheme_cache
  )

  assign(
    x = "defaultSchemeName",
    value = "XXXyyyschemNameyyyXXX",
    envir = .dmdScheme_cache
  )

  assign(
    x = "defaultSchemeVersion",
    value = "XXXyyyschemVersionyyyXXX",
    envir = .dmdScheme_cache
  )

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
