#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @param convertTypes if \code{TRUE}, the types specified in the types column
#'   are used for the data type. Otherwise, they are left at type
#'   \code{character}
#' @param warnToError if \code{TRUE}, warnings generated during the conversion
#'   will raise an error
#' @param checkVersion if \code{TRUE}, a version mismatch between the package
#'   and the data \code{x} will result in an error. If \code{FALSE}, the check
#'   will be skipped.
#'
#' @rdname as_dmdScheme
#' @export
#'
as_dmdScheme.dmdSchemeSet_raw <- function(
  x,
  keepData = FALSE,
  warnToError = TRUE,
  convertTypes = TRUE,
  checkVersion = TRUE,
  ...,
  verbose = FALSE
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
    if (scheme_active()$version != attr(x, "dmdSchemeVersion")) {
      stop("Version conflict - can not proceed:\n", " x : version ", attr(x, "dmdSchemeVersion"), "\n", "installed dmdScheme version : ", scheme_active()$version)
    }
  }

# Iterate through dmdScheme_raw and create dmdSchemeData objects -----------

  result <- lapply(
    names(x),
    function(nm) {
      dd <- as_dmdScheme(
        x = x[[nm]],
        keepData = keepData,
        convertTypes = convertTypes,
        verbose = verbose,
        warnToError = warnToError
      )
      attr(dd, "propertyName") <- nm
      return(dd)
    }
  )
  names(result) <- names(x)

# Set attributes ----------------------------------------------------------

  attr(result, "fileName") <- attr(x, "fileName")
  attr(result, "propertyName") <- attr(x, "propertyName")
  attr(result, "dmdSchemeName") <- attr(x, "dmdSchemeName")

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

