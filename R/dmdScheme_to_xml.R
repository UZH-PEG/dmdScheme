#' Generic function to convert an object to xml
#'
#' Converts an object into xml and optionally saves it to a file.
#'
#' @param x object to be converted.
#'
#' At the moment the following objects are supported:
#' \describe{
#'   \item{\code{character}}{File name of a spreadsheet containing the data}
#'   \item{\code{\link{dmdSchemeSet}}}{}
#'   \item{\code{\link{dmdSchemeData}}}{}
#' }
#'
#' @param file \code{NULL} or file name. See details below
#' @param output either \code{"metadata"} for export of metadata only or
#'   \code{"complete"} for export including classes et al.
#'
#' @return an \code{xml_document} object
#'
#' @export
#'
#' @examples
#'
#' x <- dmdScheme_to_xml( dmdScheme_example )
#' x
#'
#' ## returns \code{xml_document} object
#'
#'
dmdScheme_to_xml <- function(x, file = NULL, output = "metadata") {

  UseMethod("dmdScheme_to_xml", x)

}
