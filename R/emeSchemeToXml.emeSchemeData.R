#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
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
