#' Functions to manage schemes
#'
#' \bold{\code{scheme_default()}:} Shows the name of the default scheme which
#' comes with the package and can not be deleted. If \code{name}and
#' \code{version} is specified, the default scheme to be used will be set.
#' \bold{There is no need to do this only internally!}. Otherwise, the scheme
#' repository used is only returned.
#' @return \code{data.frame} with two columns containing name and version of the default scheme
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' scheme_default()
#'
scheme_default <- function(name = NULL, version = NULL) {

  if (!is.null(name) & !is.null(version)) {
    assign(
      x = "default_schemeName",
      value = name,
      envir = .dmdScheme_cache
    )
    assign(
      x = "default_schemeVersion",
      value = version,
      envir = .dmdScheme_cache
    )
  }

  result <- data.frame(
    name =  get("default_schemeName", envir = .dmdScheme_cache),
    version = get("default_schemeVersion", envir = .dmdScheme_cache),
    stringsAsFactors = FALSE
  )

  return(result)

}
