#' Read scheme data from Excel file into \code{\link[dmdScheme]{dmdScheme_raw}} object
#'
#' Reads the data from an Excel file as is and no validation. Only validation of
#' the scheme version and scheme name is done (when \code{checkVersion = TRUE}).
#'
#' @param file the name of the Excel file (.xls or .xlsx) containing the data to be
#'   read.
#' @param verbose give verbose progress info. Useful for debugging.
#' @param checkVersion if \code{TRUE}, check for version or scheme conflicts
#'   between the package scheme version and the scheme version of the file.
#'   Aborts with an error if there is a conflict.
#'
#' @return object of class \code{dmdScheme_raw}
#'
#' @importFrom magrittr %>% equals not
#' @importFrom readxl read_excel excel_sheets
#' @importFrom tools file_path_sans_ext file_ext
#'
#' @export
#'
#' @examples
#' read_excel_raw( scheme_path_xlsx() )
#'
read_excel_raw <- function(
  file,
  verbose = FALSE,
  checkVersion = TRUE
) {

  # Check if file exists ----------------------------------------------------

  if (!file.exists(file)) {
    stop("Can not open file '", file, "': No such file or directory")
  }

  # Check if extension is xls or xlsx ---------------------------------------

  if (!(tools::file_ext(file) %in% c("xls", "xlsx"))) {
    stop("If x is a file name, it has to have the extension 'xls' or 'xlsx'")
  }

  # Extract Scheme and version ----------------------------------------------

  v <- readxl::read_excel(path = file, sheet = "Experiment",  .name_repair = "unique") %>%
    names() %>%
    grep("DATA", ., value = TRUE) %>%
    strsplit(" ")
  schemeName <- v[[1]][2]
  schemeVersion <- gsub("v", "", v[[1]][3])

  # Check dmdSchemeVersion --------------------------------------------------

  if (checkVersion) {
    if (scheme_active()$version != schemeVersion) {
      stop("Version conflict - can not proceed:\n",
           file, " version : ", schemeVersion, "\n",
           "installed dmdScheme version : ", scheme_active()$version)
    }
    if (scheme_active()$name != schemeName) {
      stop("Scheme conflict different schemes used - can not proceed:\n",
           file, " scheme name : ", schemeName, "\n",
           "installed dmdScheme scheme : ", scheme_active()$name)
    }
  }

  # Define class ------------------------------------------------------------

  if (schemeName == "dmdScheme") {
    newSetClass <-  "dmdSchemeSet_raw"
  } else {
    newSetClass <- c( paste0(schemeName, "Set_raw"), "dmdSchemeSet_raw")
  }

  if (schemeName == "dmdScheme") {
    newDataClass <-  "dmdSchemeData_raw"
  } else {
    newDataClass <- c( paste0(schemeName, "Data_raw"), "dmdSchemeData_raw")
  }

  # Load sheets from excel file  --------------------

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
      ) %>% as.data.frame(stringsAsFactors = FALSE)
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
        newDataClass,
        class(x)
      )
      return(x)
    }
  )

  names(result) <- propSheets

  # Set Attributes ----------------------------------------------------------

  attr(result, "dmdSchemeName") <- schemeName
  attr(result, "dmdSchemeVersion") <- schemeVersion
  attr(result, "propertyName") <- schemeName
  attr(result, "fileName") <- basename(file)

  # Set class to dmdSchemeSet_Raw ----------------------------------------------

  class(result) <- append(
    newSetClass,
    class(result)
  )

  # Return result -----------------------------------------------------------

  return(result)
}
