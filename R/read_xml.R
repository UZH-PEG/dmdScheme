#' Function to read x from an XML file
#'
#' Read the XML file \code{file} and convert it to a \code{dmdScheme} object using the function \code{as_dmdScheme()}.
#' @param file Path to file or connection to write to.
#' @param keepData if the data should be kept or replaced with one row with NAs
#' @param useSchemeInXml if \code{TRUE}, use scheme definition in xml and raise
#'   an error if the xml does not contain a scheme definition. If False, use the
#'   scheme definition from the corresponding installed package, even if the xml
#'   contains a scheme definition. if \code{NULL} (the default), use the
#'   definition in the xml if it contains a definition, if not use the
#'   corresponding definition from the installed package.
#' @param verbose give verbose progress info. Useful for debugging.
#'
#'
#' @importFrom xml2 read_xml
#'
#' @export
#'
#' @examples
#' # write_xml(dmdScheme_raw(), file = tempfile())
#'
read_xml <- function(
  file,
  keepData = TRUE,
  useSchemeInXml = NULL,
  verbose = FALSE
) {
  xml <- xml2::read_xml( file )

  return(
    as_dmdScheme(
      x = xml,
      keepData = keepData,
      useSchemeInXml = useSchemeInXml,
      verbose = verbose
    )
  )
}
