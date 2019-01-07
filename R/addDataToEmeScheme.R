#' Title
#'
#' @param x path to data file or object containing the data to be filled in. Has to be a
#'   \code{data.frame} or \code{tibble}. The columns have to be the property
#'   levels, starting with \code{Property}, and the data column(s). See
#'   \code{emeScheme_gd} as an example.
#'   Suppoerted data file formate:
#'  \itemize{
#'    \item{\code{xlsx} : }{xlsx file in the same format as the file which is loded when excuting \code{enter_new_metadata()} command. It is the best to use this sheet when entering data.}
#'    \item{others : }{others will be added later}
#'  }
#' @param s the \code{emeScheme} object to which the data should be added. If
#'   the data exists, it will be overwritten, \code{NA} and \code{NULL} values
#'   will be treated as not given.
#' @param dataCol data column indicator. Can be an index of data column (1 =
#'   first data column, 2 = second, ...), or the name of the data column.
#'   Default = 1.
#' @param dataSheet if x is an xlsx file, \code{dataSheet} specifies the sheet which
#'   shoiuld be imported. This can be the sheet name or the index. Default is 1.
#' @param verbose if \code{TRUE}, progress and diagnostig messages will be
#'   printed.
#'
#' @return the emeScheme \code{s} filled in with the values as specified in \code{x}
#' @importFrom magrittr %>% %<>% set_names
#' @importFrom tibble as_tibble
#' @importFrom readxl read_excel
#' @importFrom dplyr mutate_all vars
#' @importFrom tools file_ext
#' @export
#'
#' @examples
#' addDataToEmeScheme( verbose = TRUE )
addDataToEmeScheme <- function(
  x = emeScheme_gd,
  s = emeScheme,
  dataSheet = 1,
  dataCol = 1,
  verbose = FALSE
) {

# HELPER: noColEmeSchemeProp ----------------------------------------------

  ncolEmeSchemeProp <- function(prop, s = emeScheme) {
    if (length(prop) > 6) {
      stop("Property level not supported!")
    }
    result <- switch(
      length(prop),
      ncol( s[[prop[1]]] ),
      ncol( s[[prop[1]]][[prop[2]]] ),
      ncol( s[[prop[1]]][[prop[2]]][[prop[3]]] ),
      ncol( s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]] ),
      ncol( s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]] ),
      ncol( s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][[prop[6]]] )
    )
    if (is.null(result)) {stop("Invalid Property name or the Property is a list and not a tibble!")}
    return(result)
  }

# HELPER: namesEmeSchemeProp ----------------------------------------------

  namesEmeSchemeProp <- function(prop, s = emeScheme) {
    if (length(prop) > 6) {
      stop("Property level not supported!")
    }
    result <- switch(
      length(prop),
      names( s[[prop[1]]] ),
      names( s[[prop[1]]][[prop[2]]] ),
      names( s[[prop[1]]][[prop[2]]][[prop[3]]] ),
      names( s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]] ),
      names( s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]] ),
      names( s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][[prop[6]]] )
    )
    if (is.null(result)) {stop("Invalid Property name or the Property has no names!")}
    return(result)
  }

# HELPER: setEmeSchemeProp ----------------------------------------------

  setEmeSchemeProp <- function(prop, s, data) {
    oldWarn <- options(warn = 2)
    on.exit(options(warn = oldWarn$warn))
    ##
    if (length(prop) > 6) {
      stop("Property level not supported!")
    }
    switch(
      length(prop),
      {
        tp <- sapply(s[[prop[1]]], class)
        for (i in names(tp)) {
          data %>%
            dplyr::mutate_at(
              dplyr::vars(i),
              as,
              Class = tp[i]
            )
        }
        s[[prop[1]]][1:nrow(data),] <- NA
        s[[prop[1]]][] <- data[]
      },
      {
        tp <- sapply(s[[prop[1]]][[prop[2]]], class)
        for (i in names(tp)) {
          data %<>%
            dplyr::mutate_at(
              dplyr::vars(i),
              as,
              Class = tp[i]
            )
        }
        s[[prop[1]]][[prop[2]]][1:nrow(data),] <- NA
        s[[prop[1]]][[prop[2]]][] <- data[]
      },
      {
        tp <- sapply(s[[prop[1]]][[prop[2]]][[prop[3]]], class)
        for (i in names(tp)) {
          data %>%
            dplyr::mutate_at(
              dplyr::vars(i),
              as,
              Class = tp[i]
            )
        }
        s[[prop[1]]][[prop[2]]][[prop[3]]][1:nrow(data),] <- NA
        s[[prop[1]]][[prop[2]]][[prop[3]]][] <- data[]
      },
      {
        tp <- sapply(s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]], class)
        for (i in names(tp)) {
          data %>%
            dplyr::mutate_at(
              dplyr::vars(i),
              as,
              Class = tp[i]
            )
        }
        s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][1:nrow(data),] <- NA
        s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][] <- data[]
      },
      {
        tp <- sapply(s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]], class)
        for (i in names(tp)) {
          data %>%
            dplyr::mutate_at(
              dplyr::vars(i),
              as,
              Class = tp[i]
            )
        }
        s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][1:nrow(data),] <- NA
        s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][] <- data[]
      },
      {
        tp <- sapply(s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][[prop[6]]], class)
        for (i in names(tp)) {
          data %>%
            dplyr::mutate_at(
              dplyr::vars(i),
              as,
              Class = tp[i]
            )
        }
        s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][[prop[6]]][1:nrow(data),] <- NA
        s[[prop[1]]][[prop[2]]][[prop[3]]][[prop[4]]][[prop[5]]][[prop[6]]][] <- data[]
      }
    )
    return(s)
  }



