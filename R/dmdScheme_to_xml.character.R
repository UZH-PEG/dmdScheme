#' @importFrom xml2 write_xml
#'
#' @export
#'
dmdScheme_to_xml.character <- function(
  x,
  file = NULL,
  output = "metadata"
) {

  if (!file.exists(x)) {
    stop("If x is a character, it has to be the file name of a spreadsheet containing the scheme data!")
  }

  # Read and convert x ------------------------------------------------------

  xml <- dmdScheme_to_xml( x = read_from_excel(x), file = NULL, output = output )

  # If file not NULL save to file ------------------------------------------

  if (!is.null(file)) {
    xml2::write_xml(
      x = xml,
      file = file
    )
  }

  # Return xml --------------------------------------------------------------

  return(invisible(xml))
}
