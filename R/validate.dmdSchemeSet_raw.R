#' @export
#'
#' @importFrom magrittr %>% %<>%
#' @importFrom rmarkdown render
#' @importFrom utils read.csv
#' @importFrom magrittr extract2
#' @importFrom digest digest
#'
#' @describeIn validate validate a `dmdSchemeSet_raw` object
#'
#' @md
#' @examples
#' ## validate a `dmdScheme_raw object`
#' validate(
#'    x = dmdScheme_raw()
#' )
#'
#' ## use `read_raw()` to read an Excel spreadsheet into a `dmdScheme_raw` object
#' x <- read_excel_raw( scheme_path_xlsx() )
#' validate( x = x )
#'
validate.dmdSchemeSet_raw <- function(
  x,
  path = ".",
  validateData = TRUE,
  errorIfStructFalse = TRUE
) {

  # Define result structure of class dmdScheme_validation ----------------------

  result <- new_dmdScheme_validation()
  result$description <- paste(
    "The result of the overall validation of the data."
  )
  result$descriptionDetails <- paste(
    "The details contain the different validations of the metadata as a hierarchical list.",
    "errors propagate towards the root, i.e., if the 'worst' is a 'warning' in a validation in `details`",
    "the error here will be a 'warning' as well."
  )

  # Validate structure ------------------------------------------------------

  result$structure <- validateStructure( x )
  if (result$structure$error != 0 & errorIfStructFalse) {
    message(result$structure$details)
    stop("Structure of the object to be evaluated is wrong. See the info above for details.")
  }


  # Validata data -----------------------------------------------------------

  if ((result$structure$error == 0) & validateData) {
    xconv <- suppressWarnings( as_dmdScheme(x, keepData = TRUE, convertTypes = TRUE,  verbose = FALSE, warnToError = FALSE) )
    xraw  <-                   as_dmdScheme(x, keepData = TRUE, convertTypes = FALSE, verbose = FALSE, warnToError = FALSE)

    message("Validating Experiment")
    result$Experiment <- validateExperiment(x["Experiment"], xraw["Experiment"], xconv["Experiment"])

    tabs <- names(x)
    tabs <- grep("Experiment|DataFileMetaData", names(x), invert = TRUE, value = TRUE)
    for (tab in tabs) {
      message("Validating ", tab)
      result[[tab]] <- validateTab(x[tab], xraw[tab], xconv[tab])
    }

    message("Validating DataFileMetaData")
    result$DataFileMetaData <- validateDataFileMetaData(x["DataFileMetaData"], xraw["DataFileMetaData"], xconv["DataFileMetaData"], path)
  }

  # Set overall error -------------------------------------------------------

  result$error <- max(valErr_extract(result), na.rm = FALSE)
  if (is.na(result$error)) {
    # result$error <- 3
  }
  result$header <- valErr_TextErrCol("Overall MetaData", result$error)

  # Return result -----------------------------------------------------------

  return(result)
}


