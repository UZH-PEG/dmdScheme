#' @rdname as_xml_list
#' @export
#'
as_xml_list.dmdSchemeSet <- function(
  x,
  output = "metadata",
  ...
) {
  xml <- as_xml(x, output = output, ...)

# Return xml --------------------------------------------------------------

  return(list(xml))
}
