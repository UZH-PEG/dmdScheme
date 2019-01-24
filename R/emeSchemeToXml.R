#' Convert \code{emeScheme} object to XML
#'
#' Converts an \code{emeScheme} object into an xml object.
#'
#' Depending on the value of \code{file}, the function returns different results:
#' \itemize{
#'   \item{\code{file} not given: }{an \code{XMLNode} object}
#'   \item{\code{file = NULL}: }{a string characterisation of the \code{XMLNode} object}
#'   \item{\code{file = fileName}: }{saves the string characterisation of the \code{XMLNode} object to an xml file}
#' }
#' Based on David LeBauer, Carl Davidson, Rob Kooper. See \url{https://stackoverflow.com/a/27865512/632423}
#' @param x \code{emeScheme} object to be converted
#' @param tag xml tag of the root level. \bold{Has to be "emeScheme for the initial call!}
#' @param file empty, \code{NULL} or file name. See details below
#' @param output either \code{"metadata"} for export of metadata only or
#'   \code{"complete"} for export including classes et al.
#'
#' @return dependant on the value of \code{file}. See Details
#' @export
#'
#' @examples
#'
#' emeSchemeToXml( emeScheme_example, "GoogleData" )
#' ## returns \code{XMLNode} object
#'
#' emeSchemeToXml( emeScheme_example, "GoogleData", file = NULL )
#' ## returns string representation of the \code{XMLNode} object
#'
emeSchemeToXml <- function (x, tag, file, output = "metadata") {

  UseMethod("emeSchemeToXml", x)

}
