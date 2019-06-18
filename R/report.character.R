#' @export
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
dmdScheme_to_xml.character <- function(
  x,
  file,
  output = "metadata"
) {

  if (!file.exists(x)) {
    stop("If x is a character, it has to be the file name of a spreadsheet containing the scheme data!")
  }


# Read and convert x ------------------------------------------------------

  xml <- dmdScheme_to_xml( x = read_from_excel(x) )

# Return xml --------------------------------------------------------------

  return(xml)
}
