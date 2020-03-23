#' Method for creating a report from an `dmdScheme_validation` object
#'
#' @details
#' **`report.dmdScheme_validation`** creates a report of the object returnes from a `validate()`.
#'
#' @importFrom utils browseURL
#'
#' @export
#' @md
#' @examples
#' ## Report of `dmdScheme_validation`
#' report( validate(dmdScheme_raw()) )
#' \dontrun{
#' report(
#'    x = dmdScheme_raw(),
#'    report = "html",
#'    report_author = "The Author I am",
#'    report_title = "A Nice Report"
#' )
#' }
#' @describeIn report report of a `dmdScheme_validation` object.
report.dmdScheme_validation <- function(
  x,
  file = tempfile(),
  open = TRUE,
  report = "html",
  report_author = "Tester",
  report_title = "Validation of data against dmdScheme",
  ...
) {
  if (length(report) != 1) {
    stop("'report' has to be exactly of length 1!")
  }

  allowedFormats <- c("html", "pdf", "word")
  if (!(report %in% allowedFormats)) {
    stop("'report' has to be one of the following values: (", paste(allowedFormats, collapse = ', '), ")!")
  }

  if (length(report) > 1) {
    stop("The length of the argument `report` has to be exactly one!")
  }

  # Generate report ---------------------------------------------------------


  temppath <- tempfile()
  dir.create(temppath, recursive = TRUE, showWarnings = FALSE)
  tempReport <- file.path(temppath, "validation_report.Rmd")
  file.copy(
    from = system.file("reports", "validation_report.Rmd", package = "dmdScheme"),
    to = tempReport,
    overwrite = TRUE
  )

  result <- rmarkdown::render(
    input = tempReport,
    output_format = paste0(report, "_document"),
    params = list(
      author = report_author,
      title = report_title,
      x = x,
      result = x
    )
  )

  file.copy(
    from = result,
    to = file
  )

  # Open report -------------------------------------------------------------

  if (open) {
    if (interactive()) {
      utils::browseURL(
        url = result,
        encodeIfNeeded = TRUE
      )
    } else {
      message("Non-interactive session. If interactive session, the report would be opened.")
    }
  }

  # Return result -----------------------------------------------------------

  return(file)
}


