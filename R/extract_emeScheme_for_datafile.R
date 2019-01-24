#' Filter meatdata based on x$DataFile$dataFileName
#'
#' Extract, based on the \code{emeSchemeSet} DataFile and the names specified there, the data not for the data file will be filtered out.
#' @param x object of class \code{emeSchemeSet}
#' @param file \code{dataFileName} to be filtered
#'
#' @return object of class \code{emeSchemeSet} with only metadata relevant to the data file as specified in \code{file}.
#'
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr filter select
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' extract_emeScheme_for_datafile(emeScheme_example, file = "data1.csv")
#'
extract_emeScheme_for_datafile <- function(
  x,
  file
) {

result <- NULL

# Check if x is of class emeSchemsSet -------------------------------------

if (!inherits(x, "emeSchemeSet")) {
  stop("x has to be of class 'emeSchemeSet'")
}

# Check if file is in DataFile$dataFileName -------------------------------

if (! file %in% x[["DataFile"]][["dataFileName"]]) {
  stop("'file' has to be file name from the ones specified in x$DataFile$dataFileName")
}

# Extract treatmentName, measurementName and dataExtractionName -----------

md_names <- x$DataFile %>%
  filter_emeScheme(.data$dataFileName == file) %>%
  sapply(
    strsplit,
    split = ","
  )

x$Treatment %<>%
  filter_emeScheme( .data$name %in% md_names$treatmentName )

x$Measurement %<>%
  filter_emeScheme( .data$name %in% md_names$measurementName )

x$DataExtraction %<>%
  filter_emeScheme( .data$name %in% md_names$dataExtractionName )

x$DataFile %<>%
  filter_emeScheme( .data$dataFileName %in% file)

species <- x$Treatment %>%
  filter_emeScheme( .data$parameter == "species" ) %>%
  select_emeScheme( .data$treatmentLevel ) %>%
  unlist()

x$Species %<>%
  filter_emeScheme( .data$name %in% species )

# Set Attributes ----------------------------------------------------------

attr(x, "dataFileName") <-  file

# Return result -----------------------------------------------------------

return(x)
}
