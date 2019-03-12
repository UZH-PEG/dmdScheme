#' Split \code{emeScheme} object into multiple by using \code{DataFileNameMetaData$dataFileName}
#'
#' One \code{emeScheme} object can contain metadata for multiple datafiles. For
#' archiving, these should be split into single \code{emeScheme} objects, one
#' for each \code{DataFileNameMetaData$dataFileName}.
#' @param x \code{emeScheme} object to be split
#' @param saveAsType if given, save the result to files named following the
#'   pattern \code{DATAFILENAME_attr(x, "propertyName").saveAsType}. If missing,
#'   do not save and return the result. Allowed values at the moment:
#'   \itemize{
#'   \item{none} {do not save the resulting list}
#'   \item{rds} {save results in files using \code{saveRDS()}}
#'   \item{xml} {save results in xml files using \code{emeSchemeToXml()}}
#'   \item{multiple values of the above} {will be saved in all specified formats}
#'   }
#'
#' @return if \code{saveAsType} specified, \character{character} vector
#'   containing the file names where the splitted metadata has been saved to, if
#'   \code{saveAsType} missing, \code{list} where each element is one
#'   \code{emeScheme} object for a data file as specified in
#'   \code{DataFileNameMetaData$dataFileName}.
#'
#' @importFrom magrittr %>% %<>%
#' @export
#'
#' @examples
emeScheme_split <- function(
  x,
  saveAsType = "none"
) {

# Check arguments ---------------------------------------------------------

  if (!is(x, "emeScheme")) {
    stop("x has to be an object of type emeScheme")
  }

  saveAsTypeAllowed <- c("rds", "xml", "none")
  if (!all(saveAsType %in% saveAsTypeAllowed)) {
    stop("'saveAsType' has to be one of the following values: ", saveAsTypeAllowed)
  }

# Extract DataFileMetaData$dataFileNames ----------------------------------

  dataFileName <- unique(x$DataFileMetaData$dataFileName)
  names(dataFileName) <- dataFileName

# Extract for each unique dataFileName ------------------------------------

  result <- lapply(
    dataFileName,
    emeScheme_extract,
    x = x
  )

# Save if asked for -------------------------------------------------------

if (!missing(saveAsType)) {
  if ("rds" %in% saveAsType) {
    lapply(
      result,
      function(x) {
        fn <- paste(attr(x, "name"), saveAsType, sep = ".")
        saveRDS(x, fn)
      }
    )
  }
  if ("xml" %in% saveAsType) {
    lapply(
      result,
      function(x) {
        fn <- paste(attr(x, "name"), saveAsType, sep = ".")
        saveRDS(x, fn)
      }
    )
  }
}

# Return ------------------------------------------------------------------

return(result)

}
