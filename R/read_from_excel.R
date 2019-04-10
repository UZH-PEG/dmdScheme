#' Read scheme data from Excel file
#'
#' Reads the data from an Excel file. TRhe structure of the Excel file has to be
#' \bold{identical} to the one opened by \code{enter_new_metadata()}
#'
#' @param file the name of the Excel file (.xls or .xlsx) containing the data to be
#'   read from.
#' @param keepData if the data in \code{file} should be kept or replaced with
#'   one row with NAs. \code{keepData = FALSE} is only importing the structure
#'   of the \code{emeScheme} as in the variable \code{emeScheme}.
#' @param verbose give verbose progress info. Useful for debugging.
#' @param raw if \code{TRUE} the excel file will be read as-is and not converted
#'   to an \code{emeScheme} object.
#' @param validate Results are usually validated using \code{ validate(
#'   errorIfFalse = TRUE )}. Consequently, an error is raised if the resulting
#'   scheme can not be successfully validated against the one in the package.
#'   There are not many cases where you want to change this value to
#'   \code{FALSE}. But if you do, the result will not be validated. \bold{This
#'   can lead to invalid schemes!}.
#'
#' @return either if \code{raw = TRUE} a list of tibbles from the worksheets as
#'   defined in \code{propSets} of Class \code{emeScheme_raw}, otgherwise an
#'   object of class \code{emeSchemeSet}
#'
#' @importFrom magrittr %>% equals not
#' @importFrom readxl read_excel
#' @importFrom tools file_path_sans_ext file_ext
#'
#' @export
#'
#' @examples
#' read_from_excel(file = system.file("emeScheme.xlsx", package = "emeScheme"))
#'
read_from_excel <- function(
  file,
  keepData = TRUE,
  verbose = FALSE,
  raw = FALSE,
  validate = TRUE
) {

# Check if file exists ----------------------------------------------------


  if (!file.exists(file)) {
    stop("Can not open file '", file, "': No such file or directory")
  }

# Check if extension is xls or xlsx ---------------------------------------

  if (!(tools::file_ext(file) %in% c("xls", "xlsx"))) {
    stop("If x is a file name, it has to have the extension 'xls' or 'xlsx'")
  }

# Load sheets from excel file corrsponding to propSets --------------------

  result <- lapply(
    propSets,
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
        "emeSchemeData_raw",
        class(x)
      )
      return(x)
    }
  )
  names(result) <- propSets

# Set Attributes ----------------------------------------------------------

  attr(result, "fileName") <- file %>%
    tools::file_path_sans_ext() %>%
    basename()

# Set version -------------------------------------------------------------

  v <- names(result$Experiment)[ncol(result$Experiment)]
  v <- gsub("DATA_v", "", v)
  if (v == "DATA") {
    v <- "0.9.5"
  }
  attr(result, "emeSchemeVersion") <- v

# Set class to emeScheme_Raw ----------------------------------------------

  class(result) <- append(
    "emeSchemeSet_raw",
    class(result)
  )

# Validate imported structure against emeScheme ---------------------------

  if (validate) {
    validate(
      x = result,
      validateData = FALSE,
      errorIfStructFalse = TRUE
    )
  }

# Convert to emeScheme if asked for ---------------------------------------

  if (!raw) {
    result <- new_emeSchemeSet(
      result,
      keepData = keepData,
      verbose = verbose
    )
  }

# Return result -----------------------------------------------------------

  return(result)
}
