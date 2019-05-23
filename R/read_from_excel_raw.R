#' Read scheme data from Excel file
#'
#' Reads the data from an Excel file. TRhe structure of the Excel file has to be
#' \bold{identical} to the one opened by \code{enter_new_metadata()}
#'
#' @param file the name of the Excel file (.xls or .xlsx) containing the data to be
#'   read from.
#' @param keepData if the data in \code{file} should be kept or replaced with
#'   one row with NAs. \code{keepData = FALSE} is only importing the structure
#'   of the \code{dmdScheme} as in the variable \code{dmdScheme}.
#' @param verbose give verbose progress info. Useful for debugging.
#' @param schemeName name of the scheme. Default: dmdScheme. Only for developing new schemes needed.
#'
#' @return either if \code{raw = TRUE} a list of tibbles from the worksheets of
#'   Class \code{dmdScheme_raw}, otherwise an object of class
#'   \code{dmdSchemeSet}
#'
#' @importFrom magrittr %>% equals not
#' @importFrom readxl read_excel excel_sheets
#' @importFrom tools file_path_sans_ext file_ext
#'
#' @export
#'
#' @examples
#' read_from_excel(file = system.file("dmdScheme.xlsx", package = "dmdScheme"))
#'
read_from_excel_raw <- function(
  file,
  keepData = TRUE,
  verbose = FALSE,
  schemeName = "dmdScheme"
) {

# Check if file exists ----------------------------------------------------


  if (!file.exists(file)) {
    stop("Can not open file '", file, "': No such file or directory")
  }

# Check if extension is xls or xlsx ---------------------------------------

  if (!(tools::file_ext(file) %in% c("xls", "xlsx"))) {
    stop("If x is a file name, it has to have the extension 'xls' or 'xlsx'")
  }

# Load sheets from excel file  --------------------

  if (schemeName == "dmdScheme") {
    newClass <-  "dmdSchemeData_raw"
  } else {
    newClass <-c( paste0(schemeName, "Data_raw"), "dmdSchemeData_raw")
  }

  propSheets <- readxl::excel_sheets(path = file)
  propSheets <- grep("DOCUMENTATION", propSheets, invert = TRUE, value = TRUE)
  result <- lapply(
    propSheets,
    function(sheet) {
      x <- suppressMessages(
        readxl::read_excel(
          path = file,
          sheet = sheet,
          na = c("", "NA", "na")
        )
      )
      notNARow <- x %>%
        is.na() %>%
        rowSums() %>%
        magrittr::equals(ncol(x)) %>%
        not()
      notNACol <- x %>%
        is.na() %>%
        colSums() %>%
        magrittr::equals(nrow(x)) %>%
        not()
      x <- x[notNARow, notNACol]
      class(x) <- append(
        newClass,
        class(x)
      )
      return(x)
    }
  )
  names(result) <- propSheets

# Check dmdSchemeVersion --------------------------------------------------

  v <- grep("DATA", names(result$Experiment), value = TRUE)
  v <- gsub("DATA_v", "", v)
  if (v == "DATA") {
    v <- "unknown"
  }
  if (dmdSchemeVersions(schemeName)$scheme != v) {
    stop("Version conflict - can not proceed:\n",
         file, " : version ", v, "\n",
         "installed dmdScheme version : ", dmdSchemeVersions()$dmdScheme)
  }

# Set version -------------------------------------------------------------

  attr(result, "dmdSchemeVersion") <- v

# Set Attributes ----------------------------------------------------------

  attr(result, "fileName") <- file %>%
    tools::file_path_sans_ext() %>%
    basename()


# Set class to dmdSchemeSet_Raw ----------------------------------------------

  if (schemeName == "dmdScheme") {
    newClass <-  "dmdSchemeSet_raw"
  } else {
    newClass <-c( paste0(schemeName, "Set_raw"), "dmdSchemeSet_raw")
  }

  class(result) <- append(
    newClass,
    class(result)
  )

# Return result -----------------------------------------------------------

  return(result)
}
