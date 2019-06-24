#' Method creating a report from an `character` object representing a file name of a metadata spreadsheet
#'
#' @details
#' **`report.character`** creates a report of the object returnes from a `validate()`.
#'
#' @export
#' @md
#' @examples
#' ## Report of `dmdScheme_validation`
#' report( system.file("dmdScheme.xlsx", package = "dmdScheme") )
#'
#' @describeIn report report of a `dmdScheme_validation` object.
#'
#' @importFrom XML xmlNode xmlAttrs append.xmlNode saveXML
#' @importFrom tibble is_tibble
#'
report.character <- function(
  x,
  file,
  output = "metadata"
) {

  if (!file.exists(x)) {
    stop("If x is a character, it has to be the file name of a spreadsheet containing the scheme data!")
  }


# Read and convert x ------------------------------------------------------

  result <- report( validate(x) )

# Return xml --------------------------------------------------------------

  return(result)
}
