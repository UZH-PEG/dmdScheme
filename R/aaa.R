.dmdScheme_cache <- new.env(FALSE, parent = globalenv())

.onAttach <- function(libname, pkgname) {
  assign(
    x = "scheme_repo",
    value = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/",
    envir = .dmdScheme_cache
  )

  ver <- utils::packageDescription(
    utils::packageName(),
    fields = c( "schemeName", "schemeVersion" )
  )


  if ( !dmdScheme::scheme_installed( ver$schemeName, ver$schemeVersion) ) {
    dmdScheme::scheme_install(ver$schemeName, ver$schemeVersion, repo = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/")
  }

  dmdScheme::scheme_use( name = ver$schemeName, version = ver$schemeVersion)

}
