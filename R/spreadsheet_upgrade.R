#' Convert older versions to newer versions
#'
#' @param x file name of spreadsheet
#' @param to version to upgrade to. Any version supported is possible, converting to older versions is not supported.
#'
#' @return file name of upgraded spreadsheet (\code{x_to.xlsx} where \code{x} is the original file name and \code{to} is the new version)
#' @export
#'
#' @examples
spreadsheet_upgrade <- function(
  x,
  to = emeSchemeVersions()$emeScheme
) {
  stop("Not implemented yet")
}
