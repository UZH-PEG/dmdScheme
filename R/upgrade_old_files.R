#' Convert older versions of to newer versions
#'
#' The new file will have new version as a suffix.
#' @param x file name of spreadsheet or of exported xml file
#' @param to version to upgrade to. Any version supported is possible, converting to older versions is not supported.
#'
#' @return file name of upgraded spreadsheet (\code{BASENAME(x).to.EXTENSION(x)} where \code{x} is the original file name and \code{to} is the new version)
#' @export
#'
#' @examples
#' \dontrun{
#' upgrade("dmdScheme.xlsx")
#' upgrade("dmdScheme.xml")
#' }
upgrade_old_files <- function(
  file,
  to = dmdScheme_versions()$scheme
) {
  stop("Upgrade of character (i.e. spreadsheet) not implemented yet!")
}
