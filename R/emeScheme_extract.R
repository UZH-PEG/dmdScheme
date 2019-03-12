#' Split \code{emeScheme} object into multiple by using \code{DataFileNameMetaData$dataFileName}
#'
#' One \code{emeScheme} object can contain metadata for multiple datafiles. For
#' archiving, these should be split into single \code{emeScheme} objects, one
#' for each \code{DataFileNameMetaData$dataFileName}.
#' The filtering is done as followed:
#' \itemized{
#' \item{DataFileMetaDFata} {\code{DataFileMetaData$dataFileName == dataFile}}
#' \item{Treatment} {\code{Treatment$parameter %in% DataFileMetaData$mappingColumn} and \code{DataFileMetaData$columnData == "Treatment}}
#' \item{Measurement} {\code{Measurement$name %in% DataFileMetaData$mappingColumn} and \code{DataFileMetaData$columnData == "Measurement}}
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

name_x <- attr(x, "name")

# DataFileMetaData: keep only rows in which dataFileName == dataFile ------

  x$DataFileMetaData %<>%
    dplyr::filter(.data$dataFileName == dataFile)

# Treatment: Only keep parameter which are still in DataFileMetaData ------

  selParameter <- x$DataFileMetaData %>%
    dplyr::filter(.data$columnData == "Treatment") %>%
    dplyr::select(mappingColumn) %>%
    as.character
  x$Treatment %<>%
    dplyr::filter(.data$parameter == selParameter)

# Measurement: Only keep name which are still in DataFileMetaData ---------

  selName <- x$DataFileMetaData %>%
    dplyr::filter(.data$columnData == "Measurement") %>%
    dplyr::select(mappingColumn) %>%
    as.character
  x$Measurement %<>%
    dplyr::filter(.data$name == selName)

# Set property name -------------------------------------------------------

  attr(x, "name") <- paste(dataFile, name_x, sep = "_")

# Return ------------------------------------------------------------------

  return(x)
}
