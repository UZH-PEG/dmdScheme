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
#'
validate <- function(
  x,
  path = "",
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
    header = ""
  )
  class(result) <- append( "emeScheme_validation", class(result) )
  return(result)
}


checkTypes <- function(sraw, sconv) {
  result <- new_emeScheme_validation()
  ##
  t <- sraw == sconv
  na <- is.na(t)
  t[na] <- TRUE
  result$details <- as.data.frame(sraw)
  result$details[t] <- "OK"
  result$details[!t] <- paste( result$details[!t], "!=", as.data.frame(sconv)[!t])
  result$details[na] <- NA
  result$details <- as_tibble(result$details)
  ##
  result$error = ifelse( all(result$details == "OK",na.rm = TRUE), 0, 3)
  ##
  return( result )
}


checkSuggestedValues <- function(sraw) {
  result <- new_emeScheme_validation()
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
      al <- ifelse(
        al,
        "OK",
        paste0("'", result$details[rowN, colN], "' not in suggested Values!")
      )
      result$details[rowN, colN] <- al
    }
  }
  ##
  result$error = ifelse( all(result$details == "OK",na.rm = TRUE), 0, 2)
  ##
  return( result )

}


checkAllowedValues <- function(sraw) {
  result <- new_emeScheme_validation()
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
      al <- ifelse(
        al,
        "OK",
        paste0("'", result$details[rowN, colN], "' not in allowed Values!")
      )
      result$details[rowN, colN] <- al
    }
  }
  ##
  result$error = ifelse( all(result$details == "OK",na.rm = TRUE), 0, 3)
  ##
  return( result )
}


# Internal validation functions -------------------------------------------


validateStructure <- function( x ){
  result <- new_emeScheme_validation()
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
  result$header <- valErr_TextErrCol("Structural / Formal validity", result$error)
  ##
  return(result)
}


validateExperiment <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()

  # validate types ----------------------------------------------------------
  result$types <- checkTypes(xraw$Experiment, xconv$Experiment)
  result$types$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$types$error)

  # validate suggested values -----------------------------------------------
  result$suggestedValues <- checkSuggestedValues(xraw$Experiment)
  result$suggestedValues$header <- valErr_TextErrCol("values in suggestedValues", result$suggestedValues$error)

  # overall error -----------------------------------------------------------
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("Experiment", result$error)
  ##
  return(result)
}


validateSpecies <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()

  # validate types ----------------------------------------------------------
  result$types <- checkTypes(xraw$Species, xconv$Species)
  result$types$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$types$error)

  # validate suggested values -----------------------------------------------
  result$suggestedValues <- checkSuggestedValues(xraw$Species)
  result$suggestedValues$header <- valErr_TextErrCol("values in suggestedValues", result$suggestedValues$error)

  # Validate species names --------------------------------------------------
  result$speciesNames <- new_emeScheme_validation()
  result$speciesNames$details <- taxize::gnr_resolve(xraw$Species$name, best_match_only = TRUE)
  if (length(attr(result$speciesNames$details, "not_known")) > 0) {
    result$speciesNames$error <- 2
  } else if (min(result$speciesNames$details$score) < 0.7) {
    result$speciesNames$error <- 2
  } else {
    result$speciesNames$error <- 0
  }
  result$speciesNames$header <- valErr_TextErrCol("name in species database and report score (using taxize::gnr_resolve())", result$speciesNames$error)

  # overall error -----------------------------------------------------------
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("Species", result$error)
  ##
  return(result)
}


validateTreatment <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()

  # validate types ----------------------------------------------------------
  result$types <- checkTypes(xraw$Treatment, xconv$Treatment)
  result$types$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$types$error)

  # validate suggested values -----------------------------------------------
  result$suggestedValues <- checkSuggestedValues(xraw$Treatment)
  result$suggestedValues$header <- valErr_TextErrCol("values in suggestedValues", result$suggestedValues$error)

  # validate mapping --------------------------------------------------------
  res <- new_emeScheme_validation()
  res$details <- unique(xraw$Treatment$parameter) %in% xraw$DataFileMetaData$mappingColumn
  names(res$details) <- unique(xraw$Treatment$parameter)
  res$error <- ifelse(
    all(res$details),
    0,
    2
  )
  res$header <- valErr_TextErrCol("parameter is in mappingColumn", res$error)
  result$parameterInMappinColumn <- res
  rm(res)

  # overall error -----------------------------------------------------------
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("Treatment", result$error)
  ##
  return(result)
}


