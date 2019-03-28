#' Validate Excel workbook or object of class \code{emeSchemeSet_raw} against \code{emeScheme}.
#'
#' This function validates either an excel workbook or an object of class
#' \code{emeScheme_raw} against the definition of the \code{emeScheme}. It
#' validates the structure, the types, suggested values, ... and returns an object of class \code{emeScheme_validation}.
#' TODO: DESCRIBE THE CLASS!
#' Based on this result, a report is created if asked fore (see below for details).
#' @param x object of class \code{emeSchemeSet_raw} as returned from \code{read_from_excel( keepData = FALSE, raw = TRUE)} or file name of an xlsx file containing the metadata.
#' @param path path to the data files
#' @param validateData if \code{TRUE} data is validated as well; the structure is always validated
#' @param report determines if and in which format a report of the validation should be generated. Allowed values are:
#' \itemize{
#'   \item{\bold{missing}  : } {no report is generated (the \code{default})}
#'   \item{\bold{'html'}   : } {a html (.html) report is generated and opened}
#'   \item{\bold{'pdf'}    : } {a pdf (.pdf) report is generated and opened}
#'   \item{\bold{'word'}   : } {a word (.docx)report is generated and opened}
#'   \item{\bold{'all'}    : } {all of the defined reports}
#' }
#' @param report_author name of the author for the report
#' @param report_title title of the report for the report
#' @param errorIfStructFalse if \code{TRUE} an error will be raised if the schemes are not identical, i.e. there are structural differences.
#'
#' @return return the \code{emeScheme_validation} object
#'
#' @importFrom taxize gnr_resolve
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr filter select
#' @importFrom utils browseURL
#' @importFrom rmarkdown render
#' @importFrom tibble tibble
#' @importFrom utils read.csv
#' @importFrom magrittr extract2
#' @importFrom digest digest
#' @export
#'
#' @examples
#' validate( emeScheme_raw )
#' \dontrun{
#' validate(
#'    x = emeScheme_raw,
#'    report = "html",
#'    report_author = "The Author I am",
#'    report_title = "A Nice Report"
#' )
#' }
#'
validate <- function(
  x,
  path = ".",
  validateData = TRUE,
  report = "none",
  report_author = "Tester",
  report_title = "Validation of data against emeScheme",
  errorIfStructFalse = TRUE
) {

  # Check arguments ---------------------------------------------------------

  allowedFormats <- c("none", "html", "pdf", "word", "all")
  if (!(report %in% allowedFormats)) {
    stop("'report' has to be one of the following values: ", allowedFormats)
  }

  # Load from excel sheet if x == character ---------------------------------

  if (is.character(x)) {
    x <- read_from_excel(
      file = x,
      keepData = TRUE,
      validate = FALSE,
      raw = TRUE
    )
  }

  # Define result structure of class emeScheme_validation ----------------------
  result <- new_emeScheme_validation()
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
    cat_ln(result$structure$details)
    stop("Structure of the object to be evaluated is wrong. See the info above for details.")
  }


  # Validata data -----------------------------------------------------------

  if ((result$structure$error == 0) & validateData){
    xconv <- suppressWarnings( new_emeSchemeSet(x, keepData = TRUE, convertTypes = TRUE,  verbose = FALSE, warnToError = FALSE) )
    xraw  <-                   new_emeSchemeSet(x, keepData = TRUE, convertTypes = FALSE, verbose = FALSE, warnToError = FALSE)

    result$Experiment <- validateExperiment(x, xraw, xconv)
    result$Species <- validateSpecies(x, xraw, xconv)
    result$Treatment <- validateTreatment(x, xraw, xconv)
    result$Measurement <- validateMeasurement(x, xraw, xconv)
    result$DataExtraction <- validateDataExtraction(x, xraw, xconv)
    result$DataFileMetaData <- validateDataFileMetaData(x, xraw, xconv, path)
    result$DataFiles <- validateDataFiles(x, xraw, xconv, path)
  }

  # Set overall error -------------------------------------------------------

  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("Overall MetaData", result$error)

  # Generate report ---------------------------------------------------------

  if (report %in% allowedFormats[-1]) {
    reportDir <- tempfile( pattern = "validation_report" )
    dir.create(reportDir)
    rmarkdown::render(
      input = system.file("reports", "validation_report.Rmd", package = "emeScheme"),
      output_format = ifelse(
        report == "all",
        "all",
        paste0(report, "_document")
      ),
      output_dir = reportDir,
      params = list(
        author = report_author,
        title = report_title,
        x = x,
        result = result
      )
    ) %>%
      lapply(
        utils::browseURL,
        encodeIfNeeded = TRUE
      )
  }

  # Return result -----------------------------------------------------------

  return(result)
}


