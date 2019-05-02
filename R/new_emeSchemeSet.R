#' Convert the data stored in \code{emeScheme_raw} into a list of tibbles
#'
#' @param x object of class \code{emeSchemeSet_raw} as e.g. returned by \code{read_from_excel(raw = TRUE)}
#' @param keepData if the data should be kept or replaced with one row with NAs
#' @param convertTypes if \code{TRUE}, the types specified in the types column
#'   are used for the data type. Otherwise, they are left at type \code{character}
#' @param verbose give messages to make finding errors in data easier
#' @param warnToError if \code{TRUE}, warnings generated during the conversion will raise an error
#'
#' @return \code{list} of \code{list} of ... \code{tibbles}
#' @export
#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @examples
#' new_emeSchemeSet(emeScheme_raw, keepData = TRUE)
#'
new_emeSchemeSet <- function(
  x,
  keepData = FALSE,
  convertTypes = TRUE,
  verbose = FALSE,
  warnToError = TRUE
) {


# Check for class emeSchemeSet_raw ----------------------------------------

  if (!inherits(x, "emeSchemeSet_raw")) {
    stop("x has to be of class 'emeSchemeSet_raw'")
  }

# Check version -----------------------------------------------------------

  if (emeSchemeVersions()$emeScheme != attr(emeScheme_raw, "emeSchemeVersion")) {
    stop("Version conflict - can not proceed:\n", " x : version ", attr(emeScheme_raw, "emeSchemeVersion"), "\n", "installed emeScheme version : ", emeSchemeVersions()$emeScheme)
  }

# Iterate through emeScheme_raw and create emeSchemeData objects -----------

  result <- lapply(
    x,
    new_emeSchemeData,
    keepData = keepData,
    convertTypes = convertTypes,
    verbose = verbose,
    warnToError = warnToError
  )

# Set attributes ----------------------------------------------------------

attr(result, "propertyName") <- attr(x, "fileName")

# set class ---------------------------------------------------------------

  class(result) <- append(
    c( "emeSchemeSet", "emeScheme" ),
    class(result),
  )

  # Set emeSchemeVersion attribute-------------------------------------------

  attr(result, "emeSchemeVersion") <- attr(x, "emeSchemeVersion")

# Return ------------------------------------------------------------------

  return(result)
}

