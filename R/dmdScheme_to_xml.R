#' Generic function to convert an object to XML
#'
#' Converts an object into xml and optionally saves it to a file.
#'
#' Depending on the value of \code{file}, the function returns different results:
#' \itemize{
#'   \item{\code{file = NULL: }{an \code{xml_document} object}
#'   \item{\code{file = fileName}: }{saves the string characterisation of the \code{XMLNode} object to a file}
#' }
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
#' @return dependent on the value of \code{file}. See Details
#'
#' @export
#'
#' @examples
#'
#' dmdScheme_to_xml( dmdScheme_example )
#' ## returns \code{XMLNode} object
#'
#' dmdScheme_to_xml( dmdScheme_example, file = NULL )
#' ## returns string representation of the \code{XMLNode} object
#'
dmdScheme_to_xml <- function(x, file = NULL, output = "metadata") {

  UseMethod("dmdScheme_to_xml", x)

}
