#' Convert the data stored in \code{emeScheme_gd} into a list of tibbles
#'
#' TODO: Add attriburtes for repeatability and check if tibble is appropriate (hopefully!!!!)
#'
#' @param x the \code{emeScheme_gd} as a \code{tibble} (as from google docs). The default is usually fine.
#' @param debug should debug and progress mesaages be printed. Default is \code{FALSE}
#'
#' @return \code{list} of \code{list} of ... \code{tibbles}
#' @export
#' @importFrom tibble is.tibble as_tibble
#' @importFrom methods is as
#' @importFrom magrittr set_names %<>%
#'
#' @examples
#' gdToScheme()
#'
gdToScheme <- function(
  x = emeScheme_gd,
  debug = FALSE) {

# HELPER maxncol(): Calculate max ncol in list recursively ----------------------------------

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

# HELPER splitProperty(): Recursive function to do the splitting ----------------------------------

  splitProperty <- function(x) {
    if (is(x, "list")) {
      sl <- lapply(x, splitProperty)
      class(sl) <- append(
        c(
          "emeSchemeSet",
          "emeScheme"
        ),
        class(sl),
      )
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
        class(sl[[propName]]) <- append(
          c(
            "emeSchemeData",
            "emeScheme"
          ),
          class(sl[[propName]]),
        )
      }
      class(sl) <- append(
        c(
          # paste0("emeSchemeSet_",names(x)[[1]]),
          "emeSchemeSet",
          "emeScheme"
        ),
        class(sl),
      )

    }
    return(sl)
  }

# HELPER tIter(): Transpose function and set attributes and names -------------------------

  tIter <- function(x) {
    if (is(x, "list")) {
      oldClass <- class(x)
      result <- lapply(
        x,
        tIter
      )
      class(result) <- oldClass
    } else {
      if (tibble::is.tibble(x)) {
        result <- tibble::as_tibble(t(x))
        names(result) <- result %>%
          as.character() %>%
          strsplit(" ") %>%
          sapply("[", 1)
        class(result) <- class(x)
        ##
        unit <- result %>%
          as.character() %>%
          strsplit(" ") %>%
          sapply("[", 2) %>%
          gsub("\\(|\\)", "", .) %>%
          set_names(names(result))
        attr(result, which = "unit") <- unit
        ##
        type <- result %>%
          as.character() %>%
          strsplit(" ") %>%
          sapply("[", 3) %>%
          gsub("\\[|\\]", "", .) %>%
          set_names(names(result))
        attr(result, which = "type") <- type
        if (debug) {cat(length(type), class(result))}
        type[is.na(type)] <- "character"
        if (debug) {cat(".")}
        result[] <- NA
        if (debug) {cat(".")}
        for (i in 1:ncol(result)) {
          result[,i] <- as(result[,i], Class = type[i])
        }
        if (debug) {cat(".\n")}
        ##
      }
    }
    return(result)
  }

# HELPER attrPropertyName(): set attribute propertyName -------------------------

  attrPropertyName <- function(x) {
    if (is(x, "emeSchemeSet")) {
      for (nm in names(x)) {
        attr(x[[nm]], "propertyName") <- nm
        x[[nm]] <- attrPropertyName(x[[nm]])
        class(x[[nm]]) <- append(
          paste(class(x[[nm]])[[1]], nm, sep = "_"),
          class(x[[nm]]),
        )
      }
    } else {
      # it is a tibble and has been assigned already a propertyName attribute
    }
    return(x)
  }

# Select only Property ----------------------------------------------------

  x %<>%
    select(starts_with("Property"))

# Do the splitting --------------------------------------------------------

  result <- splitProperty(x)
  while (maxncol(result) > 1) {
    result <- splitProperty(result)
  }

# Transpose indicidual tibbles --------------------------------------------

  result <- tIter(result)


# Assign propertyName attributes ------------------------------------------

  result <- attrPropertyName(result)

# Return ------------------------------------------------------------------

  return(result)
}

