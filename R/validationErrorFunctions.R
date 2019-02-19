

# error levels ------------------------------------------------------------

valErr_errorLevels <- data.frame(
  level = c( 0,    1,      2,         3     ),
  text  = c("OK", "note", "warning", "error"),
  colour = colorRampPalette(colors = c("green", "red"))(4),
  stringsAsFactors = FALSE
)

# get error info ----------------------------------------------------------


#' Return info about error representation
#'
#' @param error either level, text or colour of error (see \code{valErr_errorLevels})
#'
#' @return the row from valErr_errorLevels corresponding to the argument \code{error}
#'
#' @export
#'
valErr_info <- function(error) {
  level <- which(valErr_errorLevels$text == error)
  if (length(level) == 0) {
    level <- which(valErr_errorLevels$colour == error)
    if (length(level) == 0) {
      level <- which(valErr_errorLevels$level == error)
    }
  }
  if (length(level) == 0) {
    stop(error, " not a valid error identifier. See the variable 'valErr_errorLevels' for allowed values.")
  }
  return( valErr_errorLevels[level,] )
}


#' Colour the \code{text} by using the error colour
#'
#' @param text to be coloured. if not supplied, the coloured error text will be returned
#' @param error either level, text or colour of error (see \code{valErr_errorLevels})
#' @param addError if the error text should be added in the front of the \code{text}.
#'
#' @return the coloured text or error text
#'
#' @export
#'
valErr_TextErrCol <- function(text, error, addError = TRUE) {
  if (missing(text)) {
    text <- valErr_info(error)$text
  } else if (addError) {
    text <- paste(
      valErr_info(error)$text,
      ":",
      text
    )
  }
  #
  result <- paste0(
    '**<span style="color:',
    valErr_info(error)$colour, '
    ">',
    text,
    '</span>**'
  )
  return( result )
}


#' Extract all fields named object of class \code{emeScheme_validation}
#'
#' @param x object of class \code{emeScheme_validation}
#'
#' @return named numeric vector of the error levels of the different validations done
#' @export
#'
valErr_extract <- function(x) {
  if (!inherits(x, "emeScheme_validation")) {
    stop(" x has to be an object of type 'emeScheme_validation'.")
  }
  err <- unlist(x)
  # select all whose name ends with "error", i.e. all fields which contain the error of the validations
  err <- err[ grep("error$", names(err)) ]
  nms <- names(err)
  err <-  as.numeric(err)
  names(err) <- nms
  return(err)
}