# Internal validation helper functions ------------------------------------

new_emeScheme_validation <- function() {
  result <- list(
    error = NA,
    details = NA,
    header = "To Be Added",
    description = "To Be Added",
    descriptionDetails = "To Be Added",
    comment = ""
  )
  class(result) <- append( "emeScheme_validation", class(result) )
  return(result)
}


validateTypes <- function(sraw, sconv) {
  result <- new_emeScheme_validation()
  ##
  t <- sraw == sconv
  na <- is.na(t)
  t[na] <- TRUE
  result$details <- as.data.frame(sraw)
  result$details[t] <- TRUE
  result$details[!t] <- paste( result$details[!t], "!=", as.data.frame(sconv)[!t])
  result$details[na] <- NA
  result$details <- as_tibble(result$details)
  ##
  result$error = ifelse(
    all(result$details == TRUE, na.rm = TRUE),
    0,
    3
  )
  ##
  result$description <- paste(
    "Test if the metadata entered follows the type for the column, i.e. integer, characterd, ....",
    "The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified.",
    "the value NA is allowed in all column types, empty cells should be avoided."
  )
  result$descriptionDetails <- paste(
    "The details are a table of the same dimension as the input (green) area of the meatadata sheet.",
    "The following values are possible:\n",
    "\n",
    "   FALSE: If the cell contains an error, i.e. can not be losslessly converted.\n",
    "   TRUE : If the cell can be losslessly converted and is OK.\n",
    "   NA   : empty cell\n",
    "\n",
    "One or more FALSE values will result in an ERROR."
  )
  ##
  result$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$error)
  ##
  return( result )
}


validateSuggestedValues <- function(sraw) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "values in suggestedValues"
  ##
  result$details <- as_tibble(sraw)
  sugVal <- strsplit(attr(sraw, "suggestedValues"), ",")
  result$details <- result$details[,!is.na(sugVal)]
  sugVal <- sugVal[!is.na(sugVal)]
  ##
  for (colN in 1:ncol(result$details)) {
    v <- c( trimws(sugVal[[colN]]), "NA", NA, "" )
    for (rowN in 1:nrow(result$details)) {
      al <- result$details[rowN, colN] %in% v
      # al <- ifelse(
      #   al,
      #   TRUE,
      #   paste0("'", result$details[rowN, colN], "' not in suggested Values!")
      # )
      result$details[rowN, colN] <- al
    }
  }
  ##
  result$error = ifelse( all(result$details == TRUE,na.rm = TRUE), 0, 2)
  ##
  result$description <- paste(
    "Test if the metadata entered is ion the suggestedValues list.",
    "The value NA is allowed in all column types, empty cells should be avoided."
  )
  result$descriptionDetails <- paste(
    "The details are a table of the same dimension as the input (green) area of the meatadata sheet.",
    "The following values are possible:\n",
    "\n",
    "   FALSE: If the cell value is not contained in the suggestedValues list.\n",
    "   TRUE : If the cell value is contained in the suggestedValues list.\n",
    "   NA   : empty cell\n",
    "\n",
    "One or more FALSE values will result in a WARNING."
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return( result )
}


