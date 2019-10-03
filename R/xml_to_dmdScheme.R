#' Convert a exported xml file to a \code{dmdScheme_Set} object
#'
#' The scheme is automatically chosen from the propety \code{propertyName} in
#' the xml file. Nevertheless, the scheme has to be installed, but it does not
#' hav to be loaded. An error is raised if it does not exist.
#'
#'
#' @param x a file containing the xml or an \code{xml_document} object
#' @param useSchemeInXml if \code{TRUE} use scheme definition in xml and raise
#'   an error if the xml does not contain a scheme definition. If False, use the scheme definition from the corresponding
#'   installed package, even if the xml contains a scheme definition. if
#'   \code{NULL} (the default), use the definition in the xml if it is contains a definition,
#'   if not use the corresponding definition from the installed package.
#' @param verbose give verbose progress info. Useful for debugging.
#'
#' @return \code{dmdScheme} or descendant object
#'
#' @importFrom xml2 xml_attrs as_list
#' @export
#'
#' @examples
#' ## x <- dmdScheme_example
#'

xml_to_dmdScheme <- function(
  x,
  onlyScheme = FALSE,
  useSchemeInXml = NULL,
  verbose = FALSE
){

  # Helper functions --------------------------------------------------------

  xmlAttrList <- function(xml) {
    x <- as.list(xml2::xml_attrs(xml))
    for (i in grep(" #%# ", x)) {
      x[[i]] <- strsplit(x[[i]], " #%# ")[[1]]
    }
    return(x)
  }

  checkAttr <- function(xml, x) {
    xmlAtt <- xmlAttrList(xml)
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
      stop("Value of Attribute", names(xmlAtt)[!ok], "is different than expected!")
    }
    return(TRUE)
  }

  # If x is character, load xml from file --------------------------------

  if (is.character(x)) {
    xml <- xml2::read_xml(x)
  } else {
    xml <- x
  }

  # create scheme -----------------------------------------------------------

  complete <- ifelse(
    "output" %in% names(xml2::xml_attrs(xml)),
    xml2::xml_attrs(xml)[["output"]] == "complete",
    FALSE
  )

  if (is.null(useSchemeInXml)) {
    useSchemeInXml <- complete
  }

  if (useSchemeInXml) {
    if (!complete) {
      stop("The xml is not exported with the option 'output = complete' and containds no scheme definition!")
    }
    result <- xml_to_dmdSchemeOnly(xml)
  } else {
    result <- NULL
    try(
      {
        result <- get(eval(xml2::xml_attrs(xml)[["dmdSchemeName"]]))
      }
    )
    # Check if result scheme exists -------------------------------------------

    if (is.null(result)) {
      stop("xml is in a not in a loaded scheme definition.\n",
           "Load the R package containing the scheme before trying again."
      )
    }

    # Check version -----------------------------------------------------------

    if (xml2::xml_attrs(xml)[["dmdSchemeVersion"]] != attr(result, "dmdSchemeVersion")) {
      stop("Version conflict - can not proceed:\n",
           xml, " version : ", xml2::xml_attrs(xml)[["dmdSchemeVersion"]], "\n",
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

  xmlList <- xml2::as_list(xml)[[1]]
  names(xmlList) <- strsplit(attr(xmlList, ".names"), " #%# ")[[1]]
  attr(xmlList, ".names") <- NULL

  # Do the conversion iteratively -------------------------------------------

  TO CONVERT

  for (sheet in names(xmlList)) {
    # Fix names ---------------------------------------------------------------

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



