#' List installed schemes for this package
#'
#' Schemes can be added by using the \link{scheme_add()} function.
#' @return list of schemes installed in the folder \code{system.file("schemeDefinitions", package = "dmdScheme")}
#'
#' @rdname scheme
#'
#' @export
#'
scheme_list <- function() {
  list.files( system.file("schemeDefinitions", package = "dmdScheme") )
}