validateAllowedValues <- function(sraw) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "values in allowedValues"
  result$description <- paste(
    "Test if the metadata entered is ion the allowedValues list.",
    "The value NA is allowed in all column types, empty cells should be avoided."
  )
  result$descriptionDetails <- paste(
    "The details are a table of the same dimension as the input (green) area of the meatadata sheet.",
    "The following values are possible:\n",
    "\n",
    "   FALSE: If the cell value is not contained in the allowedValues list.\n",
    "   TRUE : If the cell value is contained in the allowedValues list.\n",
    "   NA   : empty cell\n",
    "\n",
    "One or more FALSE values will result in an ERROR."
  )
  ##
  result$details <- as_tibble(sraw)
  allVal <- strsplit(attr(sraw, "allowedValues"), ",")
  result$details <- result$details[,!is.na(allVal)]
  allVal <- allVal[!is.na(allVal)]
  ##
  for (colN in 1:ncol(result$details)) {
    v <- c( trimws(allVal[[colN]]), "NA", NA, "" )
    for (rowN in 1:nrow(result$details)) {
      al <- result$details[rowN, colN] %in% v
      # al <- ifelse(
      #   al,
      #   TRUE,
      #   paste0("'", result$details[rowN, colN], "' not in allowed Values!")
      # )
      result$details[rowN, colN] <- al
    }
  }
  ##
  result$error = ifelse( all(result$details == TRUE,na.rm = TRUE), 0, 3)
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return( result )
}


validateSpeciesNames <- function(x) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "name in species database and report score (using taxize::gnr_resolve())"
  ##
  result$details <- taxize::gnr_resolve(x$Species$name, best_match_only = TRUE)
  ##
  if (length(attr(result$details, "not_known")) > 0) {
    result$error <- 2
  } else if (min(result$details$score) < 0.7) {
    result$error <- 2
  } else {
    result$error <- 0
  }
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateTreatmentMapping <- function(x){
  result <- new_emeScheme_validation()
  ##
  result$header <- "treatmentID is in mappingColumn"
  ##
  result$details <- unique(x$Treatment$treatmentID) %in% x$DataFileMetaData$mappingColumn
  names(result$details) <- unique(x$Treatment$treatmentID)
  ##
  result$error <- ifelse(
    all(result$details),
    0,
    2
  )
  result$header <- valErr_TextErrCol(result)
  return(result)
}

