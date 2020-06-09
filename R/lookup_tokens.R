#' Replace tokens with vlues from a dmdScheme
#'
#' For a detailed explanation of these tokens see the vignette \code{Create and
#' Customize the index Template}.
#' @param tokens a character vector containing tokens. These can be enclosed in \code{\%\%TOKEN\%\%} or not.
#' @param scheme a \code{dmdSchemeSet} object
#' @param author the author of the index document
#'
#' @return a list of the length of the input vector \code{tokens}
#'   containing the objects returned by the tokens. Null if the tokens contains
#'   invalid values.
#'
#' @importFrom utils str
#' @export
#'
#' @examples
#' lookup_tokens(
#'   tokens = c(
#'       "%%Treatments.*.2%%",
#'      "%%Experiment.*.*%%",
#'      "Measurement.method.3"
#'    ),
#'   scheme = dmdScheme_example(),
#' )
lookup_tokens <- function(
  tokens,
  scheme,
  author = ""
) {

  # HELPER: error_token -----------------------------------------------------

  error_token <- function(token, msg = "error") {
    paste0(
      "%%",
      paste( token, collapse = "."),
      "%%",
      msg,
      "%%"
    )
  }

  # Do the lookup -----------------------------------------------------------


  if (!inherits(scheme, "dmdSchemeSet")) {
    stop("scheme must be a decendant from `dmdSchemeSet`!")
  }


  result <- lapply(
    strsplit(
      gsub("%%", "", tokens),
      split = "\\."
    ),
    function(token) {

      # Special Tokens ----------------------------------------------------------

      if (token[[1]] == "DATE") {
        return( format(Sys.Date(), "%Y%-%m-%d") )
      }
      if (token[[1]] == "AUTHOR") {
        return( author )
      }

      cmd <- regmatches(token[[1]], gregexpr( "!(.*?)!", token[[1]], perl = TRUE ))[[1]]
      if (length(cmd) == 1) {
        token[[1]] <- gsub(cmd, "", token[[1]])
        cmd <- gsub("!", "", cmd)
      } else {
        cmd <- NULL
      }

      # Metadata Tokens ---------------------------------------------------------

      if (token[[1]] == "*") {
        return(error_token(token))
      }

      # Fill with * -------------------------------------------------------------

      while (length(token) < 3) {
        token <- c(token, "*")
      }

      # propertySet -------------------------------------------------------------
      # token = c(propertySet, *, *)

      if (!(token[[1]] %in% names(scheme))) {
        return(error_token(token, "error_propertySet"))
      }

      result <- scheme[[token[[1]]]]

      if (token[[2]] == "*" & token[[3]] == "*") {
        ## propertySet
        result <- as.data.frame(result)
        if (!is.null(cmd)) {
          result <- eval(parse(text = paste0(cmd, "(result)")))
        }
        return(result)
      }

      # propertyValue column or cell --------------------------------------------
      # token = c(propertySet, propertyValue, [n, *])

      if (token[[2]] != "*") {
        if (!(token[[2]] %in% names(result))) {
          return(error_token(token, "error_valueProperty"))
        }
        result <- result[[token[[2]]]]
        if (token[[3]] == "*") {
          if (!is.null(cmd)) {
            result <- eval(parse(text = paste0(cmd, "(result)")))
          }
          return(result)
        } else {
          ind <- suppressWarnings( as.integer(token[[3]]) )
          if (isTRUE( as.character(ind) == token[[3]] )) {
            if (ind >= length(result)) {
              return(error_token(token, "indexToLarge"))
            }
            result <- result[[ind]]
            result <- as.character(result)
            if (!is.null(cmd)) {
              result <- eval(parse(text = paste0(cmd, "(result)")))
            }
            return(result)
          } else {
            return(error_token(token, "error_index"))
          }
        }
      }

      # row ---------------------------------------------------------------------
      # token = c(propertySet, *, n)

      if (token[[3]] != "*") {
        ind <- suppressWarnings( as.integer(token[[3]]) )
        if (isTRUE( as.character(ind) == token[[3]] )) {
          result <- result[ind,]
          result <- as.data.frame(result)
        } else {
          return(paste(token, "error_index", sep = "%%"))
        }
        if (!is.null(cmd)) {
          result <- eval(parse(text = paste0(cmd, "(result)")))
        }
        return(result)
      }

      # Just to be safe ---------------------------------------------------------

      stop("There is really something wrong - the function should never get here!\n",
           "Please report this with the following value:\n",
           "token = ", str(token)
           )

    }
  )

  names(result) <- tokens

  return(result)
}
