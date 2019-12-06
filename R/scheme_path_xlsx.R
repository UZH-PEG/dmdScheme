#' Functions to manage schemes
#'
#' @return fully qualified path to the \code{xlsx} file containing the scheme definitipn and the example, \code{NULL} if it does not exist.
#' @export
#'
#' @examples
#' scheme_path_xlsx()
#'
scheme_path_xlsx <- function() {
  schemeName <- paste0(scheme_active()$name, "_", scheme_active()$version )

  result <- file.path(cache("installedSchemes"), schemeName, paste0(schemeName, ".xlsx"))

  return(result)
}
