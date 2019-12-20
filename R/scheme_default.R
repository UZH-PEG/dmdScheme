#' Functions to manage schemes
#'
#' \bold{\code{scheme_default()}:} Shows the name of the default scheme which comes with the package and can not be deleted.
#' @return \code{data.frame} with two columns containing name and version of the default scheme
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' scheme_default()
#'
scheme_default <- function() {

  return(
    data.frame(
      name =  get("defaultSchemeName", envir = .dmdScheme_cache),
      version = get("defaultSchemeVersion", envir = .dmdScheme_cache),
      stringsAsFactors = FALSE
    )
  )

}
