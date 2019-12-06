#' Functions to manage schemes
#'
#' \bold{\code{scheme_active()}:} Shows the name and version of the active scheme.
#' @return \code{data.frame} with two columns containing name and version of the default scheme
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' scheme_active()
#'
scheme_active <- function() {
  return(
    data.frame(
      name = attr(dmdScheme(), "dmdSchemeName"),
      version = attr(dmdScheme(), "dmdSchemeVersion"),
      stringsAsFactors = FALSE)
  )
}
