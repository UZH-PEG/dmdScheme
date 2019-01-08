#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
emeSchemeToXml.emeSchemeData_VideoAnalysis <- function(
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

  xml <- XML::xmlNode(paste0(tag, "List"))

  if (length(x) > 1) {

    for (i in 1:nrow(x)) {
      analysisMethod <- XML::xmlNode(name = "analysisMethod",  x[["analysisMethod"]][i])
      xmlField <- XML::append.xmlNode(
        to = XML::xmlNode(tag),
        analysisMethod
      )
      ##
      parms <- strsplit(x[["parameterUsed"]][i], ";")[[1]] %>%
        trimws() %>%
        strsplit("=")

      xmlFields <- lapply(
        parms,
        function(p){
          XML::xmlNode(
            name = "parameter",
            attrs = c(name = trimws(p[[1]])),
            trimws(p[[2]])
          )
        }
      )
      ##
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
      class = paste(class(x), collapse = ", "),
      names = paste(attr(x, "names"), collapse = ", "),
      unit = paste(attr(x, "unit"), collapse = ", ")
    )
  }

# Return xml --------------------------------------------------------------

  return(xml)
}
