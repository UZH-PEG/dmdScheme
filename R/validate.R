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
#' @importFrom dplyr filter
#' @importFrom utils browseURL
#' @importFrom rmarkdown render
#' @importFrom tibble tibble
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

  # HELPER: checkTypes ------------------------------------------------------

  checkTypes <- function(sraw, sconv) {
    t <- sraw == sconv
    na <- is.na(t)
    t[na] <- TRUE
    result <- as.data.frame(sraw)
    result[t] <- "OK"
    result[!t] <- paste( result[!t], "!=", as.data.frame(sconv)[!t])
    result[na] <- NA
    ##
    return(as_tibble(result))
  }


  # HELPER: checkSuggestedValues --------------------------------------------

  checkSuggestedValues <- function(sraw) {
    result <- as_tibble(sraw)
    sugVal <- strsplit(attr(sraw, "suggestedValues"), ",")
    ##
    for (colN in 1:ncol(sraw)) {
      v <- trimws(sugVal[[colN]] )
      for (rowN in 1:nrow(sraw)) {
        if ( all(is.na(v)) | is.na(result[rowN, colN]) ) {
          sug <- NA
        } else {
          sug <- result[rowN, colN] %in% v
          sug <- ifelse(
            sug,
            "OK",
            paste0("'", result[rowN, colN], "' not in suggested Values!")
          )
        }
        result[rowN, colN] <- sug
      }
    }
    ##
    return(result)
  }

  # HELPER: checkAllowedValues --------------------------------------------

  checkAllowedValues <- function(sraw) {
    result <- as_tibble(sraw)
    allVal <- strsplit(attr(sraw, "allowedValues"), ",")
    ##
    for (colN in 1:ncol(sraw)) {
      v <- trimws(allVal[[colN]] )
      for (rowN in 1:nrow(sraw)) {
        if ( all(is.na(v)) | is.na(result[rowN, colN]) ) {
          al <- NA
        } else {
          al <- result[rowN, colN] %in% v
          al <- ifelse(
            al,
            "OK",
            paste0("'", result[rowN, colN], "' not in allowed Values!")
          )
        }
        result[rowN, colN] <- al
      }
    }
    ##
    return(result)
  }


  # HELPER: Validate Structure ------------------------------------------------

  validateStructure <- function( x ){
    ##
    result <- list(
      result = FALSE,
      details = NA
    )
    ##
    struct <- new_emeSchemeSet( x, keepData = FALSE, verbose = FALSE)
    attr(struct, "propertyName") <- "emeScheme"
    result$details <- all.equal(struct, emeScheme)
    if (isTRUE(result$details)){
      result$result <- TRUE
      result$details <- "OK"
    } else {
      result$result <- FALSE
    }
    ##
    return(result)
  }

  # HELPER: Validate Experiment ------------------------------------------------

  validateExperiment <- function( x, xraw, xconv ){
    s <- x$Experiment
    ##
    result <- list(
      result = FALSE,
      details = NA
    )
    ##
    ##
    result$types <- checkTypes(xraw$Experiment, xconv$Experiment)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Experiment)
    # return ------------------------------------------------------------------

    return(result)
  }

  # HELPER: Validate Species ------------------------------------------------

  validateSpecies <- function( x, xraw, xconv ){
    ##
    result <- list(
      result = FALSE,
      details = NA
    )
    ##
    result$types <- checkTypes(xraw$Species, xconv$Species)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Species)
    ##

    # Validate species names --------------------------------------------------
    result$speciesNames <- taxize::gnr_resolve(xraw$Species$name, best_match_only = TRUE)
    ##
    return(result)
  }

  # HELPER: Validate Treatment ------------------------------------------------

  validateTreatment <- function( x, xraw, xconv ){
    s <- x$Treatment
    ##
    result <- list()
    result$result <- "TODO"
    ##
    result$types <- checkTypes(xraw$Treatment, xconv$Treatment)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Treatment)
    ##
    return(result)
  }

  # HELPER: Validate Measurement ------------------------------------------------

  validateMeasurement <- function( x, xraw, xconv ){
    ##
    result <- list(
      result = FALSE,
      details = NA
    )
    ##
    result$types <- checkTypes(xraw$Measurement, xconv$Measurement)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$Measurement)
    ##
    return(result)
  }

  # HELPER: Validate DataExtraction ------------------------------------------------

  validateDataExtraction <- function( x, xraw, xconv ){
    ##
    result <- list(
      result = FALSE,
      details = NA
    )
    ##
    result$types <- checkTypes(xraw$DataExtraction, xconv$DataExtraction)
    ##
    result$suggestedValues <- checkSuggestedValues(xraw$DataExtraction)
    ##
    return(result)
  }

  # HELPER: Validate Columns ------------------------------------------------

  valCol <- function( x ){
    cols <- unique(x$variableName)
    names(cols) <- cols

    result$columns <- lapply(
      cols,
      function (col) {
        result <- list()
        result$correctType <- "TODO"
        result$inDataFile <- "TODO"
        result$range <- c(NA, NA) # range(0,0)
        result$uniqueValues <- NA # unique(letters)
      }
    )
    return(result)
  }


  # HELPER: Validate DataFileMetaData ---------------------------------------

  validateDataFileMetaData <- function( x, xraw, xconv ){
    ##
    result <- list(
      result = FALSE,
      details = NA
    )
    ##
    result$types <- checkTypes(xraw$DataFileMetaData, xconv$DataFileMetaData)
    ##
    result$allowedValues <- checkAllowedValues(xraw$DataFileMetaData)
    ##
    dfns <- unique(xraw$DataFileMetaData$dataFileName)
    names(dfns) <- dfns
    dfns <- file.path(path, dfns)
    result$fileExists <- file.exists(dfns)
    names(result$fileExists) <- dfns
    #
    #   lapply(
    #   dfns,
    #   function(dfn) {
    #     # Validate existence of data files ----------------------------------------
    #     file.exists(dfn)
    #     if (file.exists(dfn)) {
    #
    #       # Validate columne --------------------------------------------------------
    #
    #       result$valColumns <- valCol(
    #         s %>% dplyr::filter(.data$dataFileName == dfn)
    #       )
    #
    #     }
    #     return(result)
    #   }
    # )
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

  result <- list(
    structure = list(
      result = NA
    ),
    Experiment = list(
      result = NA
    ),
    Species = list(
      result = NA
    ),
    Treatment = list(
      result = NA
    ),
    Measurement = list(
      result = NA
    ),
    DataExtraction = list(
      result = NA
    ),
    DataFileMetaData = list(
      result = NA
    )
  )
  class(result) <- append( "emeScheme_validation", class(result) )

  # Validate structure ------------------------------------------------------

  result$structure <- validateStructure( x )
  if (!result$structure$result & errorIfStructFalse) {
    cat_ln(result$structure$details)
    stop("Structure of the object to be evaluated is wrong. See the info above for details.")
  }


  # Validata data -----------------------------------------------------------

  if (result$structure$result & validateData){

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


