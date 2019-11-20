#' @importFrom utils packageDescription
#' @export
#'
.onAttach <- function(libname, pkgname) {
  ver <- utils::packageDescription(
    "dmdScheme",
    fields = c( "schemeName", "schemeVersion" )
  )
  ##
  if ( !scheme_installed( ver$schemeName, ver$schemeVersion) ) {
    dmdScheme::scheme_install(ver$schemeName, ver$schemeVersion, repo = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/")
  }
  scheme_use( name = ver$schemeName, version = ver$schemeVersion)
}
