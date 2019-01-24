#' Validate structure of object of class \code{emeSchemeSet_raw} against \code{emeScheme}.
#'
#' @param x object of class \code{emeSchemeSet_raw} as returned from \code{read_from_excel( keepData = FALSE, raw = TRUE)}
#' @param errorIfFalse if \code{TRUE} an error will be raised if the schemes are nbot identical
#'
#' @return \code{TRUE} if they are identical or character vector describing the differences
#' @export
#'
#' @examples
#' validate_raw( emeScheme_raw )
#'
validate_raw <- function(
  x,
  errorIfFalse = TRUE
  ) {
  result <- all.equal(new_emeSchemeSet( x, keepData = FALSE, verbose = FALSE), emeScheme)
  if (!isTRUE(result) & errorIfFalse){
    cat_ln(result)
    stop("x would result in a scheme which is not identical to the emeScheme!")
  }
  return(result)
}
