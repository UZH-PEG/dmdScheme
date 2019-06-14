#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
dmdScheme_to_xml.dmdSchemeSet <- function(
  x,
  file,
  output = "metadata"
) {
  outputValues <- c("metadata", "complete")
  if (!(output %in% outputValues)) {
    stop("Wrong value for 'output'. 'output' has to be one of the following values:", paste(outputValues, collapse = " "))
  }

# Add dmdSchemeVersion ----------------------------------------------------

  xml <- XML::xmlNode(
    "dmdScheme",
    attrs = c(
      dmdSchemeVersion = attr(x, "dmdSchemeVersion"),
      propertyName     = attr(x, "propertyName")
      )
  )

# Add attributes if output == complete ------------------------------------

  if (output == "complete") {
    XML::xmlAttrs(
      node = xml,
      append = TRUE
    ) <- c(
      class = paste(class(x), collapse = ", "),
      names = paste(attr(x, "names"), collapse = ", ")
    )
  }

# Call dmdScheme_to_xml() on list objects -----------------------------------

  for(i in 1:length(x)) {
    xml <- XML::append.xmlNode(xml, dmdScheme_to_xml(x[[i]], output = output))
  }

# If file  not missing, i.e. from root node as file not used in it --------

  if (!missing(file)){
    xml <- XML::saveXML(
      doc = xml,
      file = file
    )
  }

# Return xml --------------------------------------------------------------

  return(xml)
}
