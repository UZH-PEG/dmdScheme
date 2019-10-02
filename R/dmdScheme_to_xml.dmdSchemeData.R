#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
dmdScheme_to_xml.dmdSchemeData <- function(
  x,
  file,
  output = "metadata"
) {

  outputValues <- c("metadata", "complete")
  if (!(output %in% outputValues)) {
    stop("Wrong value for 'output'. 'output' has to be one of the following values:", paste(outputValues, collapse = " "))
  }

  # x is of type dmdSchemeData and therefore a tibble ------------------

  xml <- xml2::xml_new_root("dmdSchemeData") %>%
    xml2::xml_add_child(xml, paste0(attr(x, "propertyName"), "List"))

  if (length(x) > 1) {
    if (nrow(x) > 0) {
      for (i in 1:nrow(x)) {
        xmlFields <- lapply(
          names(x),
          function(nm){
            XML::xmlNode(
              nm,
              ifelse(is.na(x[[nm]][i]), "", x[[nm]][i])
            )
          }
        )
        id <- grep("ID", names(x))
        if (length(id) > 0) {
          if (id[[1]] == 1) {
            id <- names(x)[1]
            idi <- x[[1]][i]
            names(idi) <- id
            xmlField <- XML::xmlNode(name = attr(x, "propertyName"), attrs = idi)
          }
        } else {
          xmlField <- XML::xmlNode(attr(x, "propertyName"))
        }
        xmlField <- XML::append.xmlNode(
          to = xmlField,
          xmlFields
        )
        xml <- XML::append.xmlNode(
          to = xml,
          xmlField
        )
      }
    }

  } else {
    xml <- XML::xmlNode(attr(x, "propertyName"), x)
  }

  # Add attributes if output == complete ------------------------------------

  if (output == "complete") {
    XML::xmlAttrs(
      node = xml,
      append = TRUE
    ) <- sapply(
      attributes(x),
      paste,
      collapse = " #&# "
    )
  }

  # If file not NULL, i.e. from root node as file not used in it --------

  if (!is.null(file)) {
    xml2::write_xml( xml, file )
  }

  # Return xml --------------------------------------------------------------

  return(invisible(xml))
}
