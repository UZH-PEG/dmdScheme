#' Convert older versions to newer versions
#'
#' @param x \code{emeScheme} object
#' @param to version to upgrade to. Any version supported is possible, converting to older versions is not supported.
#'
#' @return upgraded \code{emeScheme} object of version \code{to}
#' @export
#'
#' @examples
emeScheme_upgrade <- function(
  x,
  to = emeSchemeVersions()$emeScheme
) {
  stop("Not implemented yet")
}
