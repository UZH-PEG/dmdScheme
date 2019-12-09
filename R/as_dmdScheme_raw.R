#' Generic function to convert the data stored in the object \code{x} into a new object of class \code{dmdScheme_raw...}
#'
#' @param x object to be converted
#' @param ... additional arguments for methods
#'
#' @return dmdScheme as object of class \code{dmdScheme_raw}
#'
#' @md
#'
#' @rdname as_dmdScheme_raw
#' @export
#'
#' @examples
#' as_dmdScheme_raw(dmdScheme(), keepData = TRUE)
#'
as_dmdScheme_raw <- function(
  x,
  ...
) {

  UseMethod("as_dmdScheme_raw")

}
