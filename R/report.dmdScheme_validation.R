#' Geberic function creating a report from an `dmdScheme_validation` object
#'
#' @details
#' **`report.dmdScheme_validation`** creates a report of the object returnes from a `validate()`.
#'
#' @export
#' @md
#' @examples
#' ## Report of `dmdScheme_validation`
#' report( validate(dmdScheme_raw) )
#' \dontrun{
#' report(
#'    x = dmdScheme_raw,
#'    report = "html",
#'    report_author = "The Author I am",
#'    report_title = "A Nice Report"
#' )
#' }
#' @describeIn report report of a `dmdScheme_validation` object.
report.dmdScheme_validation <- function(
  x,
  file,
  open = TRUE,
  report = "html",
  report_author = "Tester",
  report_title = "Validation of data against dmdScheme"
) {

  if (length(report) != 1) {
    stop("'report' has to be exactly of length 1!")
  }

  allowedFormats <- c("none", "html", "pdf", "word")
  if (!(report %in% allowedFormats)) {
    stop("'report' has to be one of the following values: ", allowedFormats)
  }

  if (report != "none") {
    if (missing(file)) {
      reportDir <- tempfile( pattern = "validation_report" )
      reportFile <- NULL
    } else{
      reportDir <- dirname(file)
      reportFile <- basename(file)
    }
  }

  # Generate report ---------------------------------------------------------

  if (report != "none") {
    dir.create(reportDir)

    result <- rmarkdown::render(
      input = system.file("reports", "validation_report.Rmd", package = "dmdScheme"),
      output_format = ifelse(
        report == "all",
        "all",
        paste0(report, "_document")
      ),
      output_file = reportFile,
      output_dir = reportDir,
      params = list(
        author = report_author,
        title = report_title,
        x = x,
        result = x
      )
    )
  } else {
    result <- NULL
  }

  # Open report -------------------------------------------------------------

  if (open & report != "none") {
    utils::browseURL(
      url = result,
      encodeIfNeeded = TRUE
    )
  }

  # Return result -----------------------------------------------------------

  return(result)
}


