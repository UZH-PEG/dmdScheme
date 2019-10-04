#' Function to read x from an XML file
#'
#' Read the XML file \code{file} and convert it to a \code{dmdScheme} object using the function \code{as_dmdScheme()}.
#' @param file Path to file or connection to write to.
#' @param ... additional parameter for the conversion function \code{as_xml()}
#'
#'
#'
#' @importFrom xml2 read_xml
#'
#' @export
#'
#' @examples
#' # write_xml(dmdScheme_raw, file = tempfile())
#'
read_xml <- function(
  file
) {
  xml <- xml2::read_xml( file )

  return( as_dmdScheme( x = xml, ... ) )
}
