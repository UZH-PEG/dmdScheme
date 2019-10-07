#' Function to write x as an XML file to disk
#'
#' Convert the object \code{x} to an \code{xml_document} object using the function \code{as_xml()} to a file.
#' @param x object which will be coinverted and saved as an xml file.
#' @param file Path to file or connection to write to.
#' @param ... additional parameter for the conversion function \code{as_xml()}
#'
#'
#'
#' @importFrom xml2 write_xml
#'
#' @export
#'
#' @examples
#' write_xml(dmdScheme_raw, file = tempfile())
#'
write_xml.dmdSchemeSet <- function(
  x,
  file
) {

  xml <- as_xml( x = x )

  xml2::write_xml(
    x = xml,
    file = file
  )

}
