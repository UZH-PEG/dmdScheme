#' Split \code{emeScheme} object into multiple by using \code{DataFileNameMetaData$dataFileName}
#'
#' One \code{emeScheme} object can contain metadata for multiple datafiles. For
#' archiving, these should be split into single \code{emeScheme} objects, one
#' for each \code{DataFileNameMetaData$dataFileName}.
#' The filtering is done as followed:
#' \describe{
#'   \item{DataFileMetaDFata}{\code{DataFileMetaData$dataFileName == dataFile}}
#'   \item{Treatment}{\code{Treatment$parameter \%in\% DataFileMetaData$mappingColumn} and \code{DataFileMetaData$columnData == "Treatment"} }
#'   \item{Measurement}{\code{Measurement$name \%in\% DataFileMetaData$mappingColumn} and \code{DataFileMetaData$columnData == "Measurement"} }
#' }
#' @param dataFile name of dataFileName whose metadata will be extracted from \code{x}. Has to be an exact match, no wildcards are expanded.
#' @param x \code{emeScheme} object from which data to extract
#'
#' @return \code{emeScheme} object containing metadata for the data file \code{dataFileName}
#'
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr select filter
#' @export
#'
#' @examples
#' emeScheme_extract("smell.csv", emeScheme_example)
#' ## returns the emeScheme data for the data file 'smell.csv'
#'
#' emeScheme_extract("DoesNotExist", emeScheme_example)
#' ## returns an empty emeScheme
emeScheme_extract <- function(
  dataFile,
  x
) {

# Argument check ----------------------------------------------------------

  if (!is(dataFile, "character")) {
    stop("dataFile has to be a string")
  }
  if (length(dataFile) > 1) {
    stop("dataFile has to be of length 1")
  }
  if (!is(x, "emeScheme")) {
    stop("x has to be an object of type emeScheme")
  }

# Get property name of x --------------------------------------------------

  propertyName <- attr(x, "propertyName")

# DataFileMetaData: keep only rows in which dataFileName == dataFile ------

  x$DataFileMetaData %<>%
    dplyr::filter(.data$dataFileName == dataFile)

# Treatment: Only keep treatmentID which are still in DataFileMetaData ------

  selTreatmentID <- x$DataFileMetaData %>%
    dplyr::filter((.data$columnData == "Treatment") | (.data$columnData == "Species") ) %>%
    dplyr::select(.data$mappingColumn) %>%
    unlist()
  x$Treatment %<>%
    dplyr::filter(.data$treatmentID %in% selTreatmentID)

# Measurement: Only keep measurementID which are still in DataFileMetaData ---------

  selMeasurementID <- x$DataFileMetaData %>%
    dplyr::filter(.data$columnData == "Measurement") %>%
    dplyr::select(.data$mappingColumn) %>%
    as.character
  x$Measurement %<>%
    dplyr::filter(.data$measurementID %in% selMeasurementID)

# ExtractionMethod: Only keep extractionMethodID which are still in DataFileMetaData --------

  selDataExtractionID <- x$Measurement %>%
    dplyr::select(.data$dataExtractionID) %>%
    as.character %>%
    unique
  x$DataExtraction %<>%
    dplyr::filter(.data$dataExtractionID %in% selDataExtractionID)

# Species: Only keep speciesID which are still in treatmentID ----------------------------------

  selTreatmentID <- x$DataFileMetaData %>%
    dplyr::filter(.data$columnData == "Species") %>%
    dplyr::select(.data$mappingColumn) %>%
    as.character()
  selSpeciesID <- x$Treatment %>%
    dplyr::filter(.data$treatmentID %in% selTreatmentID) %>%
    dplyr::select(.data$treatmentLevel) %>%
    unlist() %>%
    strsplit(",") %>%
    unlist() %>%
    trimws()
  x$Species %<>%
    dplyr::filter(.data$speciesID %in% selSpeciesID)


# Set property name -------------------------------------------------------

  attr(x, "propertyName") <- paste(dataFile, propertyName, sep = "_")

# Return ------------------------------------------------------------------

  return(x)
}
