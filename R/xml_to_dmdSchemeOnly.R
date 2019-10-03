#' Convert a exported xml file to a \code{dmdScheme} scheme, ignoring the included data
#'
#'
#' @param x a file containing the xml (exported with \code{output = "complete"}
#'   or an \code{xml_document} object (from the \code{xml2} package)
#'
#' @return \code{dmdScheme} or descendant object
#'
#' @importFrom xml2 xml_attr xml_attrs as_list xml_name xml_children xml_length xml_child
#' @importFrom data.table :=
#' @importFrom tibble add_column
#'
#'
xml_to_dmdSchemeOnly <- function(
  x
) {

  # Helper functions --------------------------------------------------------

  xmlAttrList <- function(xml) {
    x <- as.list(xml2::xml_attrs(xml))
    for (i in grep(" #%# ", x)) {
      x[[i]] <- strsplit(x[[i]], " #%# ")[[1]]
    }
    return(x)
  }


  # If x is character, load xml from file --------------------------------

  if (is.character(x)) {
    xml <- xml2::read_xml(x)
  } else {
    xml <- x
  }

  # Check if outup = "complete" ---------------------------------------------
  if (!(xml2::xml_attr(xml, "output") %in% c("complete", "scheme"))) {
    stop("Can not create scheme from this xml!")
  }


  # Do conversion iteratively by ...List ------------------------------------

  dmdS <- list()
  for (i in 1:xml2::xml_length(xml)) {
    List <- xml2::xml_child(xml, i)

    atr <- xmlAttrList(List)
    atr <- atr[ !(names(atr) %in% c("row.names", "output")) ]

    # Create tibble with names and type ---------------------------------------

    dmdD <- tibble()
    for (j in 1:length(atr$names)) {
      dmdD <- tibble::add_column(dmdD, !!(atr$names[j]) := get(atr$type[j])(1))
    }
    dmdD[1,] <- NA

    atr <- atr[ !(names(atr) %in% c("names")) ]

    # Set class ---------------------------------------------------------------

    class(dmdD) <- atr$class

    atr <- atr[ !(names(atr) %in% c("class")) ]

    # Add remaining attributes ------------------------------------------------

    for (a in names(atr)) {
      attr(dmdD, a) <-  atr[[a]]
    }

    # Return dmdSchemeData ----------------------------------------------------

    dmdS[[i]] <- dmdD
  }


# Get Attributes ----------------------------------------------------------

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
