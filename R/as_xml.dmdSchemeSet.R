#' @importFrom xml2 xml_new_root xml_attrs xml_attr xml_add_child
#'
#' @rdname as_xml
#' @export
#'
as_xml.dmdSchemeSet <- function(
  x,
  output = "metadata",
  ...
) {
  outputValues <- c("metadata", "complete")
  if (!(output %in% outputValues)) {
    stop("Wrong value for 'output'. 'output' has to be one of the following values:", paste(outputValues, collapse = " "))
  }

# Add dmdSchemeVersion ----------------------------------------------------

  xml <- xml2::xml_new_root( "dmdScheme" )
  xml2::xml_attrs(xml) <-  c(
    fileName = attr(x, "fileName"),
    dmdSchemeName = attr(x, "dmdSchemeName"),
    dmdSchemeVersion = attr(x, "dmdSchemeVersion"),
    propertyName     = attr(x, "propertyName"),
    output = output
  )

# Add attributes if output == complete ------------------------------------

  if (output == "complete") {
    xml2::xml_attr(xml, "class") <- paste(class(x), collapse = " #%# ")
    xml2::xml_attr(xml, "names") <- paste(attr(x, "names"), collapse = " #%# ")
  }

# Call as_xml() on list objects --------------------------------

  for (i in 1:length(x)) {
    xml2::xml_add_child(xml, as_xml(x[[i]], output = output))
  }


# Return xml --------------------------------------------------------------

  return(xml)
}
