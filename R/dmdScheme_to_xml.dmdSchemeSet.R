#' @export
#'
#' @importFrom xml2 xml_new_root xml_attrs xml_attr xml_add_child
#'
dmdScheme_to_xml.dmdSchemeSet <- function(
  x,
  file = NULL,
  output = "metadata"
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

# Call dmdScheme_to_xml() on list objects --------------------------------

  for (i in 1:length(x)) {
    xml2::xml_add_child(xml, dmdScheme_to_xml(x[[i]], file = NULL, output = output))
  }

# If file not NULL, i.e. from root node as file not used in it --------

  if (!is.null(file)) {
    xml2::write_xml( xml, file )
  }

# Return xml --------------------------------------------------------------

  return(invisible(xml))
}
