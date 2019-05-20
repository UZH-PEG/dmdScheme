#' dmdScheme_raw as imported from the Google sheet.
#'
#' The dataset contains raw data. It was created by using the code below.
#'
#' @examples
#' \dontrun{
#' ## Created by using
#' path <- system.fil;e( "dmdScheme.xlsx", package = "dmdScheme")
#' dmdScheme_raw <- read_from_excel(
#'   file = path,
#'   keepData = FALSE,
#'   verbose = TRUE,
#'   raw = TRUE
#' )
#' }
"dmdScheme_raw"
