#' Convert the data stored in \code{emeScheme} into a list of tibbles
#'
#' TODO: Add attriburtes for repeatability and check if tibble is appropriate (hopefully!!!!)
#'
#' @param x the \code{emeScheme} as a \code{tibble) (as from google docs). The default is usually fine.
#'
#' @return \code{list} of \code{list} of ... \code{tibbles}
#' @export
#' @importFrom tibble is.tibble as_tibble
#'
#' @examples
#' gdToScheme()
#'
gdToScheme <- function(x = emeScheme) {

# Calculate max ncol in list recursively ----------------------------------

  maxncol <- function(x) {
    if (is(x, "list")) {
      sapply(
        x,
        maxncol
      ) %>% max()
    } else {
      ncol(x)
    }
  }

# Recursive function to do the splitting ----------------------------------

  splitProperty <- function(x) {
    if (is(x, "list")) {
      sl <- lapply(x, splitProperty)
    } else if (ncol(x) <= 1) {
      sl <- x
    } else {
      prop <- x[[1]]
      isHeader <- !is.na(prop)
      header <- c(which(isHeader), length(prop)+1)
      sl <- list()
      for (i in 1:(length(header)-1)) {
        propName <- strsplit(x = prop[header[i]], split = " ")[[1]][[1]]
        sl[[propName]] <- x[(header[i]+1):(header[i+1]-1),-1]
        colAllNA <- sapply(
          sl[[propName]],
          function(x) {
            all(is.na(x))
          }
        )
        remove <- !colAllNA
        sl[[propName]] <- sl[[propName]][,remove]
      }
    }
    return(sl)
  }


# Transpose function ------------------------------------------------------

  tIter <- function(x) {
    if (is(x, "list")) {
      result <- lapply(
        x,
        tIter
      )
    } else {
      if (tibble::is.tibble(x)) {
        result <- tibble::as_tibble(t(x))
        names(result) <- as.character(result)
      }
    }
    return(result)
  }

# Do the splitting --------------------------------------------------------

  result <- splitProperty(x)
  while (maxncol(result) > 1) {
    result <- splitProperty(result)
  }

# Transpose indicidual tibbles --------------------------------------------

  result <- tIter(result)

# Return ------------------------------------------------------------------

  return(result)
}

