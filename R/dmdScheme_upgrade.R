#' Convert older versions to newer versions
#'
#' @param x \code{dmdScheme} object
#' @param to version to upgrade to. Any version supported is possible, converting to older versions is not supported.
#'
#' @return upgraded \code{dmdScheme} object of version \code{to}
#' @export
#'
#' @examples
dmdScheme_upgrade <- function(
  x,
  to = dmdSchemeVersions()$dmdScheme
) {
  stop("Not implemented yet")
}
