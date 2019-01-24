#' emeScheme_raw as imported from the Google sheet.
#'
#' The dataset contains raw data. It was created by using the code below.
#' @source \url{https://docs.google.com/spreadsheets/d/1OAyRM1jGL5Vho-YfPffePhwGpQtaBUeTPJV6P98f0Bc}
#'
#' @examples
#' \dontrun{
#' ## Created by using
#' path <- system.fil;e( "googlesheet", "emeScheme.xlsx", package = "emeScheme")
#' emeScheme_raw <- read_from_excel(
#'   file = path,
#'   keepData = FALSE,
#'   verbose = TRUE,
#'   raw = TRUE
#' )
#' }
"emeScheme_raw"
