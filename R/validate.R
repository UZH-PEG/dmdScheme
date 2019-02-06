#' Validate structure of object of class \code{emeSchemeSet_raw} against \code{emeScheme}.
#'
#' @param x object of class \code{emeSchemeSet_raw} as returned from \code{read_from_excel( keepData = FALSE, raw = TRUE)}
#' @param path path to the data files
#' @param validateData if \code{TRUE} data is validated as well; the structure is always validated
#' @param errorIfFalse if \code{TRUE} an error will be raised if the schemes are not identical, i.e. there are structural differences.
#'
#' @return \code{TRUE} if they are identical or character vector describing the differences
#'
#' @importFrom taxize gnr_resolve
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr filter
#' @export
#'
#' @examples
#' validate( emeScheme_raw )
#'
validate <- function(
  x,
  path = "",
  validateData = TRUE,
  errorIfFalse = TRUE
  ) {

# HELPER: Validate Species ------------------------------------------------

validateSpecies <- function( x ){
  result <- list()

  # Validate species names --------------------------------------------------
  result$speciesNames <- taxize::gnr_resolve(x$name, best_match_only = TRUE)
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
  dfns <- unique(x$dataFileName)
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
          x %>% dplyr::filter(.data$dataFileName == dfn)
        )

      }
      return(result)
    }
  )
  return(result)
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

  # Validate Species --------------------------------------------------------

    result$Species <- validateSpecies(dat$Species)

  # Validate DataFileMetaData -----------------------------------------------

    result$DataFileMetaData <- validateDataFileMetaData(dat$DataFileMetaData)


  }

# Return result -----------------------------------------------------------

  return(result)
}


