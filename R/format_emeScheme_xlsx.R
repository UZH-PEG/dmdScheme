#' Format the \code{googlesheet/emeScheme.xlsx}
#'
#' Takes no arguments. Loads  \code{system.file("inst", "googlesheet", "emeScheme.xlsx", package = "emeScheme")}, formats it and saves it under the same name.
#' @param fn file name where the final xlsx should be saved to. If missing, it will not be saved.
#' @param emeScheme_gd specifying this, makes it possible to use this function even during the update process.
#' @return invisibly the workbook as a workbook object as created by \code{xlsx.crerateWorkbook()}
#' @importFrom xlsx loadWorkbook getSheets getRows getCells getCellValue CellStyle CellProtection Fill Border setCellStyle setColumnWidth saveWorkbook
#' @importFrom magrittr %>%
#'
format_emeScheme_xlsx <- function(fn, emeScheme_gd) {

  ## get logical vector indicating if row contains a value property
  valueRows <- emeScheme_gd %>%
    replace(is.na(.), "") %>%
    apply(1, paste, collapse = "") %>%
    trimws() %>%
    sapply(
      function(i) {
        1 %in% unlist( gregexpr("[a-z]", i) )
      }
    ) %>%
    c(FALSE, .)

  ## get maximum number of relevant rows
  relevantRows <- nrow(emeScheme_gd) + 1

  ## load workbook
  wb <- xlsx::loadWorkbook(fn)

  ## get sheets
  sheet <- xlsx::getSheets(wb)[[1]]

  ## get Header cells to identify Data columns
  header <- xlsx::getRows(sheet, rowIndex = 1)
  cells <- xlsx::getCells(header)
  col_names <- sapply(cells, xlsx::getCellValue)


  col_names <- xlsx::getRows(sheet, rowIndex = 1) %>%
    xlsx::getCells() %>%
    sapply(xlsx::getCellValue)
  propColumns <- which(  startsWith(col_names, "Property_") )
  dataColumns <- which( !startsWith(col_names, "Property_") )

  ## get all non-empty rows
  relevantRows <- xlsx::getRows(sheet, rowIndex = 1:relevantRows)

  ## Get Data cells
  dataCells <- xlsx::getCells(relevantRows, colIndex = dataColumns)

  ## Apply unlocking and format all data example cells with value properties
  cs <- xlsx::CellStyle(
    wb,
    cellProtection = xlsx::CellProtection(locked=FALSE)
    ) +
    xlsx::Fill(
      backgroundColor="lavender",
      foregroundColor="lavender",
      pattern="SOLID_FOREGROUND"
    ) +
    xlsx::Border(
      color = "red",
      position  = c("TOP", "BOTTOM", "LEFT", "RIGHT"),
      pen = "BORDER_THICK"
    )
  lapply(
    names(dataCells)[valueRows],
    function(ii) {
      xlsx::setCellStyle(
        dataCells[[ii]],
        cs
      )
    }
  )

  ## set column width of data column(s)
  xlsx::setColumnWidth(sheet, colIndex=dataColumns, colWidth = 80)

  ## Protect sheet with password
  sheet$protectSheet("not_very_secure_but_ok")

  ## save workbook again
  if (!missing(fn)) {
    xlsx::saveWorkbook(wb, fn)
  }

  invisible( wb )
}

