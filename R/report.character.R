#' Method for creating a report from an `character` object
#'
#' @details
#' **`report.character(x)`** creates a report of the object returned from a `validate(x)`.
#'
#' @export
#' @md
#' @examples
#' ## Report of `dmdScheme_validation`
#' report( validate(dmdScheme_raw) )
#' \dontrun{
#' report( system.file("dmdScheme.xlsx", package = "dmdScheme") )
#' }
#' @describeIn report report of a `character` object.
dmdScheme_to_xml.character <- function(
  x,
  file,
  output = "metadata"
) {

  if (!file.exists(x)) {
    stop("If x is a character, it has to be the file name of a spreadsheet containing the scheme data!")
  }


# Read and convert x ------------------------------------------------------

  xml <- report( x = validate(x) )

# Return xml --------------------------------------------------------------

  return(xml)
}
