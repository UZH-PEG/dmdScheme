#' Method creating a report from an `character` object representing a file name of a metadata spreadsheet
#'
#' @details
#' **`report.character`** creates a report of the object returnes from a `validate()`.
#'
#' @export
#' @md
#'
#' @describeIn report report of a `dmdScheme_validation` object.
#'
#' @examples
#' \dontrun{
#' ## This examples requires pandoc
#' ## Report of `dmdScheme_validation`
#' report( scheme_path_xlsx() )
#' }
#'
#'
report.character <- function(
  x,
  file = tempfile(),
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

  result <- report(
    validate(x, ...),
    file = file,
    open = open,
    report = report,
    report_author = report_author,
    report_title = report_title
  )

# Return xml --------------------------------------------------------------

  return(result)
}
