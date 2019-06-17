#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @export
#'
new_dmdScheme.dmdSchemeSet_raw <- function(
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
    new_dmdScheme,
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

