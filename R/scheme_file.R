#' Functions to manage schemes
#'
#' \bold{\code{scheme_file()}:} Returns path to the \code{xlsx} file of the currently active scheme.
#' @param type extension of the file to be returned
#' @return fully qualified path to the file of type of the currently active scheme, if it does not exist, an error is raised.
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' scheme_file()
#' scheme_file("xml")
#'
scheme_file <- function(
  type = "xlsx"
) {
  result <- system.file("installedSchemes", paste0(scheme_default()$name, "_", scheme_default()$version, ".", type), package = "dmdScheme")
  if (!file.exists(result)) {
    stop("File does not exist!")
  }
  return(result)
}
