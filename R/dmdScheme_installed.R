#' Find all installed dmdSchemes
#'
#' To find all dmdSchemes, this functions looks at all installed packages and
#' checks if they depend on \code{dmdScheme}. These are identified as
#' dmdSchemes.
#' @return \code{character} vector containing the names of the intalled dmdScheme descendant packages.
#' @export
#'
#' @examples
#' dmdScheme_installed()
#'
dmdScheme_installed <- function() {
  x <- installed.packages()
  pkgs <- c(
    x[grep("dmdScheme", x[,"Depends"]),"Package"],
    "dmdScheme"
  )
  return( pkgs )
}
