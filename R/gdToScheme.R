#' Convert the data stored in \code{emeScheme_gd} into a list of tibbles
#'
#' TODO: Add attriburtes for repeatability and check if tibble is appropriate (hopefully!!!!)
#'
#' @param x the \code{emeScheme_gd} as a \code{tibble} (as from google docs). The default is usually fine.
#' @param debug should debug and progress mesaages be printed. Default is \code{FALSE}
#'
#' @return \code{list} of \code{list} of ... \code{tibbles}
#' @export
#' @importFrom tibble is.tibble as_tibble
#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#'
#' @examples
#' gdToScheme()
#'
gdToScheme <- function(
  x = emeScheme_gd,
  keepData = FALSE,
  debug = FALSE) {

# Iterate through emeScheme_gd and create emeSchemeData objects -----------

  result <- lapply(
    emeScheme_gd,
    new_emeSchemeData,
    trimToOne = TRUE
  )

# set class ---------------------------------------------------------------

  class(result) <- append(
    c( "emeSchemeSet", "emeScheme" ),
    class(result),
  )

# Return ------------------------------------------------------------------

  return(result)
}

