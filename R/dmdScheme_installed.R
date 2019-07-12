#' Find all installed dmdSchemes
#'
#' To find all dmdSchemes, this functions looks at all installed packages and
#' checks if they depend on \code{dmdScheme}. These are identified as
#' dmdSchemes.
#' @return \code{character} matrix in the same format as returned from \code{installed.packages()}
#' @export
#'
#' @examples
#' dmdScheme_installed()
#'
dmdScheme_installed <- function() {
  x <- installed.packages()
  pkgs <- x[grep("dmdScheme", x[,"Depends"]),]
  return( pkgs )
}
