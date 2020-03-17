#' Read scheme data from Excel file into \code{\link[dmdScheme]{dmdSchemeSet}} object
#'
#' Reads the data from an Excel file. Validation of the scheme version and
#' scheme name is always done. Additional validations are done depending on the
#' arguments \code{validate}. See detals below.
#'
#' @param file the name of the Excel file (.xls or .xlsx) containing the data to
#'   be read.
#' @param keepData if \code{TRUE}, the data in the spreadsheet \code{file} will
#'   be kept (as in \code{\link[dmdScheme]{dmdScheme_example}}. If \code{FALSE}, it will be
#'   replaced with one row with NAs as in \code{dmdScheme}. Only used when
#'   \code{raw == FALSE}.
#' @param verbose give verbose progress info. Useful for debugging.
#' @param raw if \code{TRUE} the imported spreadsheet \code{file} will be
#'   returned as an object of class \code{\link[dmdScheme]{dmdScheme_raw}}. If
#'   \code{FALSE}, it will be converted to an \code{dmdScheme} object.
#' @param validate if \code{TRUE} results are validated using
#'   \code{validate(validateData = FALSE, errorIfStructFalse = TRUE
#'   )}.Consequently, an error is raised if the resulting scheme can not be
#'   successfully validated against the one in the package. There are not many
#'   cases where you want to change this value to \code{FALSE}. But if you do,
#'   the result will not be validated. \bold{This can lead to invalid schemes!}.
#'
#' @return either if \code{raw = TRUE} a list of data.frames from the worksheets of
#'   Class \code{dmdScheme_raw}, otherwise an object of class
#'   \code{dmdSchemeSet}
#'
#' @importFrom magrittr %>% equals not
#' @importFrom tools file_path_sans_ext file_ext
#'
#' @export
#'
#' @examples
#' fn <- scheme_path_xlsx()
#' read_excel(
#'   file = fn
#' )
#'
#' read_excel(
#'   file = fn,
#'   raw = TRUE
#' )
#'
read_excel <- function(
  file,
  keepData = TRUE,
  verbose = FALSE,
  raw = FALSE,
  validate = TRUE
) {


# Read raw checks -------------------------------------------------

  result <- read_excel_raw(
    file = file,
    verbose = verbose,
    checkVersion = TRUE
  )

# Validate imported structure against dmdScheme ---------------------------

  if (validate) {
    validate(
      x = result,
      validateData = FALSE,
      errorIfStructFalse = TRUE
    )
  }

# Convert to dmdScheme if asked for ---------------------------------------

  if (!raw) {
    result <- as_dmdScheme(
      result,
      keepData = keepData,
      verbose = verbose
    )
  }

# Return result -----------------------------------------------------------

  return(result)
}
