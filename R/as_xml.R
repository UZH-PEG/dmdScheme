#' Generic function to convert an object to xml
#'
#' @param x object to be converted.
#' @param output specifies the content and format of the exported xml.
#' \describe{
#'   \item{"metadata" : }{export of the metadata only with no format attributes}
#'   \item{"complete" : }{export tof the complete sheme, i.e. "metadata" plus the scheme definition. This is a self contained format which contains all attributes.}
#' }
#' @param ... additional arguments for methods
#'
#' @return an \code{xml_document} object
#'
#' @rdname as_xml
#' @export
#'
#' @examples
#'
#' x <- as_xml( dmdScheme_example() )
#' x
#'
#' ## returns \code{xml_document} object
#'
#'
as_xml <- function(
  x,
  output = "metadata",
  ...
) {

  UseMethod("as_xml")

}
