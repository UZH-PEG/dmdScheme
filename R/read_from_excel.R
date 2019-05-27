#' Read scheme data from Excel file
#'
#' Reads the data from an Excel file. TRhe structure of the Excel file has to be
#' \bold{identical} to the one opened by \code{enter_new_metadata()}
#'
#' @param file the name of the Excel file (.xls or .xlsx) containing the data to be
#'   read from.
#' @param keepData if the data in \code{file} should be kept or replaced with
#'   one row with NAs. \code{keepData = FALSE} is only importing the structure
#'   of the \code{dmdScheme} as in the variable \code{dmdScheme}.
#' @param verbose give verbose progress info. Useful for debugging.
#' @param raw if \code{TRUE} the excel file will be read as-is and not converted
#'   to an \code{dmdScheme} object.
#' @param validate Results are usually validated using \code{ validate(
#'   errorIfFalse = TRUE )}. Consequently, an error is raised if the resulting
#'   scheme can not be successfully validated against the one in the package.
#'   There are not many cases where you want to change this value to
#'   \code{FALSE}. But if you do, the result will not be validated. \bold{This
#'   can lead to invalid schemes!}.
#'
#' @return either if \code{raw = TRUE} a list of tibbles from the worksheets of
#'   Class \code{dmdScheme_raw}, otherwise an object of class
#'   \code{dmdSchemeSet}
#'
#' @importFrom magrittr %>% equals not
#' @importFrom readxl read_excel excel_sheets
#' @importFrom tools file_path_sans_ext file_ext
#'
#' @export
#'
#' @examples
#' read_from_excel(file = system.file("dmdScheme.xlsx", package = "dmdScheme"))
#'
read_from_excel <- function(
  file,
  keepData = TRUE,
  verbose = FALSE,
  raw = FALSE,
  validate = TRUE
) {


# Read raw without checks -------------------------------------------------

  result <- read_from_excel_raw(
    file = file,
    keepData = keepData,
    verbose = verbose
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
    result <- new_dmdSchemeSet(
      result,
      keepData = keepData,
      verbose = verbose
    )
  }

# Return result -----------------------------------------------------------

  return(result)
}
