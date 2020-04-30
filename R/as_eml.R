#' Generic function to convert an object to an object which can be saved as EML
#'
#' @param x object to be converted.
#' @param ... additional arguments for methods
#'
#' @return A \code{list} object which can be converted to EML. It can be
#'   written to a file using \code{write_eml()}. The resulting eml file can be
#'   validated using \code{eml_validate()}.
#'
#'   NB: This does only validate the EML format, and NOT the validation as
#'   defined in the scheme definition package!
#'
#' @rdname as_eml
#'
#' @export
#'
#'
as_eml <- function(
  x,
  ...
) {

  UseMethod("as_eml")

}
