#' Validate structure of object of class \code{emeSchemeSet_raw} against \code{emeScheme}.
#'
#' @param x object of class \code{emeSchemeSet_raw} as returned from \code{read_from_excel( keepData = FALSE, raw = TRUE)}
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
#' validate_raw( emeScheme_raw )
#'
validate_raw <- function(
  x,
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
      result$correctType <- FALSE
      result$inDataFile <- FALSE
      result$largerMin <- FALSE
      result$smallerMax <- FALSE
      result$inAllowedValues <- FALSE
    }
  )
  return(result)
}


# HELPER: Validate DataFileMetaData ---------------------------------------

validateDataFileMetaData <- function( x ){
  dfns <- unique(x$dataFileName)
  names(dfns) <- dfns
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
  result$structOK <- isTRUE(all.equal(struct, emeScheme))
  if (!result$structOK & errorIfFalse){
    cat_ln(result)
    stop("x would result in a scheme which is not identical to the emeScheme!")
  }

# Validata data -----------------------------------------------------------


  if (result$structOK){
    dat <- new_emeSchemeSet( x, keepData = TRUE, verbose = FALSE)

  # Validate Species --------------------------------------------------------

    result$Species <- validateSpecies(dat$Species)

  # Validate DataFileMetaData -----------------------------------------------

    result$DataFileMetaData <- validateDataFileMetaData(dat$DataFileMetaData)


  }

# Return result -----------------------------------------------------------

  return(result)
}


