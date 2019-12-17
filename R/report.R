#' Generic function for creating a report from an object `x`
#'
#' This generic function creates a report based on the object.
#' @param x object of which the report should be creted used to select a method
#' @param file name of the file containing the generated report, including
#'   extension. If missing, ot will be saved as a temporary file in the
#'   temporary folder.
#' @param open if `TRUE`, open the report. Default: `TRUE`
#' @param report determines if and in which format a report of the validation
#'   should be generated. Allowed values are:
#'   * **`none`**: no report is generated
#'   * **`html`**: a html (.html) report is generated and opened
#'   * **`pdf`** : a pdf (.pdf) report is generated and opened
#'   * **`word`**: a word (.docx)report is generated and opened
#' Additional values can be implemented by the different methods and will be
#' documented in the Details section.
#' @param report_author name of the author to be included in the report
#' @param report_title title of the report to be included in the report
#' @param ... further arguments passed to or from other methods
#'
#' @return return the path and filename of the report
#'
#' @export
#' @md
#'
#'
report <- function(
  x,
  file = tempfile(),
  open = TRUE,
  report = "html",
  report_author = "Myself",
  report_title = "Report of something",
  ...
) {

  UseMethod("report", x)

}
