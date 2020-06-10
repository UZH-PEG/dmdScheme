#' Object of class \code{dmdSchemeSet} containing example data.
#'
#' The dataset contains example data. It was created by using the code below.
#'
#' @export
#' @examples
#' dmdScheme_example()
#'
dmdScheme_example <- function(){
  return( get("dmdScheme_example", envir = .dmdScheme_cache) )
}
