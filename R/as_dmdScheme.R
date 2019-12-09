#' Generic function to convert the data stored in the object \code{x} into a new object of class \code{dmdScheme...}
#'
#' @param x object to be converted
#' @param keepData if the data should be kept or replaced with one row with NAs
#' @param ... additional arguments for methods
#' @param verbose give verbose progress info. Useful for debugging.
#'
#' @return dmdScheme as object of class \code{dmdScheme_set}
#'
#' @md
#'
#' @rdname as_dmdScheme
#' @export
#' @importFrom dplyr select starts_with
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#' @importFrom tools file_ext
#'
#' @examples
#' as_dmdScheme(dmdScheme_raw(), keepData = TRUE)
#' as_dmdScheme(dmdScheme_raw()$Experiment)
#'
as_dmdScheme <- function(
  x,
  keepData = FALSE,
  ...,
  verbose = FALSE
) {

  UseMethod("as_dmdScheme")

}
