#' Convert older versions to newer versions
#'
#' @param x file name of xml file
#' @param to version to upgrade to. Any version supported is possible, converting to older versions is not supported.
#'
#' @return file name of upgraded xml file (\code{x_to.xml} where \code{x} is the original file name and \code{to} is the new version)
#' @export
#'
#' @examples
xml_upgrade <- function(
  x,
  to = emeSchemeVersions()$emeScheme
) {
  stop("Not implemented yet")
}
