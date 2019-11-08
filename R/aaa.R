#' @importFrom utils packageDescription
#' @export
#'
.onAttach <- function(libname, pkgname) {
  ver <- utils::packageDescription(
    "dmdScheme",
    fields = c( "schemeName", "schemeVersion" )
  )
  ##
  scheme_use( name = ver$schemeName, version = ver$schemeVersion)
}
