#' Generic method to convert the data stored in the object \code{x} into a new object of class \code{dmdScheme...}
#'
#' Generit methond.
#' @param x object of
#'  * class `dmdSchemeSet_raw` as e.g. returned by \code{read_from_excel(raw = TRUE)}
#'  * class `dmdSchemeData_raw`
#' @param keepData if the data should be kept or replaced with one row with NAs
#' @param convertTypes if \code{TRUE}, the types specified in the types column
#'   are used for the data type. Otherwise, they are left at type
#'   \code{character}
#' @param verbose give verbose progress info. Useful for debugging.
#' @param warnToError if \code{TRUE}, warnings generated during the conversion
#'   will raise an error
#' @param checkVersion if \code{TRUE}, a version mismatch between the package
#'   and the data \code{x} will result in a =n error. If \code{FALSE}, the check
#'   will be skipped.
#'
#' @return \code{list} of \code{list} of ... \code{tibbles}
#'
#' @md
#' @export
#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @examples
#' new_dmdScheme(dmdScheme_raw, keepData = TRUE)
#' new_dmdScheme(dmdScheme_raw$Experiment)
#'
new_dmdScheme <- function(
  x,
  keepData = FALSE,
  convertTypes = TRUE,
  verbose = FALSE,
  warnToError = TRUE,
  checkVersion = TRUE
) {

  UseMethod("new_dmdScheme", x)

}
