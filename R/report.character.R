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
#'
report.character <- function(
  x,
  file,
  open = TRUE,
  report = "html",
  report_author = "Tester",
  report_title = "Validation of data against dmdScheme",
  ...
) {

  if (!file.exists(x)) {
    stop("If x is a character, it has to be the file name of a spreadsheet containing the scheme data!")
  }


# Read and convert x ------------------------------------------------------

  result <- report( validate(x, ...) )

# Return xml --------------------------------------------------------------

  return(result)
}
