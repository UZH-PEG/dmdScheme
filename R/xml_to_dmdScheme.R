#' Convert a exported xml file to a \code{dmdScheme_Set} object
#'
#' The scheme is automatically chosen from the propety \code{propertyName} in
#' the xml file. Nevertheless, the scheme has to be installed, but it does not
#' hav to be loaded. An error is raised if it does not exist.
#'
#'
#' @param file efile containing the xml
#' @param verbose give verbose progress info. Useful for debugging.
#'
#' @return \code{dmdScheme} or descendant object
#'
#' @importFrom XML xmlToList
#' @export
#'
#' @examples
#' ## x <- dmdScheme_example
#'

xml_to_dmdScheme <- function(
  file,
  verbose = FALSE
){

# Do the initial conversion -----------------------------------------------

  xml <- XML::xmlToList(file)

# create result -----------------------------------------------------------

  result <- NULL

  try(
    {
      result <- get(eval(xml$.attrs[["propertyName"]]))
    }
  )

  if (is.null(result)) {
    stop("xml is in a not loaded scheme definition.\n",
         "  Load the R package containing the scheme before trying again."# ,
         # "or define a variable named ", xml$.attrs[["propertyName"]], "which contains your template scheme."
    )
  }

  scheme <- result

# Check version -----------------------------------------------------------

  if (xml$.attrs[["dmdSchemeVersion"]] != attr(scheme, "dmdSchemeVersion")) {
    stop("Version conflict - can not proceed:\n",
         file, " version : ", xml$.attrs[["dmdSchemeVersion"]], "\n",
         "dmdScheme version : ", attr(result, "version"))
  }

# Move .attrs into attributes ---------------------------------------------

  attrs <- xml$.attrs
  xml <- xml[!grepl(".attrs", names(xml))]
  for (a in 1:(length(attrs))) {
    attr(xml, names(attrs)[a]) <- attrs[[a]]
  }

# Check if all objects are also in dmdScheme ------------------------------

  if (!all(names(xml) %in% paste0(names(scheme), "List"))) {
    stop(
      "Nodes of xml file not in dmdScheme.\n",
      "Nodes in xml file  : ", paste(names(xml), collapse = " "), "\n",
      "Names in dmdScheme : ", paste(names(scheme), collapse = " "), "\n"
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

      if (!all(names(x) %in% names(scheme[[sheet]]))) {
        stop(
          "Nodes of xml file not in dmdScheme.\n",
          "Nodes in xml file  : ", paste(names(x), collapse = " "), "\n",
          "Names in dmdScheme : ", paste(names(scheme[[sheet]]), collapse = " "), "\n"
        )
      }

      # add date to result ------------------------------------------------------

      result[[sheet]] <- tibble::add_row(result[[sheet]], !!!unlist(x))
      if (i == 1) {
        result[[sheet]] <- result[[sheet]][-1,]
      }

      # Apply types -------------------------------------------------------------

      if(verbose) message("Apply types...")
      #
      type <- attr(result[[sheet]], "type")
      for (i in 1:ncol(result[[sheet]])) {
        if(verbose) message("   Apply type '", type[i], "' to '", names(result[[sheet]])[[i]], "'...")
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
