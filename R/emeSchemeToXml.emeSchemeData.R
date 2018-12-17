#' Convert \code{emeScheme} object to XML
#'
#' Converts an \code{emeScheme} object into an xml object.
#'
#' Depending on the value of \code{file}, the function returns different results:
#' \itemize{
#'   \item{\code{file} not given: }{an \code{XMLNode} object}
#'   \item{\code{file = NULL}: }{a string characterisation of the \code{XMLNode} object}
#'   \item{\code{file = fileName}: }{saves the string characterisation of the \code{XMLNode} object to an xml file}
#' }
#' Based on David LeBauer, Carl Davidson, Rob Kooper. See \url{https://stackoverflow.com/a/27865512/632423}
#' @param x \code{emeScheme} object to be converted
#' @param tag xml tag of the root level. \bold{Has to be "emeScheme for the initial call!}
#' @param file empty, \code{NULL} or file name. See details below
#' @param output either \code{"metadata"} for export of metadata only or
#'   \code{"complete"} for export including classes et al.
#'
#' @return dependant on the value of \code{file}. See Details
#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
#' @examples
#' x <- addDataToEmeScheme()
#'
#' emeSchemeToXml( x, "GoogleData" )
#' ## returns \code{XMLNode} object
#'
#' emeSchemeToXml( x, "GoogleData", file = NULL )
#' ## returns string representation of the \code{XMLNode} object
#'
emeSchemeToXml.emeSchemeData <- function(
  x,
  tag = "emeScheme",
  file,
  output = "metadata"
) {
  outputValues <- c("metadata", "complete")
  if (!(output %in% outputValues)) {
    stop("Wrong value for 'output'. 'output' has to be one of the following values:", paste(outputValues, collapse = " "))
  }

  if (missing(tag)) {
    tag <- attr(x, "propertyName")
    if (is.null(tag)) {
      tag <- "emeScheme"
    }
  }
  if (grepl(" ", tag)) {
    warning("Spaces are not allowed in tag names!\n  Offending tag = '", tag, "'\n  Replaced spaces with '_'")
    tag <- gsub(" ", "_", tag)
  }

  # x is of type emeSchemeData and therefore a tibble ------------------

  xml <- XML::xmlNode(tag)

  if (length(x) > 1) {
    xmlFields <- lapply(
      names(x),
      function(nm){
        XML::xmlNode(
          nm,
          x[[nm]]
        )
      }
    )
     xml <- XML::append.xmlNode(xml, xmlFields)
  } else {
    xml <- XML::xmlNode(tag, x)
  }

# Add attributes if output == complete ------------------------------------

  if (output == "complete") {
    XML::xmlAttrs(
      node = xml,
      append = TRUE
    ) <- c(
      class = paste(class(x), collapse = ", "),
      names = paste(attr(x, "names"), collapse = ", "),
      unit = paste(attr(x, "unit"), collapse = ", ")
    )
  }

# Return xml --------------------------------------------------------------

  return(xml)
}
