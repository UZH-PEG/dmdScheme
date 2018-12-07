#' Convert xml to \code{emeScheme}
#'
#' The resulting \code{emeScheme} does only contain the non-missing values which
#' are specified in the xml file.
#' @param xml either xml object or text reresenatation from text object
#'
#' @return \code{emeScheme} object
#'
#' @importFrom XML xmlToList
#' @export
#'
#' @examples
#' x <- addDataToEmeScheme()
#'
#' y <- emeSchemeToXml( x, "GoogleData" )
#' xmlToEmeScheme( y )
#' ## works with an \code{XMLNode} object
#'
#' y <- emeSchemeToXml( x, "GoogleData", file = NULL )
#' xmlToEmeScheme( y )
#' ## works with the string representation of an \code{XMLNode} object
#'

xmlToEmeScheme <- function(
  xml
){

# HELPER: listToTibble to internally convert the tibbles back -------------

  listToTibble <- function(x){
    if (isTRUE(grepl("data.frame", x$.attrs[["class"]]))) {

    } else {
      result <- x
    }
  }


# Do the initial conversion -----------------------------------------------

  result <- XML::xmlToList(xml)

# Do the conversion iteratively -------------------------------------------


# Return ------------------------------------------------------------------

  return(result)
}
