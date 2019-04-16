#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
emeSchemeToXml.emeSchemeSet <- function(
  x,
  tag,
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

# Add emeSchemeVersion ----------------------------------------------------

  xml <- XML::xmlNode(
    "emeScheme",
    attrs = c(
      emeSchemeVersion = attr(x, "emeSchemeVersion"),
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

# Call emeSchemeToXml() on list objects -----------------------------------

  for(i in 1:length(x)) {
    xml <- XML::append.xmlNode(xml, emeSchemeToXml(x[[i]], output = output, confirmationCode = digest::digest(object = x[[i]], algo = "sha1")))
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
