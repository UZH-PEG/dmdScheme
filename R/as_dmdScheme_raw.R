#' Generic function to convert the data stored in the object \code{x} into a new object of class \code{dmdScheme_raw...}
#'
#' @param x object to be converted
#' @param keepData if the data should be kept or replaced with one row with NAs
#' @param ... additional arguments for methods
#' @param verbose give verbose progress info. Useful for debugging.
#'
#' @return dmdScheme as object of class \code{dmdScheme_raw}
#'
#' @md
#'
#' @rdname as_dmdScheme_raw
#' @export
#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @examples
#' as_dmdScheme_raw(dmdScheme, keepData = TRUE)
#'
as_dmdScheme_raw <- function(
  x,
  keepData = FALSE,
  ...,
  verbose = FALSE
) {

  UseMethod("as_dmdScheme_raw")

}
