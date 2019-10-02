#' @param xml \code{XMLNode} object
#'
#' @importFrom XML xmlToList xmlAttrs xmlApply
#' @importFrom tibble add_column
#'
xml_to_dmdSchemeOnly <- function(xml) {

  # Helper functions --------------------------------------------------------

  xmlAttrList <- function(xml) {
    x <- as.list(xmlAttrs(xml))
    for (i in grep(" #&# ", x)) {
      x[[i]] <- strsplit(x[[i]], " #&# ")[[1]]
    }
    return(x)
  }

  # Do conversion iteratively -----------------------------------------------

  dmdS <- XML::xmlApply(
    xml,
    function(x) {
      atr <- xmlAttrList(x)
      atr <- atr[ !(names(atr) %in% c("row.names", "output")) ]

      # Create tibble with names and type ---------------------------------------

      dmdD <- tibble()
      for (i in 1:length(x[[1]])) {
        dmdD <- tibble::add_column(dmdD, !!(atr$names[i]) := get(atr$type[i])(1))
      }
      dmdD[1,] <- NA

      atr <- atr[ !(names(atr) %in% c("names", "type")) ]

      # Set class ---------------------------------------------------------------

      class(dmdD) <- atr$class

      atr <- atr[ !(names(atr) %in% c("class")) ]

      # Add remaining attributes ------------------------------------------------

      for (a in names(atr)) {
        attr(dmdD, a) <-  atr[[a]]
      }

      # Return dmdSchemeData ----------------------------------------------------

      return(dmdD)
    }
  )

  atr <- xmlAttrList(xml)
  atr <- atr[ !(names(atr) %in% c("row.names", "output")) ]

  # Set class ---------------------------------------------------------------

  class(dmdS) <- atr$class
  atr <- atr[ !(names(atr) %in% c("class")) ]

  # Add remaining attributes ------------------------------------------------

  for (a in names(atr)) {
    attr(dmdS, a) <-  atr[[a]]
  }

  # Return dmdSchemeData ----------------------------------------------------

  return(dmdS)

}
