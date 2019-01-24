#' Convert the data stored in \code{emeScheme_raw} into a list of tibbles
#'
#' @param x object of class \code{emeSchemeSet_raw} as e.g. returned by \code{read_from_excel(raw = TRUE)}
#' @param verbose give messages to make finding errors in data easier
#' @param keepData if the data should be kept or replaced with one row with NAs
#'
#' @return \code{list} of \code{list} of ... \code{tibbles}
#' @export
#' @importFrom tibble is.tibble as_tibble
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
  verbose = FALSE
) {


# Check for class emeSchemeSet_raw ----------------------------------------

  if (!inherits(x, "emeSchemeSet_raw")) {
    stop("x has to be of class 'emeSchemeSet_raw'")
  }

# Iterate through emeScheme_raw and create emeSchemeData objects -----------

  result <- lapply(
    x,
    new_emeSchemeData,
    keepData = keepData,
    verbose = verbose
  )

# Set attributes ----------------------------------------------------------

attr(result, "propertyName") <- attr(x, "fileName")

# set class ---------------------------------------------------------------

  class(result) <- append(
    c( "emeSchemeSet", "emeScheme" ),
    class(result),
  )

# Return ------------------------------------------------------------------

  return(result)
}

