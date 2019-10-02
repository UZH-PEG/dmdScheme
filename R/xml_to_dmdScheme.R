#' Convert a exported xml file to a \code{dmdScheme_Set} object
#'
#' The scheme is automatically chosen from the propety \code{propertyName} in
#' the xml file. Nevertheless, the scheme has to be installed, but it does not
#' hav to be loaded. An error is raised if it does not exist.
#'
#'
#' @param file a file containing the xml or an xml object
#' @param verbose give verbose progress info. Useful for debugging.
#'
#' @return \code{dmdScheme} or descendant object
#'
#' @importFrom XML xmlToList xmlAttrs
#' @export
#'
#' @examples
#' ## x <- dmdScheme_example
#'

xml_to_dmdScheme <- function(
  file,
  onlyScheme = FALSE,
  verbose = FALSE
){

  # Helper functions --------------------------------------------------------

  xmlAttrToAttr <- function(x) {
    x <- as.list(x)
    try(
      { x$names <- strsplit(x$names, " #&# ")[[1]] },
      silent = TRUE
    )
    try(
      { x$class <- strsplit(x$class, " #&# ")[[1]] },
      silent = TRUE
    )
    return(x)
  }

  checkAttr <- function(xml, x) {
    xmlAtt <- xmlAttrToAttr(xmlAttrs(xml))
    xAtt <- attributes(x)
    ###
    xmlAtt <- xmlAtt[ -which( names(xmlAtt) == "output") ]
    ###
    ok <- names(xmlAtt) %in% names(xAtt)
    if (!all(ok)) {
      stop("Attribute", names(xmlAtt)[!ok], "not in scheme definition!")
    }
    ###
    xmlAtt$fileName <- NULL
    xAtt$fileName <- NULL
    ok <- xmlAtt %in% xAtt
    if (!all(ok)) {
      stop("Vallue of Attribute", names(xmlAtt)[!ok], "is different than expected!")
    }
    return(TRUE)
  }

  # If file is character, load xml from file --------------------------------

  if (is.character(file)) {
    xml <- XML::xmlParse(file)
  } else {
    xml <- file
  }

  # create scheme -----------------------------------------------------------

  complete <- ifelse(
    "output" %in% names(xmlAttrs(xml)),
    xmlAttrs(xml)[["output"]] == "complete",
    FALSE
  )

  if (complete) {
    xml_to_dmdSchemeOnly(xml)
  } else {
    result <- NULL
    try(
      {
        result <- get(eval(xmlAttrs(xml)[["dmdSchemeName"]]))
      }
    )
    # Check if result scheme exists -------------------------------------------

    if (is.null(result)) {
      stop("xml is in a not in a loaded scheme definition.\n",
           "Load the R package containing the scheme before trying again."
      )
    }

    # Check version -----------------------------------------------------------

    if (xmlAttrs(xml)[["dmdSchemeVersion"]] != attr(result, "dmdSchemeVersion")) {
      stop("Version conflict - can not proceed:\n",
           xml, " version : ", xmlAttrs(xml)[["dmdSchemeVersion"]], "\n",
           "dmdScheme version : ", attr(result, "version"))
    }

    # Check remaining attributes ----------------------------------------------

    checkAttr(xml, result)

    # Check if all objects are also in dmdScheme ------------------------------

    if (!all(names(xml) %in% paste0(names(result), "List"))) {
      stop(
        "Nodes of xml file not in dmdScheme.\n",
        "Nodes in xml file  : ", paste(names(xml), collapse = " "), "\n",
        "Names in dmdScheme : ", paste(names(result), collapse = " "), "\n"
      )
    }
  }


  # Do the initial conversion to list ---------------------------------------

  xmlList <- XML::xmlToList(xml, addAttributes = TRUE)

  # Do the conversion iteratively -------------------------------------------

  for (sheet in names(xmlList)) {
    # Fix names ---------------------------------------------------------------

    names(xmlList[[sheet]]) <- strsplit(names(xmlList[[sheet]])[[1]], ", ")[[1]]

    if (!all(names(xmlList[[sheet]]) %in% names(result[[sheet]]))) {
      stop(
        "Nodes of xml file not in dmdScheme.\n",
        "Nodes in xml file  : ", paste(names(x), collapse = " "), "\n",
        "Names in dmdScheme : ", paste(names(result[[sheet]]), collapse = " "), "\n"
      )
    }

    for (i in 1:length(xmlList[[sheet]])) {
      # x <- xmlList[[sheet]][[i]]

      ## if exists, move ID field from .attrs to own field -----------------

      # if (!is.null(x$.attrs)) {
      #   x[names(x$.attrs)[1]] <- x$.attrs[1][[1]]
      #   x <- x[!grepl(".attrs", names(x))]
      # }


      # add date to result ------------------------------------------------------

      result[[sheet]] <- tibble::add_row(result[[sheet]], !!!unlist(x))
      if (i == 1) {
        result[[sheet]] <- result[[sheet]][-1,]
      }

      # Apply types -------------------------------------------------------------

      if (verbose) message("Apply types...")
      #
      type <- attr(result[[sheet]], "type")
      for (i in 1:ncol(result[[sheet]])) {
        if (verbose) message("   Apply type '", type[i], "' to '", names(result[[sheet]])[[i]], "'...")
        #
        result[[sheet]][[i]] <- as(result[[sheet]][[i]], Class = type[i])
      }
    }
  }

  # Copy remaining attributes -----------------------------------------------

  cl <- class(result)
  mostattributes(result) <- attributes(xmlList)
  class(result) <- cl

  # Return ------------------------------------------------------------------

  return(result)
}