validateMeasurementNamesUnique <- function(x){
  result <- new_emeScheme_validation()
  ##
  result$header <- "names unique"
  result$description <- paste(
    "Check if the names specified in `measurementID` are unique."
  )
  result$descriptionDetails <- paste(
    "returns a named vector, with the following possible values:\n",
    "     TRUE: the value is unique\n",
    "     FALSE: the value is na duplicate\n",
    "One or more FALSE will result in an ERROR."
  )
  ##
  nu <- !duplicated(x$Measurement$measurementID)
  names(nu) <- x$Measurement$measurementID
  result$details <-  nu
  ##
  result$error <-  ifelse(
    all(nu),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateMeasurementMeasuredFrom <- function(x) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "measuredFrom is 'raw', 'NA', NA or in name"
  result$description <- paste(
    "Check if the names specified in `measurementID` are unique."
  )
  result$descriptionDetails <- paste(
    "returns a named vector, with the following possible values:\n",
    "     TRUE: the value is unique\n",
    "     FALSE: the value is na duplicate\n",
    "One or more FALSE will result in an ERROR."
  )
  ##
  mf <- x$Measurement$measuredFrom %in% c(x$Measurement$measurementID, "raw", "NA", NA)
  names(mf) <- x$Measurement$measurementID
  result$details = mf
  ##
  result$error = ifelse(
    all(mf),
    0,
    3
  )
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateMeasurementInMappingColumn <- function(x){
  result <- new_emeScheme_validation()
  ##
  result$header <- "variable is in mappingColumn"
  ##
  result$details <- unique(x$Measurement$variable) %in% x$DataFileMetaData$mappingColumn
  names(result$details) <- unique(x$Measurement$variable)
  result$error <- ifelse(
    all(result$details),
    0,
    2
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateMeasurementDataExtraction <- function(x) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "dataExtractionID is 'none', 'NA', NA, or in DataExtraction$dataExtractionID"
  ##
  result$details <- x$Measurement$dataExtractionID %in% c(x$DataExtraction$dataExtractionID, "none", "NA", NA)
  names(result$details) <- x$Measurement$dataExtractionID
  #
  result$error <- ifelse(
    all(result$details),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateDataExtractionIDUnique <- function(x) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "names unique"
  result$description <- paste(
    "Check if the names specified in `dataExtractionID` are unique."
  )
  result$descriptionDetails <- paste(
    "returns a named vector, with the following possible values:\n",
    "     TRUE:  the value is unique\n",
    "     FALSE: the value is na duplicate\n",
    "One or more FALSE will result in an ERROR."
  )
  ##
  result$details <- data.frame(
    dataExtractionID = x$DataExtraction$dataExtractionID,
    isOK = !duplicated(x$DataExtraction$dataExtractionID)
  )
  ##
  result$error = ifelse(
    all(result$details$isOK),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateDataExtractionIDLinked <- function(x) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "name is in Measurement$dataExtractionID"
  ##
  result$details <- data.frame(
    dataExtractionID = x$DataExtraction$dataExtractionID,
    isOK = x$DataExtraction$dataExtractionID %in% x$Measurement$dataExtractionID
  )
  ##
  result$error <- ifelse(
    all(result$details$isOK),
    0,
    2
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateDataFileMetaDataDataFileExists <- function(x, path) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "dataFile exists in path"
  ##
  fns <- unique(x$DataFileMetaData$dataFileName)
  result$details <- tibble::tibble(
    dataFileName = fns,
    IsOK = fns %>% file.path(path, .) %>% file.exists()
  )
  ##
  result$error <- ifelse(
    all(result$details$IsOK),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateDataFileMetaDataDateTimeSpecified <- function(x){
  result <- new_emeScheme_validation()
  ##
  result$header <- "if type == 'datetime', description has format information"
  ##
  result$details <- x$DataFileMetaData %>%
    dplyr::select(.data$dataFileName, .data$columnName, .data$type, .data$description) %>%
    dplyr::filter(.data$type %in% c("date", "time", "datetime") )

  result$details$IsOK <- !is.na(result$details$description)
  ##
  result$error <- ifelse(
    all( result$details$IsOK ),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateDataFileMetaDataMapping <- function(x) {
  ## if columnData == “Measurement”, mappingColumn has to be in Measurement$measurementID and
  ## if columnData == “Treatment”, mappingColumn has to be in Treatment$treatmentID and
  ## if columnData %in% c(ID, other), mapping column has to be "NA" or NA
  result <- new_emeScheme_validation()
  ##
  result$header <- "correct values in mappingColumn in dependence on columnData"
  ##
  result$details <- x$DataFileMetaData$mappingColumn
  result$details[] <- NA
  i <- x$DataFileMetaData$columnData == "Treatment"
  result$details[i] <- x$DataFileMetaData$mappingColumn[i] %in% x$Treatment$treatmentID
  i <- x$DataFileMetaData$columnData == "Measurement"
  result$details[i] <- x$DataFileMetaData$mappingColumn[i] %in% x$Measurement$measurementID
  i <- x$DataFileMetaData$columnData == "ID"
  result$details[i] <- x$DataFileMetaData$mappingColumn[i] %in% c("NA", NA)
  i <- x$DataFileMetaData$columnData == "other"
  result$details[i] <- x$DataFileMetaData$mappingColumn[i] %in% c("NA", NA)
  result$details <- tibble::tibble(
    mappingColumn = x$DataFileMetaData$mappingColumn,
    IsOK = as.logical(result$details)
  )
  ##
  result$error <- ifelse(
    all(result$details$IsOK),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

readColumnNamesFromDataFiles <- function(x, path) {
  dfcol <- file.path(path, x$DataFileMetaData$dataFileName) %>%
    unique() %>%
    lapply(
      function(x) {
        if (file.exists(x)) {
          colnames(read.csv(x, nrows = 1))
        } else {
          NA
        }
      }
    )
  names(dfcol) <- x$DataFileMetaData$dataFileName %>% unique()
  return(dfcol)
}

validateDataFileMetaDataColumnNameInDataFile <- function(x, path) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "columnName in column names in dataFileName"
  ##
  dfcol <- readColumnNamesFromDataFiles(x, path)
  result$details <- x$DataFileMetaData$columnName
  for (i in 1:nrow(x$DataFileMetaData)) {
    result$details[i] <- x$DataFileMetaData$columnName[[i]] %in% dfcol[[x$DataFileMetaData$dataFileName[i]]]
  }
  result$details <-
    tibble(
      dataFileName = x$DataFileMetaData$dataFileName,
      columnName = x$DataFileMetaData$columnName,
      IsOK = as.logical(result$details)
    )
  ##
  result$error <- ifelse(
    all(result$details$IsOK),
    0,
    3
  )
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

validateDataFileMetaDataDataFileColumnDefined <- function(x, path) {
  result <- new_emeScheme_validation()
  ##
  result$header <- "column names in dataFileName in columnName"
  ##
  dfcol <- readColumnNamesFromDataFiles(x, path)
  result$details <- lapply(
    1:length(dfcol),
    function(i){
      cn <- dplyr::filter(x$DataFileMetaData, .data$dataFileName == names(dfcol[i])) %>%
        dplyr::select(.data$columnName) %>%
        magrittr::extract2(1)
      x <- tibble(
        dataFile = names(dfcol)[i],
        columnNameInDataFileName = cn,
        IsOK = cn %in% dfcol[[i]]
      )
      return(x)
    }
  )
  names(result$details) <- names(dfcol)
  #
  result$error <- ifelse(
    lapply(result$details, "[[", "IsOK") %>% unlist() %>% all(),
    0,
    3
  )
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}

# Internal validation functions -------------------------------------------

validateStructure <- function( x ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "Structural / Formal validity"
  result$description <- paste(
    "Test if the structure of the metadata is correct. ",
    "This includes column names, required info, ... ",
    "Should normally be OK, if no modification has been done."
  )
  result$descriptionDetails <- "No further details available."
  ##
  struct <- new_emeSchemeSet( x, keepData = FALSE, verbose = FALSE)
  attr(struct, "propertyName") <- "emeScheme"
  result$details <- all.equal(struct, emeScheme)
  if (isTRUE(result$details)){
    result$error <- 0
  } else {
    result$error <- 3
  }
  ##
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateExperiment <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "Experiment"
  ##
  result$types <- validateTypes(xraw$Experiment, xconv$Experiment)
  result$suggestedValues <- validateSuggestedValues(xraw$Experiment)
  ##
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateSpecies <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "Species"
  ##
  result$types <- validateTypes(xraw$Species, xconv$Species)
  result$suggestedValues <- validateSuggestedValues(xraw$Species)
  result$speciesNames <- validateSpeciesNames(xraw)
  ##
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateTreatment <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "Treatment"
  ##
  result$types <- validateTypes(xraw$Treatment, xconv$Treatment)
  result$suggestedValues <- validateSuggestedValues(xraw$Treatment)
  result$parameterInMappinColumn <- validateTreatmentMapping(xraw)
  ##
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateMeasurement <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "Measurement"
  ##
  result$types <- validateTypes(xraw$Measurement, xconv$Measurement)
  result$suggestedValues <- validateSuggestedValues(xraw$Measurement)
  result$nameUnique <- validateMeasurementNamesUnique(xraw)
  result$measuredFrom <- validateMeasurementMeasuredFrom(xraw)
  result$variableInMappinColumn <- validateMeasurementInMappingColumn(xraw)
  result$dataExtractionIDInDataExtractionID <- validateMeasurementDataExtraction(xraw)
  ##
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateDataExtraction <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "DataExtraction"
  ##
  result$types <- validateTypes(xraw$DataExtraction, xconv$DataExtraction)
  result$suggestedValues <- validateSuggestedValues(xraw$DataExtraction)
  result$nameUnique <- validateDataExtractionIDUnique(xraw)
  result$nameInDataExtractionName <- validateDataExtractionIDLinked(xraw)
  ##
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateDataFileMetaData <- function( x, xraw, xconv, path ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "DataFileMetaData"
  ##
  result$types <- validateTypes(xraw$DataFileMetaData, xconv$DataFileMetaData)
  result$allowedValues <- validateAllowedValues(xraw$DataFileMetaData)
  result$dataFilesExist <- validateDataFileMetaDataDataFileExists(xraw, path)
  result$datetimeFormatSpecified <- validateDataFileMetaDataDateTimeSpecified(xraw)
  result$mappingColumnInNameOrParameter <- validateDataFileMetaDataMapping(xraw)
  result$columnNameInDataFileColumn <- validateDataFileMetaDataColumnNameInDataFile(xraw, path)
  result$dataFileColumnInColumnNamen <- validateDataFileMetaDataDataFileColumnDefined(xraw, path)
  ##
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}


validateDataFiles <- function( x, xraw, xconv, path ){
  result <- new_emeScheme_validation()
  ##
  result$header <- "Data Files"
  ##
  result$error <- NA # max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol(result)
  ##
  return(result)
}



