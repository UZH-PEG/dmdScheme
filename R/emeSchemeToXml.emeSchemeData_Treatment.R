#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
emeSchemeToXml.emeSchemeData_Treatment <- function(
  x,
  tag = "emeScheme",
  file,
  output = "metadata",
  confirmationCode
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

  xml <- XML::xmlNode(name = paste0(tag, "List"))

  if (length(x) > 1) {

    for (i in 1:nrow(x)) {
      xmlField <- XML::xmlNode(name = tag, attrs = c(treatmentID = x[["treatmentID"]][i]))
      xmlFields <- lapply(
        names(x)[-1],
        function(nm){
          XML::xmlNode(
            nm,
            ifelse(is.na(x[[nm]][i]), "", x[[nm]][i])
          )
        }
      )
      xmlField <- XML::append.xmlNode(
        to = xmlField,
        xmlFields
      )
      xml <- XML::append.xmlNode(
        to = xml,
        xmlField
      )
    }

  } else {
    xml <- XML::xmlNode(tag, x)
  }

# Add attributes if output == complete ------------------------------------

  if (output == "complete") {
    XML::xmlAttrs(
      node = xml,
      append = TRUE
    ) <- c(
      unit = paste(attr(x, "unit"), collapse = ", "),
      type = paste(attr(x, "type"), collapse = ", "),
      allowedValues = paste(attr(x, "allowedValues"), collapse = ", "),
      names = paste(attr(x, "names"), collapse = ", "),
      class = paste(class(x), collapse = ", ")
    )
  }

# Return xml --------------------------------------------------------------

  return(xml)
}