validateMeasurement <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()

  # validate types ----------------------------------------------------------
  result$types <- checkTypes(xraw$Measurement, xconv$Measurement)
  result$types$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$types$error)

  # validate suggested values -----------------------------------------------
  result$suggestedValues <- checkSuggestedValues(xraw$Measurement)
  result$suggestedValues$header <- valErr_TextErrCol("values in suggestedValues", result$suggestedValues$error)

  # validate names unique ---------------------------------------------------
  nu <- !duplicated(xraw$Measurement$name)
  names(nu) <- xraw$Measurement$name
  result$nameUnique <- list(
    error = ifelse(
      all(nu),
      0,
      3
    ),
    details = nu
  )
  rm(nu)
  result$nameUnique$header <- valErr_TextErrCol("names unique", result$nameUnique$error)

  # measuredFrom in name, raw, "NA" or NA -----------------------------------
  mf <- xraw$Measurement$measuredFrom %in% c(xraw$Measurement$name, "raw", "NA", NA)
  names(mf) <- xraw$Measurement$name
  result$measuredFrom <- list(
    error = ifelse(
      all(mf),
      0,
      3
    ),
    details = mf
  )
  rm(mf)
  result$measuredFrom$header <- valErr_TextErrCol("measuredFrom is 'raw', 'NA', NA or in name", result$measuredFrom$error)

  # variable is in mappingColumn --------------------------------------------
  res <- new_emeScheme_validation()
  res$details <- unique(xraw$Measurement$variable) %in% xraw$DataFileMetaData$mappingColumn
  names(res$details) <- unique(xraw$Measurement$variable)
  res$error <- ifelse(
    all(res$details),
    0,
    2
  )
  res$header <- valErr_TextErrCol("variable is in mappingColumn", res$error)
  result$variableInMappinColumn <- res
  rm(res)

  # dataExtractionName is “none”, “NA”, or in DataExtraction$name -----------
  res <- new_emeScheme_validation()
  res$details <- xraw$Measurement$dataExtractionName %in% c(xraw$DataExtraction$name, "none", "NA", NA)
  names(res$details) <- xraw$Measurement$dataExtractionName
  res$error <- ifelse(
    all(res$details),
    0,
    3
  )
  res$header <- valErr_TextErrCol("dataExtractionName is 'none', 'NA', NA, or in DataExtraction$name", res$error)
  result$dataExtractionNameInDataExtractionName <- res
  rm(res)

  # overall error -----------------------------------------------------------
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("Measurement", result$error)
  ##
  return(result)
}


validateDataExtraction <- function( x, xraw, xconv ){
  result <- new_emeScheme_validation()

  # validate types ----------------------------------------------------------
  result$types <- checkTypes(xraw$DataExtraction, xconv$DataExtraction)
  result$types$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$types$error)

  # validate suggested values -----------------------------------------------
  result$suggestedValues <- checkSuggestedValues(xraw$DataExtraction)
  result$suggestedValues$header <- valErr_TextErrCol("values in suggestedValues", result$suggestedValues$error)

  # names unique ------------------------------------------------------------
  nu <- !duplicated(xraw$DataExtraction$name)
  names(nu) <- xraw$DataExtraction$name
  result$nameUnique <- list(
    error = ifelse(
      all(nu),
      0,
      3
    ),
    details = nu
  )
  rm(nu)
  result$nameUnique$header <- valErr_TextErrCol("names unique", result$nameUnique$error)

  # `name` is in `Measurement$dataExtractionName` ---------------------------
  res <- new_emeScheme_validation()
  res$details <- xraw$DataExtraction$name %in% xraw$Measurement$dataExtractionName
  names(res$details) <- xraw$DataExtraction$name
  res$error <- ifelse(
    all(res$details),
    0,
    2
  )
  res$header <- valErr_TextErrCol("name is in Measurement$dataExtractionName", res$error)
  result$nameInDataExtractionName <- res
  rm(res)

  # overall error -----------------------------------------------------------
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("DataExtraction", result$error)
  ##
  return(result)
}


