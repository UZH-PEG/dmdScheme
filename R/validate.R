#' Validate structure of object of class \code{emeSchemeSet_raw} against \code{emeScheme}.
#'
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
#' @param errorIfFalse if \code{TRUE} an error will be raised if the schemes are not identical, i.e. there are structural differences.
#'
#' @return return invisibly the report in form of a \code{list}
#'
#' @importFrom taxize gnr_resolve
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr filter
#' @importFrom utils browseURL
#' @importFrom rmarkdown render
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
  errorIfFalse = TRUE
) {

  # HELPER: Validate Experiment ------------------------------------------------

  validateExperiment <- function( x ){
    s <- x$Experiment
    ##
    result <- list()
    result$result <- "TODO"
    ##
    return(result)
  }

  # HELPER: Validate Species ------------------------------------------------

  validateSpecies <- function( x ){
    s <- x$Species
    ##
    result <- list()

    # Validate species names --------------------------------------------------
    result$speciesNames <- taxize::gnr_resolve(s$name, best_match_only = TRUE)
    return(result)
  }

  # HELPER: Validate Treatment ------------------------------------------------

  validateTreatment <- function( x ){
    s <- x$Treatment
    ##
    result <- list()
    result$result <- "TODO"
    ##
    return(result)
  }

  # HELPER: Validate Measurement ------------------------------------------------

  validateMeasurement <- function( x ){
    s <- x$Measurement
    ##
    result <- list()
    result$result <- "TODO"
    ##
    return(result)
  }

  # HELPER: Validate DataExtraction ------------------------------------------------

  validateDataExtraction <- function( x ){
    s <- x$DataExtraction
    ##
    result <- list()
    result$result <- "TODO"
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

  validateDataFileMetaData <- function( x ){
    s <- x$DataFileMetaData
    dfns <- unique(s$dataFileName)
    names(dfns) <- dfns
    dfns <- file.path(path, dfns)
    result <- lapply(
      dfns,
      function(dfn) {
        result <- list()

        # Validate existence of data files ----------------------------------------
        result$fileExists <- file.exists(dfn)
        if (file.exists(dfn)) {

          # Validate columne --------------------------------------------------------

          result$valColumns <- valCol(
            s %>% dplyr::filter(.data$dataFileName == dfn)
          )

        }
        return(result)
      }
    )
    return(result)
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
  # Check arguments ---------------------------------------------------------

  allowedFormats <- c("none", "html", "pdf", "word", "all")
  if (!(report %in% allowedFormats)) {
    stop("'report' has to be one of the following values: ", allowedFormats)
  }

  # Define result structure -------------------------------------------------

  result <- list()

  # Validate structure ------------------------------------------------------

  struct <- new_emeSchemeSet( x, keepData = FALSE, verbose = FALSE)
  attr(struct, "propertyName") <- "emeScheme"
  result$structOK <- all.equal(struct, emeScheme)
  if (!isTRUE(result$structOK) & errorIfFalse){
    cat_ln(result)
    stop("x would result in a scheme which is not identical to the emeScheme!")
  }

  # Validata data -----------------------------------------------------------


  if (isTRUE(result$structOK) & validateData){
    dat <- new_emeSchemeSet( x, keepData = TRUE, verbose = FALSE)

    # Validate Experiment --------------------------------------------------------

    result$Experiment <- validateExperiment(dat)

    # Validate Species --------------------------------------------------------

    result$Species <- validateSpecies(dat)

    # Validate Treatment --------------------------------------------------------

    result$Treatment <- validateTreatment(dat)

    # Validate Measurement --------------------------------------------------------

    result$Measurement <- validateMeasurement(dat)

    # Validate DataExtraction --------------------------------------------------------

    result$DataExtraction <- validateDataExtraction(dat)

    # Validate DataFileMetaData -----------------------------------------------

    result$DataFileMetaData <- validateDataFileMetaData(dat)

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

  invisible(result)
}


