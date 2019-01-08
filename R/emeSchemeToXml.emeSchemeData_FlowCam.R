#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
emeSchemeToXml.emeSchemeData_FlowCam <- function(
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
      nn <- XML::xmlNode(name = "makeTypeVersion",  x[["makeTypeVersion"]][i])
      xmlField <- XML::append.xmlNode(
        to = XML::xmlNode(tag),
        nn
      )
      ##
      parms <- strsplit(x[["settingsParameter"]][i], ";")[[1]] %>%
        trimws() %>%
        strsplit("=")

      xmlFields <- lapply(
        parms,
        function(p){
          XML::xmlNode(
            name = "settingsParameter",
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
      ##
      nn <- XML::xmlNode(name = "volume",  x[["volume"]][i])
      xmlField <- XML::append.xmlNode(
        to = xmlField,
        nn
      )
      ##
      nn <- XML::xmlNode(name = "treatment",  x[["treatment"]][i])
      xmlField <- XML::append.xmlNode(
        to = xmlField,
        nn
      )
      ##
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
