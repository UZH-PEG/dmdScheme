#' @export
#'
#' @importFrom magrittr %>% %<>%
#' @importFrom dplyr filter select
#' @importFrom utils browseURL glob2rx
#' @importFrom rmarkdown render
#' @importFrom tibble tibble
#' @importFrom utils read.csv
#' @importFrom magrittr extract2
#' @importFrom digest digest
#'
#' @describeIn validate validate a `dmdSchemeSet_raw` object
#'
#' @md
#' @examples
#' ## validate a `dmdScheme_raw object`
#' validate(
#'    x = dmdScheme_raw()
#' )
#'
#' ## use `read_raw()` to read an Excel spreadsheet into a `dmdScheme_raw` object
#' x <- read_excel_raw( scheme_path_xlsx() )
#' validate( x = x )
#'
validate.dmdSchemeSet_raw <- function(
  x,
  path = ".",
  validateData = TRUE,
  errorIfStructFalse = TRUE
) {
  # Helper functions --------------------------------------------------------

  as_dmdScheme_validation <- function() {
    result <- list(
      error = NA,
      details = NA,
      header = "To Be Added",
      description = "To Be Added",
      descriptionDetails = "To Be Added",
      comment = ""
    )
    class(result) <- append( "dmdScheme_validation", class(result) )
    return(result)
  }

  validateTypes <- function(sraw, sconv) {
    result <- as_dmdScheme_validation()
    ##
    result$header <- "conversion of values into specified type lossless possible"
    result$description <- paste(
      "Test if the metadata entered follows the type for the column, i.e. integer, characterd, ....",
      "The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified.",
      "the value NA is allowed in all column types, empty cells should be avoided."
    )
    result$descriptionDetails <- paste(
      "The details are a table of the same dimension as the input (green) area of the meatadata sheet.",
      "The following values are possible:\n",
      "\n",
      "   FALSE: If the cell contains an error, i.e. can not be losslessly converted.\n",
      "   TRUE : If the cell can be losslessly converted and is OK.\n",
      "   NA   : empty cell\n",
      "\n",
      "One or more FALSE values will result in an ERROR."
    )
    ##
    if (nrow(sraw) == 0) {
      sraw <- tibble::add_row(sraw)
      sconv <- tibble::add_row(sconv)
    }
    t <- sraw == sconv
    na <- is.na(t)
    t[na] <- TRUE
    result$details <- as.data.frame(sraw, stringsAsFactors = FALSE)
    result$details[t] <- TRUE
    result$details[!t] <- paste( result$details[!t], "!=", as.data.frame(sconv)[!t])
    result$details[na] <- NA
    result$details <- as_tibble(result$details, .name_repair = "unique")
    ##
    result$error = ifelse(
      all(result$details == TRUE, na.rm = TRUE),
      0,
      3
    )
    ##
    result$header <- valErr_TextErrCol(result)
    ##
    return( result )
  }

  validateSuggestedValues <- function(sraw) {
    if (is.null(attr(sraw, "allowedValues"))) {
      result <- NULL
    } else {
      result <- as_dmdScheme_validation()
      ##
      result$header <- "values in suggestedValues"
      result$description <- paste(
        "Test if the metadata entered is ion the suggestedValues list.",
        "The value NA is allowed in all column types, empty cells should be avoided."
      )
      result$descriptionDetails <- paste(
        "The details are a table of the same dimension as the input (green) area of the meatadata sheet.",
        "The following values are possible:\n",
        "\n",
        "   FALSE: If the cell value is not contained in the suggestedValues list.\n",
        "   TRUE : If the cell value is contained in the suggestedValues list.\n",
        "   NA   : empty cell\n",
        "\n",
        "One or more FALSE values will result in a WARNING."
      )
      ##
      result$details <- as_tibble(sraw, .name_repair = "unique")
      sugVal <- strsplit(attr(sraw, "suggestedValues"), ",")
      result$details <- result$details[,!is.na(sugVal)]
      sugVal <- sugVal[!is.na(sugVal)]
      ##
      if (length(sugVal) > 0) {
        for (colN in 1:ncol(result$details)) {
          v <- c( trimws(sugVal[[colN]]), "NA", NA, "" )
          for (rowN in 1:nrow(result$details)) {
            al <- result$details[rowN, colN] %in% v
            # al <- ifelse(
            #   al,
            #   TRUE,
            #   paste0("'", result$details[rowN, colN], "' not in suggested Values!")
            # )
            result$details[rowN, colN] <- al
          }
        }
        ##
        result$error = ifelse(
          all(result$details == TRUE, na.rm = TRUE),
          0,
          1
        )
      } else {
        result$details <- NA
        result$error = 1
      }

      ##
      result$header <- valErr_TextErrCol(result)
    }
    ##
    return( result )
  }

  validateAllowedValues <- function(sraw) {
    if (is.null(attr(sraw, "allowedValues"))) {
      result <- NULL
    } else {
      result <- as_dmdScheme_validation()
      ##
      result$header <- "values in allowedValues"
      result$description <- paste(
        "Test if the metadata entered is ion the allowedValues list.",
        "The value NA is allowed in all column types, empty cells should be avoided."
      )
      result$descriptionDetails <- paste(
        "The details are a table of the same dimension as the input (green) area of the meatadata sheet.",
        "The following values are possible:\n",
        "\n",
        "   FALSE: If the cell value is not contained in the allowedValues list.\n",
        "   TRUE : If the cell value is contained in the allowedValues list.\n",
        "   NA   : empty cell\n",
        "\n",
        "One or more FALSE values will result in an ERROR."
      )
      ##
      result$details <- as_tibble(sraw, .name_repair = "unique")
      allVal <- strsplit(attr(sraw, "allowedValues"), ",")
      result$details <- result$details[,!is.na(allVal)]
      allVal <- allVal[!is.na(allVal)]
      ##
      if (length(allVal) > 0) {
        for (colN in 1:ncol(result$details)) {
          v <- c( trimws(allVal[[colN]]), "NA", NA, "" )
          for (rowN in 1:nrow(result$details)) {
            al <- result$details[rowN, colN] %in% v
            # al <- ifelse(
            #   al,
            #   TRUE,
            #   paste0("'", result$details[rowN, colN], "' not in allowed Values!")
            # )
            result$details[rowN, colN] <- al
          }
        }
        ##
        result$error = ifelse( all(result$details == TRUE,na.rm = TRUE), 0, 3)
      } else {
        result$details <- NA
        result$error = 1
      }
      ##
      result$header <- valErr_TextErrCol(result)
    }
    ##
    return( result )
  }

  validateIDField <- function(sraw){
    result <- as_dmdScheme_validation()
    ##
    result$header <- "ID Field presendt and in the first column"
    result$description <- paste(
      "Check if the tab's first column contains an ID field,",
      "named as `...ID`.",
      "This function does not check for uniqueness of this ID field!"
    )
    result$descriptionDetails <- paste(
      "Returns a boolean value, with the following possible values:\n",
      "\n",
      "   TRUE  : The tab's first column is an ID field\n",
      "   FALSE : The tab's first column is not an ID field\n",
      "\n",
      "FALSE will result in an ERROR."
    )
    ##
    result$details <- data.frame(
      hasIDField = "tab has ID field in first column",
      isOK = 1 %in% grep("ID", names(sraw)),
      stringsAsFactors = FALSE
    )
    ##
    result$error <-  ifelse(
      all(result$details$isOK),
      0,
      3
    )
    ##
    result$header <- valErr_TextErrCol(result)
    ##
    return(result)
  }

  validateStructure <- function(x){
    result <- as_dmdScheme_validation()
    ##
    result$header <- "Structural / Formal validity"
    result$description <- paste(
      "Test if the structure of the metadata is correct. ",
      "This includes column names, required info, ... ",
      "Should normally be OK, if no modification has been done."
    )
    result$descriptionDetails <- ""
    ##
    struct <- as_dmdScheme( x, keepData = FALSE, verbose = FALSE)
    dmdScheme_test <- dmdScheme()
    attr(struct, "fileName") <- "none"
    attr(dmdScheme_test, "fileName") <- "none"
    result$details <- all.equal(struct, dmdScheme_test)
    if (isTRUE(result$details)) {
      result$error <- 0
    } else {
      result$error <- 3
    }
    ##
    result$header <- valErr_TextErrCol(result)
    ##
    return(result)
  }

  validateExperiment <- function( x, xraw, xconv ) {
    result <- as_dmdScheme_validation()
    ##
    result$header <- "Experiment"
    result$description <- paste(
      "Test if the metadata concerning **Experiment** is correct. ",
      "This includes column names, required info, ... "
    )
    result$descriptionDetails <- paste(
      "The details are a table with one row per unique validation.\n",
      "The column `Module` contains the name of the validation,\n",
      "The column `error` contains the actual error of the validation.\n",
      "The following values are possible for the column `isTRUE`:\n",
      "\n",
      "   TRUE : If the validation was `OK`.\n",
      "   FALSE: If the validation was an `error`, `warning` or `note`.\n",
      "   NA   : If at least one v alidation resulted in `NA\n",
      "\n",
      "One or more FALSE or missing values values will result in an ERROR."
    )
    ##
    result$types <- validateTypes(xraw[[1]], xconv[[1]])
    result$suggestedValues <- validateSuggestedValues(xraw[[1]])
    ##
    result$details <- valErr_isOK(result)
    result$error <- max(valErr_extract(result, returnRootError = FALSE), na.rm = FALSE)
    if (is.na(result$error)) {
      result$error <- 3
    }
    result$header <- valErr_TextErrCol(result)
    ##
    return(result)
  }

  validateTab <- function( x, xraw, xconv ) {
    result <- as_dmdScheme_validation()
    ##
    result$header <- names(x)
    result$description <- paste(
      "Test if the metadata concerning **", names(x), "** is correct. ",
      "This includes column names, required info, ... "
    )
    result$descriptionDetails <- paste(
      "The details are a table with one row per unique validation.\n",
      "The column `Module` contains the name of the validation,\n",
      "The column `error` contains the actual error of the validation.\n",
      "The following values are possible for the column `isTRUE`:\n",
      "\n",
      "   TRUE : If the validation was `OK`.\n",
      "   FALSE: If the validation was an `error`, `warning` or `note`.\n",
      "   NA   : If at least one v alidation resulted in `NA\n",
      "\n",
      "One or more FALSE or missing values values will result in an ERROR."
    )
    ##
    result$types <- validateTypes(xraw[[1]], xconv[[1]])
    result$suggestedValues <- validateSuggestedValues(xraw[[1]])
    result$allowedValues <- validateAllowedValues(xraw[[1]])
    result$IDField <- validateIDField(xraw[[1]])
    ##
    result$details <- valErr_isOK(result)
    result$error <- max(valErr_extract(result), na.rm = FALSE)
    if (is.na(result$error)) {
      result$error <- 3
    }
    result$header <- valErr_TextErrCol(result)
    ##
    return(result)
  }

  validateDataFileMetaDataDataFileExists <- function(xraw, path) {
    result <- as_dmdScheme_validation()
    ##
    result$header <- "`dataFile` exists in path"
    result$description <- paste(
      "Test if all `dataFile` exist in the given `path`.",
      "The `error` can have the following values apart from `OK`:\n",
      "\n",
      "   error   : If not all `dataFile` exist in the given `path`\n",
      "\n"
    )
    result$descriptionDetails <- paste(
      "The details are a table with one row per unique `variable`",
      "The following values are possible for the column `isTRUE`:\n",
      "\n",
      "   TRUE : If `dataFile` exist in the given `path`\n",
      "   FALSE: If `dataFile` does not exist in the given `path`\n",
      "   NA   : empty cell\n",
      "\n",
      "One or more FALSE or missing values will result in an ERROR."
    )
    ##
    fns <- unique(xraw[[1]]["dataFileName"])[[1]]
    result$details <- data.frame(
      dataFileName = fns,
      IsOK = fns %>% file.path(path, .) %>% file.exists(),
      stringsAsFactors = FALSE
    )
    ##
    result$error <- ifelse(
      all(result$details$IsOK),
      0,
      3
    )
    if (any(is.na(fns))) {
      result$error <- 3
    }
    ##
    result$header <- valErr_TextErrCol(result)
    ##
    return(result)
  }

  validateDataFileMetaData <- function(x, xraw, xconv, path){
    result <- as_dmdScheme_validation()
    ##
    result$header <- "DataFileMetaData"
    result$description <- paste(
      "Test if the metadata concerning **DataExtraction** is correct. ",
      "This includes column names, required info, ... "
    )
    result$descriptionDetails <- paste(
      "The details are a table with one row per unique validation.\n",
      "The column `Module` contains the name of the validation,\n",
      "The column `error` contains the actual error of the validation.\n",
      "The following values are possible for the column `isTRUE`:\n",
      "\n",
      "   TRUE : If the validation was `OK`.\n",
      "   FALSE: If the validation was an `error`, `warning` or `note`.\n",
      "   NA   : If at least one v alidation resulted in `NA\n",
      "\n",
      "One or more FALSE or missing values values will result in an ERROR."
    )
    ##
    result$types <- validateTypes(xraw[[1]], xconv[[1]])
    result$allowedValues <- validateAllowedValues(xraw[[1]])
    result$dataFilesExist <- validateDataFileMetaDataDataFileExists(xraw, path)
    ##
    result$details <- valErr_isOK(result)
    result$error <- max(valErr_extract(result), na.rm = FALSE)
    if (is.na(result$error)) {
      result$error <- 3
    }
    result$header <- valErr_TextErrCol(result)
    ##
    return(result)
  }


  # Define result structure of class dmdScheme_validation ----------------------

  result <- as_dmdScheme_validation()
  result$description <- paste(
    "The result of the overall validation of the data."
  )
  result$descriptionDetails <- paste(
    "The details contain the different validations of the metadata as a hierarchical list.",
    "errors propagate towards the root, i.e., if the 'worst' is a 'warning' in a validation in `details`",
    "the error here will be a 'warning' as well."
  )

  # Validate structure ------------------------------------------------------

  result$structure <- validateStructure( x )
  if (result$structure$error != 0 & errorIfStructFalse) {
    message(result$structure$details)
    stop("Structure of the object to be evaluated is wrong. See the info above for details.")
  }


  # Validata data -----------------------------------------------------------

  if ((result$structure$error == 0) & validateData) {
    xconv <- suppressWarnings( as_dmdScheme(x, keepData = TRUE, convertTypes = TRUE,  verbose = FALSE, warnToError = FALSE) )
    xraw  <-                   as_dmdScheme(x, keepData = TRUE, convertTypes = FALSE, verbose = FALSE, warnToError = FALSE)

    result$Experiment <- validateExperiment(x["Experiment"], xraw["Experiment"], xconv["Experiment"])

    tabs <- names(x)
    tabs <- grep("Experiment|DataFileMetaData", names(x), invert = TRUE, value = TRUE)
    for (tab in tabs) {
      result[[tab]] <- validateTab(x[tab], xraw[tab], xconv[tab])
    }

    result$DataFileMetaData <- validateDataFileMetaData(x["DataFileMetaData"], xraw["DataFileMetaData"], xconv["DataFileMetaData"], path)
  }

  # Set overall error -------------------------------------------------------

  result$error <- max(valErr_extract(result), na.rm = FALSE)
  if (is.na(result$error)) {
    # result$error <- 3
  }
  result$header <- valErr_TextErrCol("Overall MetaData", result$error)

  # Return result -----------------------------------------------------------

  return(result)
}