validateDataFileMetaData <- function( x, xraw, xconv, path ){
  result <- new_emeScheme_validation()

  # validate types ----------------------------------------------------------
  result$types <- checkTypes(xraw$DataFileMetaData, xconv$DataFileMetaData)
  result$types$header <- valErr_TextErrCol("conversion of values into specified type lossless possible", result$types$error)

  # vaidate allowed values --------------------------------------------------
  result$allowedValues <- checkAllowedValues(xraw$DataFileMetaData)
  result$allowedValues$header <- valErr_TextErrCol("values in allowedValues", result$allowedValues$error)

  # validate data file exists -----------------------------------------------
  result$dataFilesExist <- new_emeScheme_validation()
  fns <- unique(xraw$DataFileMetaData$dataFileName)
  result$dataFilesExist$details <- tibble::tibble(
    dataFileName = fns,
    IsOK = fns %>% file.path(path, .) %>% file.exists()
  )
  result$dataFilesExist$error <- ifelse(
    all(result$dataFilesExist$details$IsOK),
    0,
    3
  )
  result$dataFilesExist$header <- valErr_TextErrCol("dataFile exists in path", result$dataFilesExist$error)

  # validate datetime format specified --------------------------------------
  result$datetimeFormatSpecified <- new_emeScheme_validation()
  result$datetimeFormatSpecified$details <- xraw$DataFileMetaData %>%
    dplyr::select(.data$dataFileName, .data$columnName, .data$type, .data$description) %>%
    dplyr::filter(.data$type %in% c("date", "time", "datetime") )

  result$datetimeFormatSpecified$details$IsOK <- !is.na(result$datetimeFormatSpecified$details$description)

  result$datetimeFormatSpecified$error <- ifelse(
    all( result$datetimeFormatSpecified$details$IsOK ),
    0,
    3
  )
  result$datetimeFormatSpecified$header <- valErr_TextErrCol("if type == 'datetime', description has format information", result$datetimeFormatSpecified$error)

  # validate mapping --------------------------------------------------------
  ## if columnData == “Measurement”, mappingColumn has to be in Measurement$name and
  ## if columnData == “Treatment”, mappingColumn has to be in Treatment$parameter and
  ## if columnData %in% c(ID, other), mapping column has to be "NA" or NA
  res <- new_emeScheme_validation()
  res$details <- xraw$DataFileMetaData$mappingColumn
  res$details[] <- NA
  #
  i <- xraw$DataFileMetaData$columnData == "Treatment"
  res$details[i] <- xraw$DataFileMetaData$mappingColumn[i] %in% xraw$Treatment$parameter
  i <- xraw$DataFileMetaData$columnData == "Measurement"
  res$details[i] <- xraw$DataFileMetaData$mappingColumn[i] %in% xraw$Measurement$name
  i <- xraw$DataFileMetaData$columnData == "ID"
  res$details[i] <- xraw$DataFileMetaData$mappingColumn[i] %in% c("NA", NA)
  i <- xraw$DataFileMetaData$columnData == "other"
  res$details[i] <- xraw$DataFileMetaData$mappingColumn[i] %in% c("NA", NA)
  #
  res$details <- tibble::tibble(
    mappingColumn = xraw$DataFileMetaData$mappingColumn,
    IsOK = as.logical(res$details)
  )
  res$error <- ifelse(
    all(res$details$IsOK),
    0,
    3
  )
  res$header <- valErr_TextErrCol("correct values in mappingColumn in dependence on columnData", res$error)
  result$mappingColumnInNameOrParameter <- res
  rm(res)

  # read column names of data files -----------------------------------------
  dfcol <- file.path(path, xraw$DataFileMetaData$dataFileName) %>%
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
  names(dfcol) <- xraw$DataFileMetaData$dataFileName %>% unique()

  # DataFileMetaData$columnName is column name in dataFile ------------------------------------------------
  res <- new_emeScheme_validation()
  #
  res$details <- xraw$DataFileMetaData$columnName
  for (i in 1:nrow(xraw$DataFileMetaData)) {
    res$details[i] <- xraw$DataFileMetaData$columnName[[i]] %in% dfcol[[xraw$DataFileMetaData$dataFileName[i]]]
  }
  res$details <-
    tibble(
      dataFileName = xraw$DataFileMetaData$dataFileName,
      columnName = xraw$DataFileMetaData$columnName,
      IsOK = as.logical(res$details)
    )
  #
  res$error <- ifelse(
    all(res$details$IsOK),
    0,
    3
  )
  res$header <- valErr_TextErrCol("columnName in column names in dataFileName", res$error)
  result$columnNameInDataFileColumn <- res
  rm(res)


  # column names in dataFile are in DataFileMetaData$columnName ---------
  res <- new_emeScheme_validation()
  #
  res$details <- lapply(
    1:length(dfcol),
    function(i){
      cn <- dplyr::filter(xraw$DataFileMetaData, .data$dataFileName == names(dfcol[i])) %>%
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
  names(res$details) <- names(dfcol)
  #
  res$error <- ifelse(
    lapply(res$details, "[[", "IsOK") %>% unlist() %>% all(),
    0,
    3
  )
  res$header <- valErr_TextErrCol("column names in dataFileName in columnName", res$error)
  result$dataFileColumnInColumnNamen <- res
  rm(res)

  # overall error -----------------------------------------------------------
  result$error <- max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("DataFileMetaData", result$error)
  ##
  return(result)
}


validateDataFiles <- function( x, xraw, xconv, path ){
  result <- new_emeScheme_validation()

  # overall error -----------------------------------------------------------
  result$error <- NA # max(valErr_extract(result), na.rm = FALSE)
  result$header <- valErr_TextErrCol("Data Files", result$error)
  ##
  return(result)
}



