#' @importFrom utils packageDescription
#' @export
#'
.onAttach <- function(libname, pkgname) {
  ver <- utils::packageDescription(
    "dmdScheme",
    fields = c( "schemeName", "schemeVersion" )
  )
  schemeDefinition <- paste0(ver$schemeName, "_", ver$schemeVersion, ".xml"
                             )
  scheme_use(schemeDefinition)
}
