#' Generic function to convert an object to a list containing xml(s)
#'
#' @param x object to be converted.
#' @param output specifies the content and format of the exported xml.
#' \describe{
#'   \item{"metadata" : }{export of the metadata only with no format attributes}
#'   \item{"complete" : }{export tof the complete sheme, i.e. "metadata" plus the scheme definition. This is a self contained format which contains all attributes.}
#' }
#' @param ... additional arguments for methods
#'
#' @return a \code{list()}  where each element is  \code{xml_document} object
#'
#' @rdname as_xml_list
#' @export
#'
#' @examples
#'
#' x <- as_xml_list( dmdScheme_example() )
#' x
#'
#' ## returns a \code{list()} with one \code{xml_document} object
#'
#'
as_xml_list <- function(
  x,
  output = "metadata",
  ...
) {

  UseMethod("as_xml_list")

}
