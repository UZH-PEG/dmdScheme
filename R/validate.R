#' Generic function to validate an object which represents a `dmdScheme`
#'
#' This function validates an object representing a `dmdScheme`.  The result can
#' be used as a basis for a report by running `report()` on the resultiung
#' object of class `dmdScheme_validation`.
#'
#' @param x object referring to a `dmdScheme` to be validatedof class \code{dmdSchemeSet_raw} as returned from \code{read_excel( keepData = FALSE, raw = TRUE)} or file name of an xlsx file containing the metadata.
#' @param path path to the data files
#' @param validateData if \code{TRUE} data is validated as well; the structure is always validated
#' @param errorIfStructFalse if \code{TRUE} an error will be raised if the schemes are not identical, i.e. there are structural differences.
#'
#' @return return the \code{dmdScheme_validation} object
#'
#' @aliases validate
#'
#' @export
#' @md
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
