#' @importFrom xml2 xml_new_root xml_add_child xml_attrs write_xml
#' @importFrom tibble is_tibble
#'
#' @rdname as_xml
#' @export
#'
as_xml.dmdSchemeData <- function(
  x,
  output = "metadata",
  ...
) {

  outputValues <- c("metadata", "complete")
  if (!(output %in% outputValues)) {
    stop("Wrong value for 'output'. 'output' has to be one of the following values:", paste(outputValues, collapse = " "))
  }

  # x is of type dmdSchemeData and therefore a tibble ------------------

  xml <- xml2::xml_new_root(paste0(attr(x, "propertyName"), "List"))

  if (ncol(x) > 1) {
    idName <- grep("ID", names(x)[[1]], value = TRUE)
    if (nrow(x) > 0) {
      for (i in 1:nrow(x)) {
        xmlCol <- xml2::xml_new_root(attr(x, "propertyName"))
        ##
        if (length(idName) > 0) {
          id <- x[[idName]][i]
          names(id) <- idName
          xml2::xml_attrs(xmlCol) <- id
        }
        ##
        for (nm in names(x)) {
          value <- ifelse(is.na(x[[nm]][i]), "", x[[nm]][i])
          xml2::xml_add_child(xmlCol, nm, value)
        }
        xml2::xml_add_child(xml, xmlCol)
        rm(xmlCol)
      }
    }
  }

  # Add attributes if output == complete ------------------------------------

  if (output == "complete") {
    atrs <- sapply(
      attributes(x),
      paste,
      collapse = " #%# "
    )
    atrs <- atrs[-which(names(atrs) == "row.names")]
    xml2::xml_attrs( xml ) <- atrs
  }

  # Return xml --------------------------------------------------------------

  return(xml)
}
