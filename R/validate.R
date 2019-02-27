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

  # HELPER: new_emeScheme_validation ----------------------------------------

  new_emeScheme_validation <- function() {
    result <- list(
      error = NA,
      details = NA
    )
    class(result) <- append( "emeScheme_validation", class(result) )
    return(result)
  }

  # HELPER: checkTypes ------------------------------------------------------

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


  # HELPER: checkSuggestedValues --------------------------------------------

  checkSuggestedValues <- function(sraw) {
    result <- new_emeScheme_validation()
    ##
    result$details <- as_tibble(sraw)
    sugVal <- strsplit(attr(sraw, "suggestedValues"), ",")
    ##
    for (colN in 1:ncol(sraw)) {
      v <- trimws(sugVal[[colN]] )
      for (rowN in 1:nrow(sraw)) {
        if ( all(is.na(v)) | is.na(result$details[rowN, colN]) ) {
          sug <- NA
        } else {
          sug <- result$details[rowN, colN] %in% v
          sug <- ifelse(
            sug,
            "OK",
            paste0("'", result$details[rowN, colN], "' not in suggested Values!")
          )
        }
        result$details[rowN, colN] <- sug
      }
    }
    ##
    result$error = ifelse( all(result$details == "OK",na.rm = TRUE), 0, 2)
    ##
    return( result )
  }

  # HELPER: checkAllowedValues --------------------------------------------

  checkAllowedValues <- function(sraw) {
    result <- new_emeScheme_validation()
    ##
    result$details <- as_tibble(sraw)
    allVal <- strsplit(attr(sraw, "allowedValues"), ",")
    ##
    for (colN in 1:ncol(sraw)) {
      v <- trimws(allVal[[colN]] )
      for (rowN in 1:nrow(sraw)) {
        if ( all(is.na(v)) | is.na(result$details[rowN, colN]) ) {
          al <- NA
        } else {
          al <- result$details[rowN, colN] %in% v
          al <- ifelse(
            al,
            "OK",
            paste0("'", result$details[rowN, colN], "' not in allowed Values!")
          )
        }
        result$details[rowN, colN] <- al
      }
    }
    ##
    result$error = ifelse( all(result$details == "OK",na.rm = TRUE), 0, 3)
    ##
    return( result )
  }


  # HELPER: Validate Structure ------------------------------------------------

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
    return(result)
  }

  # HELPER: Validate Experiment ------------------------------------------------

  validateExperiment <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    result$types <- checkTypes(xraw$Experiment, xconv$Experiment)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Experiment)
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }

  # HELPER: Validate Species ------------------------------------------------

  validateSpecies <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    result$types <- checkTypes(xraw$Species, xconv$Species)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Species)
    ##

    # Validate species names --------------------------------------------------
    result$speciesNames <- new_emeScheme_validation()
    result$speciesNames$details <- taxize::gnr_resolve(xraw$Species$name, best_match_only = TRUE)
    if (length(attr(result$speciesNames$details, "not_known")) > 0) {
      result$speciesNames$error <- 2
    } else if (min(result$speciesNames$details$score) < 0.7) {
      result$speciesNames$error <- 2
    }
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }

  # HELPER: Validate Treatment ------------------------------------------------

  validateTreatment <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    s <- x$Treatment
    ##
    result$types <- checkTypes(xraw$Treatment, xconv$Treatment)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Treatment)
    ##
    res <- new_emeScheme_validation()
    res$details <- unique(xraw$Treatment$parameter) %in% xraw$DataFileMetaData$mappingColumn
    names(res$details) <- unique(xraw$Treatment$parameter)
    res$error <- ifelse(
      all(res$details),
      0,
      2
    )
    result$parameterInMappinColumn <- res
    rm(res)
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }

  # HELPER: Validate Measurement ------------------------------------------------

  validateMeasurement <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    result$types <- checkTypes(xraw$Measurement, xconv$Measurement)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Measurement)
    ##
    ## names unique
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
    ##
    ##  measuredFrom in name, raw, "NA" or NA
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
    ##
    ## variable is in mappingColumn
    res <- new_emeScheme_validation()
    res$details <- unique(xraw$Measurement$variable) %in% xraw$DataFileMetaData$mappingColumn
    names(res$details) <- unique(xraw$Measurement$variable)
    res$error <- ifelse(
      all(res$details),
      0,
      2
    )
    result$variableInMappinColumn <- res
    rm(res)
    ##
    ## dataExtractionName is “none”, “NA”, or in DataExtraction$name
    res <- new_emeScheme_validation()
    res$details <- xraw$Measurement$dataExtractionName %in% c(xraw$DataExtraction$name, "none", "NA", NA)
    names(res$details) <- xraw$Measurement$dataExtractionName
    res$error <- ifelse(
      all(res$details),
      0,
      3
    )
    result$dataExtractionNameInDataExtractionName <- res
    rm(res)
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }

  # HELPER: Validate DataExtraction ------------------------------------------------

  validateDataExtraction <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    result$types <- checkTypes(xraw$DataExtraction, xconv$DataExtraction)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$DataExtraction)
    ## names unique
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
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    ##
    ##  `name` is in `Measurement$dataExtractionName`
    res <- new_emeScheme_validation()
    res$details <- xraw$DataExtraction$name %in% xraw$Measurement$dataExtractionName
    names(res$details) <- xraw$DataExtraction$name
    res$error <- ifelse(
      all(res$details),
      0,
      2
    )
    result$nameInDataExtractionName <- res
    rm(res)
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }



  # HELPER: Validate DataFileMetaData ---------------------------------------

  validateDataFileMetaData <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    result$types <- checkTypes(xraw$DataFileMetaData, xconv$DataFileMetaData)
    ##
    result$allowedValues <- checkAllowedValues(xraw$DataFileMetaData)
    ##
    result$dataFilesExist <- new_emeScheme_validation()
    fns <- unique(xraw$DataFileMetaData$dataFileName)
    fns <- file.path(path, fns)
    result$dataFilesExist$details <- file.exists(fns)
    names(result$dataFilesExist$details) <- fns
    result$dataFilesExist$error <- ifelse(
      all(result$dataFilesExist$details),
      0,
      3
    )
    ##
    result$datetimeFormatSpecified <- new_emeScheme_validation()
    result$datetimeFormatSpecified$details <- xraw$DataFileMetaData %>%
      dplyr::select(.data$type, .data$description) %>%
      filter( .data$type %in% c("date", "time", "datetime") )
    result$datetimeFormatSpecified$error <- ifelse(
      any( !is.na(result$datetimeFormatSpecified$details$description) ),
      0,
      3
    )
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
    res$details <- as.logical(res$details)
    names(res$details) <- xraw$DataFileMetaData$mappingColumn
    res$error <- ifelse(
      all(res$details),
      0,
      3
    )
    result$mappingColumnInNameOrParameter <- res
    rm(res)
    ##
    ## column name in data file
    res <- new_emeScheme_validation()
    #
    res$details <- xraw$DataFileMetaData$columnName
    for (i in 1:nrow(xraw$DataFileMetaData)) {
      df <- file.path(path, xraw$DataFileMetaData$dataFileName[i])
      cn <- xraw$DataFileMetaData$columnName[i]
      if (file.exists(df)) {
        res$details[i] <- cn %in% names(utils::read.csv(df))
      } else {
        res$details[i] <- FALSE
      }
    }
    res$details <- as.logical(res$details)
    names(res$details) <- xraw$DataFileMetaData$columnName
    #
    res$error <- ifelse(
      all(res$details),
      0,
      3
    )
    result$columnInDataFile <- res
    rm(res)
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }






  # HELPER: Validate dataFile -----------------------------------------------

  validateDataFile <- function( x, xraw, xconv ){
    result <- new_emeScheme_validation()
    ##
    result$error <- max(valErr_extract(result), na.rm = TRUE)
    ##
    return(result)
  }

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
  ##
  result$Experiment <- new_emeScheme_validation()
  result$Species <- new_emeScheme_validation()
  result$Treatment <- new_emeScheme_validation()
  result$Measurement <- new_emeScheme_validation()
  result$DataExtraction <- new_emeScheme_validation()
  result$DataFileMetaData <- new_emeScheme_validation()
  result$dataFile <- new_emeScheme_validation()
  ##

  # Validate structure ------------------------------------------------------

  result$structure <- validateStructure( x )
  if (result$structure$error != 0 & errorIfStructFalse) {
    cat_ln(result$structure$details)
    stop("Structure of the object to be evaluated is wrong. See the info above for details.")
  }


  # Validata data -----------------------------------------------------------

  if ((result$structure$error == 0) & validateData){

    # convert with and without conversion -------------------------------------

    xraw  <- new_emeSchemeSet(x, keepData = TRUE, convertTypes = FALSE, verbose = FALSE, warnToError = FALSE)
    xconv <- suppressWarnings( new_emeSchemeSet(x, keepData = TRUE, convertTypes = TRUE,  verbose = FALSE, warnToError = FALSE) )

    # Validate Experiment --------------------------------------------------------

    result$Experiment <- validateExperiment(x, xraw, xconv)

    # Validate Species --------------------------------------------------------

    result$Species <- validateSpecies(x, xraw, xconv)

    # Validate Treatment --------------------------------------------------------

    result$Treatment <- validateTreatment(x, xraw, xconv)

    # Validate Measurement --------------------------------------------------------

    result$Measurement <- validateMeasurement(x, xraw, xconv)

    # Validate DataExtraction --------------------------------------------------------

    result$DataExtraction <- validateDataExtraction(x, xraw, xconv)

    # Validate DataFileMetaData -----------------------------------------------

    result$DataFileMetaData <- validateDataFileMetaData(x, xraw, xconv)

  }

  # Set overall error -------------------------------------------------------

  result$error <- max(valErr_extract(result), na.rm = TRUE)

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


