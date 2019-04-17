#' Convert xml to \code{emeScheme}
#'
#' The resulting \code{emeScheme} does only contain the non-missing values which
#' are specified in the xml file.
#'
#' @param xml either xml object or text represenatation from text object
#' @param verbose default: \code{FALSE}; give messages to make finding errors in data easier
#'
#' @return \code{emeScheme} object
#'
#' @importFrom XML xmlToList
#' @export
#'
#' @examples
#' x <- emeScheme_example
#'

xmlToEmeScheme <- function(
  xml,
  verbose = FALSE
){

# create result -----------------------------------------------------------

  result <- emeScheme

# Do the initial conversion -----------------------------------------------

  xml <- XML::xmlToList(xml)

# Check version -----------------------------------------------------------

  if (xml$.attrs["emeSchemeVersion"] != emeSchemeVersions()$emeScheme)
  {
    stop("Version conflict - can not proceed:\n", "xml : version ", xml$.attrs["emeSchemeVersion"], "\n", "installed emeScheme version : ", emeSchemeVersions()$emeScheme)
  }


# Move .attrs into attributes ---------------------------------------------

  attrs <- xml$.attrs
  xml <- xml[!grepl(".attrs", names(xml))]
  for (a in 1:(length(attrs))) {
    attr(xml, names(attrs)[a]) <- attrs[[a]]
  }

# Check if all objects are also in emeScheme ------------------------------

  if (!all(names(xml) %in% paste0(names(emeScheme), "List"))) {
    stop(
      "Nodes of xml file not in emeScheme.\n",
      "Nodes in xml file  : ", paste(names(xml), collapse = " "), "\n",
      "Names in emeScheme : ", paste(names(emeScheme), collapse = " "), "\n"
    )
  }
  names(xml) <- gsub("List", "", names(xml))

# Do the conversion iteratively -------------------------------------------

  for (sheet in names(xml)) {
    for (i in 1:length(xml[[sheet]])) {
      x <- xml[[sheet]][[i]]

      # if exists, move ID field from .attrs to own field -----------------

      if (!is.null(x$.attrs)) {
        x[names(x$.attrs)[1]] <- x$.attrs[1][[1]]
        x <- x[!grepl(".attrs", names(x))]
      }

      if (!all(names(x) %in% names(emeScheme[[sheet]]))) {
        stop(
          "Nodes of xml file not in emeScheme.\n",
          "Nodes in xml file  : ", paste(names(x), collapse = " "), "\n",
          "Names in emeScheme : ", paste(names(emeScheme[[sheet]]), collapse = " "), "\n"
        )
      }

      # add date to result ------------------------------------------------------

      result[[sheet]] <- tibble::add_row(result[[sheet]], !!!unlist(x))
      if (i == 1) {
        result[[sheet]] <- result[[sheet]][-1,]
      }

      # Apply types -------------------------------------------------------------

      if(verbose) cat_ln("Apply types...")
      #
      type <- attr(result[[sheet]], "type")
      for (i in 1:ncol(result[[sheet]])) {
        if(verbose) cat_ln("   Apply type '", type[i], "' to '", names(result[[sheet]])[[i]], "'...")
        #
        result[[sheet]][[i]] <- as(result[[sheet]][[i]], Class = type[i])
      }
    }
  }

# Copy remaining attributes -----------------------------------------------

  cl <- class(result)
  mostattributes(result) <- attributes(xml)
  class(result) <- cl

# Return ------------------------------------------------------------------

  return(result)
}
