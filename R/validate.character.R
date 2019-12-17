#' @export
#'
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr filter select
#' @importFrom utils browseURL glob2rx
#' @importFrom rmarkdown render
#' @importFrom tibble tibble
#' @importFrom utils read.csv
#' @importFrom magrittr extract2
#' @importFrom digest digest
#'
#' @describeIn validate validate a `character` object referring to a spreadsheet file which contains the metadata.
#' @md
#'
#' @examples
#' ## validata an Excel file containing the metadata
#' validate(
#'     x = scheme_path_xlsx()
#' )
#'
validate.character <- function(
  x,
  path = ".",
  validateData = TRUE,
  errorIfStructFalse = TRUE
) {


  # Load from excel sheet  ---------------------------------

    raw <- read_excel(
      file = x,
      keepData = TRUE,
      validate = FALSE,
      raw = TRUE
    )

  ##
  return(
    validate(
      x = raw,
      path = path,
      validateData = validateData,
      errorIfStructFalse = errorIfStructFalse
    )
  )
}



