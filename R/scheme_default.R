#' Return name of default schemefor this package
#'
#' Shows the name of the default scheme which comes with the package and can not be deleted.
#' @return name of the default scheme
#'
#' @rdname scheme
#'
#' @export
#'
scheme_default <- function() {
  ver <- utils::packageDescription(
    "dmdScheme",
    fields = c( "schemeName", "schemeVersion" )
  )
  schemeDefinition <- paste0(ver$schemeName, "_", ver$schemeVersion)
  return(schemeDefinition)
}
