#' Validates \code{x} and creates report
#'
#' This function validates either an excel workbook or an object of class
#' \code{dmdScheme_raw} against the definition of the \code{dmdScheme}. It
#' validates the structure, the types, suggested values, ... and returns an object of class \code{dmdScheme_validation}.
#' TODO: DESCRIBE THE CLASS!
#' Based on this result, a report is created if asked fore (see below for details).
#' @param x object of class \code{dmdSchemeSet_raw} as returned from
#'   \code{read_from_excel( keepData = FALSE, raw = TRUE)} or file name of an
#'   xlsx file containing the metadata.
#' @param path path to the data files
#' @param file name of the file containing the generated report, including
#'   extension. If missing, ot will be saved as a temporary file in the
#'   temporary folder.
#' @param report determines if and in which format a report of the validation
#'   should be generated. Allowed values are:
#' \itemize{
#'   \item{\bold{'none'}   : } {no report is generated}
#'   \item{\bold{'html'}   : } {a html (.html) report is generated and opened}
#'   \item{\bold{'pdf'}    : } {a pdf (.pdf) report is generated and opened}
#'   \item{\bold{'word'}   : } {a word (.docx)report is generated and opened}
#' }
#' @param report_author name of the author for the report
#' @param report_title title of the report for the report
#'
#' @return return the \code{dmdScheme_validation} object
#'
#' @export
#'
#' @examples
#' validate_report( dmdScheme_raw )
#' \dontrun{
#' validate_report(
#'    x = dmdScheme_raw,
#'    report = "html",
#'    report_author = "The Author I am",
#'    report_title = "A Nice Report"
#' )
#' }
#'
validate_report <- function(
  x,
  path = ".",
  file,
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

  if (missing(file)) {
    reportDir <- tempfile( pattern = "validation_report" )
    dir.create(reportDir)
    reportFile <- NULL
  } else{
    reportDir <- dirname(file)
    reportFile <- basename(file)
  }
  # Validate x --------------------------------------------------------------

  result <- validate(
    x = x,
    path = path,
    validateData = TRUE,
    errorIfStructFalse = TRUE
  )

  # Generate report ---------------------------------------------------------

  if (report != "none") {
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
        result = result
      )
    )
  } else {
    result <- NULL
  }

  # Return result -----------------------------------------------------------

  invisible(result)
}


