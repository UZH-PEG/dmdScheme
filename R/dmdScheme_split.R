#' Split \code{dmdScheme} object into multiple by using \code{DataFileNameMetaData$dataFileName}
#'
#' One \code{dmdScheme} object can contain metadata for multiple datafiles. For
#' archiving, these should be split into single \code{dmdScheme} objects, one
#' for each \code{DataFileNameMetaData$dataFileName}.
#' \bold{ATTENTION: Files are overwritten without warning!!!!!}
#' @param x \code{dmdScheme} object to be split
#' @param saveAsType if given, save the result to files named following the
#'   pattern \code{DATAFILENAME_attr(x, "propertyName").saveAsType}. If missing,
#'   do not save and return the result. Allowed values at the moment:
#'   \itemize{
#'    \item{none} {do not save the resulting list}
#'    \item{rds} {save results in files using \code{saveRDS()}}
#'    \item{xml} {save results in xml files using \code{dmdSchemeToXml()}}
#'    \item{multiple values of the above} {will be saved in all specified formats}
#'   }
#' @param path path where the files should be saved to
#'
#' @return if \code{saveAsType} valid and not equal to \code{none}, \code{character} vector
#'   containing the file names where the splitted metadata has been saved to, if
#'   \code{saveAsType} missing, \code{list} where each element is one
#'   \code{dmdScheme} object for a data file as specified in
#'   \code{DataFileNameMetaData$dataFileName}.
#'
#' @importFrom magrittr %>% %<>%
#' @export
#'
#' @examples
#' dmdScheme_split(dmdScheme_example)
#' ## x is a list containing all the dmdSchemes for each data file
#'
#' dmdScheme_split(dmdScheme_example, saveAsType = "rds", path = tempdir())
#' ## saves the resulting object as rds using saveRDS() into the tmpdir()
#'
#' dmdScheme_split(dmdScheme_example, saveAsType = "xml", path = tempdir())
#' ## saves the resulting object as xml into the tmpdir()
#'
#' dmdScheme_split(dmdScheme_example, saveAsType = c("rds", "xml"), path = tempdir())
#' ## saves the resulting object as rds and xml into the tmpdir()

dmdScheme_split <- function(
  x,
  saveAsType = "none",
  path = "."
) {

# Check arguments ---------------------------------------------------------

  if (!is(x, "dmdScheme")) {
    stop("x has to be an object of type dmdScheme")
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
    dmdScheme_extract,
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
        dmdSchemeToXml(x, tag = paste(attr(x, "propertyName")), file = fn, confirmationCode = "secret code for testing")
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


