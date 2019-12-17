#' Convert older scheme versions of files to newer newer versions
#'
#' Only the newest versions of \code{xlsx} and \code{xml} files can be processed
#' by this package. To gurantee, this function provides a mechanism to convert
#' older versions of \code{xlsx} and \code{xml} files to newer versions.
#' @param file file name of \code{xlsx} or of \code{xml} file containing scheme
#'   metadata or structure
#' @param to version to upgrade to. Any version supported is possible, downgrade
#'   is not supported.
#'
#' @return if a conversion has been done, file name of upgraded spreadsheet
#'   (\code{BASENAME(x).to.EXTENSION(x)} where \code{x} is the original file
#'   name and \code{to} is the new version), otherwise \code{NULL}.
#'
#' @importFrom magrittr %>%
#' @importFrom readxl read_excel excel_sheets
#' @importFrom tools file_path_sans_ext file_ext
#' @importFrom xml2 read_xml xml_attr
#' @export
#'
#' @examples
#' \dontrun{
#' upgrade("dmdScheme.xlsx")
#' upgrade("dmdScheme.xml")
#' }
upgrade_old_files <- function(
  file,
  to = scheme_active()$version
) {
  # Check if file exists ----------------------------------------------------

  if (!file.exists(file)) {
    stop("Can not open file '", file, "': No such file or directory")
  }

  # Check if extension is xls, xlsx or xml ----------------------------------

  if (!(tools::file_ext(file) %in% c("xls", "xlsx", "xml"))) {
    stop("x has to have the extension 'xls' 'xlsx' or 'xml'")
  }

  # Extract Scheme and version and check name -------------------------------

  if (tools::file_ext(file) %in% c("xls", "xlsx")) {
    v <- readxl::read_excel(path = file, sheet = "Experiment") %>%
      names() %>%
      grep("DATA", ., value = TRUE) %>%
      strsplit(" ")
    schemeName <- v[[1]][2]
    schemeVersion <- gsub("v", "", v[[1]][3])
  }

  if (tools::file_ext(file) %in% c("xml")) {
    xml <- xml2::read_xml(file)
    schemeName <- xml2::xml_attr(xml, "dmdSchemeName")
    schemeVersion <- as.numeric_version(xml2::xml_attr(xml, "dmdSchemeVersion"))
    rm(xml)
  }

# Check scheme name --------------------------------------------------------

  scheme <- NULL
  try(
    {
      scheme <- get(eval(schemeName))
    },
    silent = TRUE
  )

  if (is.null(scheme)) {
    stop("The scheme is in a not in a loaded scheme definition.\n",
         "  Load the R package containing the scheme before trying again."
    )
  }

  rm(scheme)

# Check version number and do conversion -----------------------------------

  converted <- NULL

  if (as.numeric_version(schemeVersion) > scheme_active()$version) {
    stop("Downgrade not supported!")
  } else if (schemeVersion == scheme_active()$version) {
    warning("File has same version as the installed package. No conversion necessary!")
    converted <- NULL
  } else if (schemeVersion < scheme_active()$version) {
    stop("Upgrade from version ", schemeVersion, "to version ", scheme_active()$version, " not implemented yet!")
  }

# Return `converted` ------------------------------------------------------

  invisible(converted)
}
