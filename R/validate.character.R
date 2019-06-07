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
validate.character <- function(
  x,
  path = ".",
  validateData = TRUE,
  errorIfStructFalse = TRUE
) {


  # Load from excel sheet  ---------------------------------

    raw <- read_from_excel(
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



