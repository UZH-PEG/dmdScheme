#' Format the metadata scheme file
#'
#' Loads  \code{fn_org)}, formats it and saves it as \code{fn_new}.
#' @param fn_org file name of the original excel file to be formated
#' @param fn_new file name where the final xlsx should be saved to. If missing, it will not be saved.
#' @param keepData if \code{TRUE}, data from data cells will be empty
#' @return invisibly the workbook as a workbook object as created by \code{xlsx.crerateWorkbook()}
#'
#' @importFrom magrittr %>%
#' @importFrom utils packageVersion
#'
#' @export
#'
format_dmdScheme_xlsx <- function(
  fn_org,
  fn_new,
  keepData = TRUE
) {

  if (!file.exists(fn_org)) {
    stop("File `fn_org` does not exist")
  }

  if (!requireNamespace("openxlsx", quietly = TRUE)) {
    warning(
      "Formating skipped as package `openxlsx` is not installed.\n",
      "try to install it via CRAN or, if it is not available there,\n",
      "install it from github https://github.com/ycphs/openxlsx\n",
      "Copying `fn_org` to `fn_new` and \n",
      "returning NULL!"
      )
    file.copy(
      fn_org,
      fn_new
    )
    return(NULL)
  }

  protect_possible <- utils::packageVersion("openxlsx") >= numeric_version("4.1.1")

  # HELPER: set borders thick around range and thin inside ------------------

  setBorders <- function(wb, sheet, rows, cols) {
    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = openxlsx::createStyle(
        border = c("top", "bottom", "left", "right"),
        borderStyle = "thin"
      ),
      rows = rows,
      cols = cols,
      stack = TRUE,
      gridExpand = TRUE
    )

    ## left borders
    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = openxlsx::createStyle(
        border = c("left"),
        borderStyle = c("thick")
      ),
      rows = rows,
      cols = cols[1],
      stack = TRUE,
      gridExpand = TRUE
    )

    ##right borders
    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = openxlsx::createStyle(
        border = c("right"),
        borderStyle = c("thick")
      ),
      rows = rows,
      cols = cols[length(cols)],
      stack = TRUE,
      gridExpand = TRUE
    )

    ## top borders
    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = openxlsx::createStyle(
        border = c("top"),
        borderStyle = c("thick")
      ),
      rows = rows[1],
      cols = cols,
      stack = TRUE,
      gridExpand = TRUE
    )

    ##bottom borders
    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = openxlsx::createStyle(
        border = c("bottom"),
        borderStyle = c("thick")
      ),
      rows = rows[length(rows)],
      cols = cols,
      stack = TRUE,
      gridExpand = TRUE
    )

  }

  # HELPER: format_toTranspose() --------------------------------------------

  format_toTranspose <- function(
    sheet,
    wb,
    max_row,
    dataStyle,
    rowNameStyle,
    colInfoStyle
  ) {
    data <- openxlsx::readWorkbook(wb, sheet = sheet, colNames = FALSE, rowNames = FALSE)
    colNames <- unlist( data[1,] )
    nameCol <- which(colNames == "valueProperty")
    rowNames <- unlist(data[,nameCol])

    dataRows <- 2:nrow(data)
    dataCols <- grep("DATA", colNames):ncol(data)

    # format data range -------------------------------------------------------

    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = dataStyle,
      rows = dataRows,
      cols = dataCols,
      gridExpand = TRUE
    )
    setBorders(
      wb = wb,
      sheet = sheet,
      rows = dataRows,
      cols = dataCols
    )

    # format col names --------------------------------------------------------

    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = rowNameStyle,
      rows = 1,
      cols = 1:dataCols,
      gridExpand = TRUE
    )
    setBorders(
      wb = wb,
      sheet = sheet,
      rows = 1,
      cols = 1:dataCols
    )

    # format row name and info ---------------------------------------------

    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = colInfoStyle,
      rows = dataRows,
      cols = 1:(dataCols - 1),
      gridExpand = TRUE
    )
    setBorders(
      wb = wb,
      sheet = sheet,
      rows = dataRows,
      cols = 1:(dataCols - 1)
    )


    # remove row heights to make automatic ------------------------------------

    openxlsx::removeRowHeights(
      wb = wb,
      sheet = sheet,
      rows = 1:max_row
    )


    # delete data if keepData is FALSE ----------------------------------------

    if (!keepData) {
      openxlsx::deleteData(
        wb = wb,
        sheet = sheet,
        cols = dataCols,
        rows = dataRows,
        gridExpand = TRUE
      )
    }

    # protect sheet -----------------------------------------------------------
    if (protect_possible) {
      openxlsx::protectWorksheet(
        wb = wb,
        sheet = sheet,
        password = "test"
      )
    }
  }

  # Set maximum number of rows for entering -------------------------------------------------------------------

  max_row <- 120

  # Define rowNameStyle cell style ----------------------------------------------

  if (protect_possible) {
    rowNameStyle <- openxlsx::createStyle(
      fontName = NULL,
      fontSize = 14,
      fontColour = "blue",
      numFmt = "GENERAL",
      border = c("top", "bottom", "left", "right") ,
      borderColour = "black",
      borderStyle = "thin",
      bgFill = NULL,
      fgFill = "lightpink",
      halign = "left",
      valign = "center",
      textDecoration = "bold",
      wrapText = TRUE,
      textRotation = NULL,
      indent = NULL,
      locked = TRUE
    )
  } else {
    rowNameStyle <- openxlsx::createStyle(
      fontName = NULL,
      fontSize = 14,
      fontColour = "blue",
      numFmt = "GENERAL",
      border = c("top", "bottom", "left", "right") ,
      borderColour = "black",
      borderStyle = "thin",
      bgFill = NULL,
      fgFill = "lightpink",
      halign = "left",
      valign = "center",
      textDecoration = "bold",
      wrapText = TRUE,
      textRotation = NULL,
      indent = NULL
    )
  }
  # Define colInfoStyle column name and top row style ------------------------------------

  colInfoStyle <- rowNameStyle
  colInfoStyle$fontSize <- 12
  colInfoStyle$fontColour <- "black"

  # Define dataStyle cell style -------------------------------------------------

  if (protect_possible) {
    dataStyle <- openxlsx::createStyle(
      fontName = NULL,
      fontSize = 11,
      fontColour = "black",
      numFmt = "GENERAL",
      border = c("top", "bottom", "left", "right") ,
      borderColour = "black",
      borderStyle = "thin",
      bgFill = NULL,
      fgFill = "darkseagreen1",
      halign = NULL,
      valign = NULL,
      textDecoration = NULL,
      wrapText = TRUE,
      textRotation = NULL,
      indent = NULL,
      locked = FALSE
    )
  } else {
    dataStyle <- openxlsx::createStyle(
      fontName = NULL,
      fontSize = 11,
      fontColour = "black",
      numFmt = "GENERAL",
      border = c("top", "bottom", "left", "right") ,
      borderColour = "black",
      borderStyle = "thin",
      bgFill = NULL,
      fgFill = "darkseagreen1",
      halign = NULL,
      valign = NULL,
      textDecoration = NULL,
      wrapText = TRUE,
      textRotation = NULL,
      indent = NULL
    )
  }

  # load workbook -----------------------------------------------------------

  wb <- openxlsx::loadWorkbook(fn_org)

  # Set formating and validation on worksheet ---------------

  for ( sheet in toTranspose()) {
    if (sheet %in% openxlsx::sheets(wb)) {
      format_toTranspose(
        sheet,
        wb = wb,
        max_row = max_row,
        dataStyle = dataStyle,
        rowNameStyle = rowNameStyle,
        colInfoStyle = colInfoStyle)
    }
  }

  # Set formating and validation on all worksheets except of toTransposed()  -----------------

  propSets <- grep(
    pattern = paste(c(toTranspose(), "DOCUMENTATION"), collapse = "|"),
    x = openxlsx::sheets(wb),
    value = TRUE,
    invert = TRUE
  )


  for (sheet in propSets) {

    # identify range of data cells --------------------------------------------

    data <- openxlsx::readWorkbook(wb, sheet = sheet, colNames = FALSE, rowNames = FALSE)
    rowNames <- data[[1]]
    nameRow <- which(rowNames == "valueProperty")
    colNames <- unlist(data[nameRow,])

    dataCols <- 2:ncol(data)
    dataRows <- grep("DATA", rowNames):nrow(data)

    # format data range -------------------------------------------------------

    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = dataStyle,
      rows = dataRows[1]:max_row,
      cols = dataCols,
      gridExpand = TRUE
    )
    setBorders(
      wb = wb,
      sheet = sheet,
      rows = dataRows[1]:max_row,
      cols = dataCols
    )

    # format row names --------------------------------------------------------

    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = rowNameStyle,
      rows = 1:max_row,
      cols = 1,
      gridExpand = TRUE
    )
    setBorders(
      wb = wb,
      sheet = sheet,
      rows = dataRows[1]:max_row,
      cols = 1
    )

    # format column name and info ---------------------------------------------

    openxlsx::addStyle(
      wb = wb,
      sheet = sheet,
      style = colInfoStyle,
      rows = 1:(dataRows[[1]] - 1),
      cols = 2:ncol(data),
      gridExpand = TRUE
    )
    setBorders(
      wb = wb,
      sheet = sheet,
      rows = 1:(dataRows[[1]] - 1),
      cols = 2:ncol(data)
    )


    # remove row heights to make automatic ------------------------------------

    openxlsx::removeRowHeights(
      wb = wb,
      sheet = sheet,
      rows = 1:max_row
    )


    # delete data if keepData is FALSE ----------------------------------------

    if (!keepData) {
      openxlsx::deleteData(
        wb = wb,
        sheet = sheet,
        cols = dataCols,
        rows = dataRows[1]:max_row,
        gridExpand = TRUE
      )
    }

    # protect sheet -----------------------------------------------------------
    if (protect_possible) {
      openxlsx::protectWorksheet(
        wb = wb,
        sheet = sheet,
        password = "test"
      )
    }

  }


  # TODO write formulas in DataFile ----------------------------------------------

  # data <- openxlsx::readWorkbook(wb, sheet = "Treatment", colNames = FALSE, rowNames = FALSE)
  # dataRowStart <- which(data[[1]] == "DATA")
  #
  # tn <- paste0(
  #   "CONCATENATE(",
  #   paste0(
  #     "Treatment!B",
  #     dataRowStart:max_row,
  #     collapse = ", \", \", "
  #   ),
  #   ")"
  # )
  #
  # openxlsx::writeFormula(
  #   wb = wb,
  #   sheet = "DataFile",
  #   x = tn,
  #   startCol = 3,
  #   startRow = dataRowStart - 1
  # )

  # Protect workbook --------------------------------------------------------

  if (protect_possible) {
    openxlsx::protectWorkbook(wb, password = "test")
  }

  # Save workbook when fn_new is specified ----------------------------------

  if (!missing(fn_new)) {
    openxlsx::saveWorkbook(wb, fn_new, overwrite = TRUE)
  }

  # return invisibly the workbook -------------------------------------------

  invisible( wb )
}

