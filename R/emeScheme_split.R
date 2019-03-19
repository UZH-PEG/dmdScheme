#' Split \code{emeScheme} object into multiple by using \code{DataFileNameMetaData$dataFileName}
#'
#' One \code{emeScheme} object can contain metadata for multiple datafiles. For
#' archiving, these should be split into single \code{emeScheme} objects, one
#' for each \code{DataFileNameMetaData$dataFileName}.
#' \bold{ATTENTION: Files are overwritten without warning!!!!!}
#' @param x \code{emeScheme} object to be split
#' @param saveAsType if given, save the result to files named following the
#'   pattern \code{DATAFILENAME_attr(x, "propertyName").saveAsType}. If missing,
#'   do not save and return the result. Allowed values at the moment:
#'   \itemize{
#'    \item{none} {do not save the resulting list}
#'    \item{rds} {save results in files using \code{saveRDS()}}
#'    \item{xml} {save results in xml files using \code{emeSchemeToXml()}}
#'    \item{multiple values of the above} {will be saved in all specified formats}
#'   }
#' @param path path where the files should be saved to
#'
#' @return if \code{saveAsType} valid and not equal to \code{none}, \code{character} vector
#'   containing the file names where the splitted metadata has been saved to, if
#'   \code{saveAsType} missing, \code{list} where each element is one
#'   \code{emeScheme} object for a data file as specified in
#'   \code{DataFileNameMetaData$dataFileName}.
#'
#' @importFrom magrittr %>% %<>%
#' @export
#'
#' @examples
#' emeScheme_split(emeScheme_example)
#' ## x is a list containing all the emeSchemes for each data file
#'
#' emeScheme_split(emeScheme_example, saveAsType = "rds", path = tempdir())
#' ## saves the resulting object as rds using saveRDS() into the tmpdir()
#'
#' emeScheme_split(emeScheme_example, saveAsType = "xml", path = tempdir())
#' ## saves the resulting object as xml into the tmpdir()
#'
#' emeScheme_split(emeScheme_example, saveAsType = c("rds", "xml"), path = tempdir())
#' ## saves the resulting object as rds and xml into the tmpdir()

emeScheme_split <- function(
  x,
  saveAsType = "none",
  path = "."
) {

# Check arguments ---------------------------------------------------------

  if (!is(x, "emeScheme")) {
    stop("x has to be an object of type emeScheme")
  }

  saveAsTypeAllowed <- c("rds", "xml", "none")
  if (!all(saveAsType %in% saveAsTypeAllowed)) {
    stop("'saveAsType' has to be one of the following values: ", paste(saveAsTypeAllowed, collapse = ", "))
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
fns <- NULL
if (!missing(saveAsType)) {
  if ("rds" %in% saveAsType) {
    lapply(
      result,
      function(x) {
        fn <- file.path( path, paste(attr(x, "propertyName"), "rds", sep = ".") )
        saveRDS(x, fn)
        fns <<- c(fns, fn)
      }
    )
  }
  if ("xml" %in% saveAsType) {
    lapply(
      result,
      function(x) {
        fn <- file.path( path, paste(attr(x, "propertyName"), "xml", sep = ".") )
        emeSchemeToXml(x, tag = paste(attr(x, "propertyName")), file = fn, confirmationCode = "secret code for testing")
        fns <<- c(fns, fn)
      }
    )
  }
}

# Return ------------------------------------------------------------------

  if (all(saveAsType %in% saveAsTypeAllowed)) {
    result <- fns
  }
  return(result)
}


