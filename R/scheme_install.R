#' Functions to manage schemes
#'
#' \bold{\code{scheme_install()}:} Installed schemes are copied to \code{system.file("installedSchemes",
#' package = "dmdScheme")} and , if necessary, an \code{.xlsx} definition is
#' saved in addition. These can be listed by using \link{scheme_list}.
#' @param schemeDefinition file containing the definition of the dmdScheme in a format readable by this package
#' @param overwrite if \code{TRUE}, the scheme will be overwritten if it exists
#'
#' @return result of \link{file.copy}
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' \dontrun{
#' scheme_install("path/to/definition.xml")
#' scheme_install("path/to/definition.xlsx")
#' }
#'
scheme_install <- function(
  schemeDefinition,
  overwrite = FALSE
){

  if (!file.exists(schemeDefinition)) {
    stop("schemeDefinition does not exist!")
  }

  type <- tools::file_ext(schemeDefinition)
  scheme <- switch(
    type,
    xlsx = as_dmdScheme( read_excel_raw( schemeDefinition, checkVersion = FALSE ), checkVersion = FALSE, keepData = TRUE),
    xml  = read_xml(  schemeDefinition, keepData = TRUE, useSchemeInXml = TRUE ),
    stop("Unsupported file type!")
  )


  name <- attr(scheme, "dmdSchemeName")
  version <- attr(scheme, "dmdSchemeVersion")
  schemeName <- paste0(name, "_", version, ".", type)
  schemeFile <- file.path( system.file("installedSchemes", package = "dmdScheme"), schemeName  )
  excelFile  <- file.path( system.file("installedSchemes", package = "dmdScheme"), gsub(type, "xlsx", schemeName) )
  xmlFile    <- file.path( system.file("installedSchemes", package = "dmdScheme"), gsub(type, "xml",  schemeName) )

  if (!overwrite) {
    if ( any(file.exists( c(schemeFile, excelFile, xmlFile ))) ) {
      stop("schemeDefinition exists! Use `overwrite = TRUE` if you want to overwrite it!")
    }
  }

  if (type != "xlsx") {
    write_excel(scheme, excelFile)
    message(
      "\n",
      "The xlsx was generated from a different format.\n",
      "There might be problems with the function `open_new_spreadsheet().\n",
      "In this case\n",
      "   1. open the file", excelFile, "in Excel or any other spreadsheet program\n",
      "   2. and save it again under the same name!",
      "\n"
    )
  }

  if (type != "xml") {
    write_xml(scheme, xmlFile, output = "complete", keepData = TRUE)
  }

  message(
    "Scheme definition ", schemeDefinition, "installed with\n",
    "name:    ", name, "\n",
    "version: ", version
  )
  invisible( file.copy(schemeDefinition, schemeFile, overwrite = overwrite) )
}