# If x is character(), load from file -------------------------------------

if (is.character(x)) {
  if (!file.exists(x)) {
    stop("If x is a string, it needs to be the name of an existing file!")
  }
  switch(
    tools::file_ext(x),
    xlsx = {
      x <- readxl::read_excel(path = x, sheet = dataSheet)
      ##
      notNARow <- x %>%
        is.na() %>%
        rowSums() %>%
        equals(ncol(x)) %>%
        not()
      notNACol <- x %>%
        is.na() %>%
        colSums() %>%
        equals(nrow(x)) %>%
        not()
      x <- x[notNARow, notNACol]
      ##
    },
    stop("If x is a file name, it has to have the extension '.xlsx'")
  )

}


# Determine data and property columns in x and delete all other columns --------------------------------

  cols <- 1:ncol(x)
  propCols <- cols[ startsWith( x = names(x), prefix = "Property") ]
  dataCols <- cols[ !startsWith( x = names(x), prefix = "Property") ]
  ##
  if (is.numeric(dataCol)) {
    dataCols <- dataCols[[dataCol]]
  } else if (is.character(dataCol)) {
    dataCols <- which(names(x) == dataCol)
  } else {
    stop("dataCol has to be either a numeric or a character value!")
  }
  ##
  x <- x[, c(propCols, dataCols)]

# Fill Properety... columns in x ------------------------------------------

  for (j in propCols) {
    fillValue <- NA
    for (i in 1:nrow(x)) {
      if ( !is.na(x[i,j]) ) {
        if (1 %in% unlist(gregexpr("[A-Z]", x[i, j])))  {
          fillValue <- x[i, j]
        } else {
          x[i, j] %<>%
            as.character() %>%
            strsplit(" ") %>%
            sapply("[", 1)
          fillValue <- NULL
        }
      } else if (!is.null(fillValue)) {
        x[i, j] <- fillValue
      } else {
        ## nothing
      }
    }
  }
  rm(i, j)

# Copy values into emeScheme ----------------------------------------------

  i <- 1
  while (i <= nrow(x)){
    row <- x[i, ]
    if (verbose) {cat(i, "\n")}
    ## check if data column contains a valua and not NA or NULL
    if ( !is.na(row[[ncol(row)]]) & !is.null(row[[ncol(row)]]) ){

      ## identify all columns with only NA
      naCols <- is.na(row)[1,]
      ## set data column to FALSE as it should always be kept
      naCols[length(naCols)] <- FALSE
      ## delete all NA property levels (should be the ones at the end), if any
      row <- row[,!naCols]
      if (verbose) {
        cat("\n Working on identified row:\n")
        print(row)
      }

      ## extract vector with Properties
      prop <- as.character( row[1, c(-ncol(row), -(ncol(row)-1))] )
      if (verbose) {
        cat("\n Properties:\n")
        print(prop)
      }

      ## determine number of columns in emeScheme tibble and store source data in 'rows'
      nc <- ncolEmeSchemeProp( prop = prop, s = s )
      nextI <- i + nc
      rows <- x[i:(nextI-1), !naCols]
      if (verbose) {
        cat("\n Input Columns:\n")
        print(rows)
      }

      ## extract data and convert to tibble in correct format
      data <- rows[,ncol(rows)] %>%
        t() %>%
        cbind() %>%
        tibble::as_tibble() %>%
        magrittr::set_names( namesEmeSchemeProp( prop = prop, s = s ) )

      ## split the data using commas
      data <- strsplit(as.character(data[1,]), ",") %>%
        tibble::as_tibble( validate = FALSE) %>%
        magrittr::set_names( namesEmeSchemeProp( prop = prop, s = s ) )


      ## trim whitespace around data
      for (i in 1:ncol(data)) {
        data[[i]] <- trimws(data[[i]])
      }

      ## expand row tibble to match number of values and fill data in
      s <- setEmeSchemeProp(
        prop = prop,
        s = s,
        data = data
      )

      if (verbose) {cat("\n\n")}

      ## set i to next i
      i <- nextI
    } else {
      ## increase i by 1
      i <- i + 1
    }
  }
  rm(i)

# Return s ----------------------------------------------------------------

return(s)

}
