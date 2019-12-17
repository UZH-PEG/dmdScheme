#' Run shiny app.
#'
#' The shiny app allows the entering, validating, and exporting of the metadata
#' without using R.
#' See https://deanattali.com/2015/04/21/r-package-shiny-app/
#' @return return value from \code{runApp()}
#' @export
#'
#' @examples
#' \dontrun{
#' run_app()
#' }
#'
run_app <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop(
      "This function only works when the package `shiny` is instaled.\n",
      "To use it, please install shiny by running\n",
      "   `install.packages('shiny')`"
    )
  }
  app_dir <- system.file("shiny_apps", "dmd_app", package = "dmdScheme")
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing `dmdScheme`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
