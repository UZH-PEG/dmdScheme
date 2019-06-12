#' Convert the data stored in \code{dmdScheme_raw} into a list of tibbles
#'
#' @param x object of class \code{dmdSchemeSet_raw} as e.g. returned by
#'   \code{read_from_excel(raw = TRUE)}
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
#' @export
#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @examples
#' new_dmdSchemeSet(dmdScheme_raw, keepData = TRUE)
#'
new_dmdSchemeSet <- function(
  x,
  keepData = FALSE,
  convertTypes = TRUE,
  verbose = FALSE,
  warnToError = TRUE,
  checkVersion = TRUE
) {


# Check for class dmdSchemeSet_raw ----------------------------------------

  if (!inherits(x, "dmdSchemeSet_raw")) {
    stop("x has to be inherit from class 'dmdSchemeSet_raw'")
  }

# identify class ----------------------------------------------------------

  newClass <- class(x)[[1]]
  newClass <- gsub("_raw", "", newClass)
  if (newClass != "dmdSchemeSet") {
    newClass <- c(newClass, "dmdSchemeSet")
  }

# Check version -----------------------------------------------------------

  if (checkVersion) {
    if (dmdScheme_versions()$scheme != attr(x, "dmdSchemeVersion")) {
      stop("Version conflict - can not proceed:\n", " x : version ", attr(x, "dmdSchemeVersion"), "\n", "installed dmdScheme version : ", dmdScheme_versions()$dmdScheme)
    }
  }

# Iterate through dmdScheme_raw and create dmdSchemeData objects -----------

  result <- lapply(
    x,
    new_dmdSchemeData,
    keepData = keepData,
    convertTypes = convertTypes,
    verbose = verbose,
    warnToError = warnToError
  )

# Set attributes ----------------------------------------------------------

attr(result, "propertyName") <- attr(x, "fileName")

# set class ---------------------------------------------------------------

  class(result) <- append(
    newClass,
    class(result),
  )

  # Set dmdSchemeVersion attribute-------------------------------------------

  attr(result, "dmdSchemeVersion") <- attr(x, "dmdSchemeVersion")

# Return ------------------------------------------------------------------

  return(result)
}

