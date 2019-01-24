#' Internal only to copy classes when using filter
#'
#' @param vs as iused in \code{dplyr::filter()}
#' @param ... additional arguments for \code{dplyr::filter()}
#'
#' @importFrom dplyr  filter
#'
filter_emeScheme <- function(vs, ...) {
  out <- vs
  class(out) <- class(out)[-1]
  out <- dplyr::filter(out, ...)
  class(out) <- class(vs)
#  mostattributes(out) <- attributes(vs)
  return(out)
}
