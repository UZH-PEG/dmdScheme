#' Validate Excel workbook or object of class \code{dmdSchemeSet_raw} against \code{dmdScheme}.
#'
#' This function validates either an excel workbook or an object of class
#' \code{dmdScheme_raw} against the definition of the \code{dmdScheme}. It
#' validates the structure, the types, suggested values, ... and returns an object of class \code{dmdScheme_validation}.
#' TODO: DESCRIBE THE CLASS!
#' @param x object of class \code{dmdSchemeSet_raw} as returned from \code{read_from_excel( keepData = FALSE, raw = TRUE)} or file name of an xlsx file containing the metadata.
#' @param path path to the data files
#' @param validateData if \code{TRUE} data is validated as well; the structure is always validated
#' @param errorIfStructFalse if \code{TRUE} an error will be raised if the schemes are not identical, i.e. there are structural differences.
#'
#' @return return the \code{dmdScheme_validation} object
#'
#' @export
#'
#' @examples
#' validate( dmdScheme_raw )
#' \dontrun{
#' validate(
#'    x = dmdScheme_raw,
#'    report = "html",
#'    report_author = "The Author I am",
#'    report_title = "A Nice Report"
#' )
#' }
#'
validate <- function (
  x,
  path = ".",
  validateData = TRUE,
  errorIfStructFalse = TRUE
) {

  # Check arguments ---------------------------------------------------------

  UseMethod("validate", x)

}
