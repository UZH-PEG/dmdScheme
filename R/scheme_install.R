#' Add \code{schemeDefinition} file to installed schemes
#'
#' Installed schemes are copied to \code{system.file("schemeDefinitions",
#' package = "dmdScheme")} and , if necessary, an \code{.xlsx} definition is
#' saved in addition. These can be listed by using \link{scheme_list()}.
#' @param schemeDefinition file containing the scheme definition in a recognized format
#' @param overwrite if \code{TRUE}, the scheme will be overwritten if it exists
#'
#' @return result of \link{file.copy()}
#'
#' @rdname scheme
#'
#' @export
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
    xlsx = as_dmdScheme( read_excel_raw( schemeDefinition, checkVersion = FALSE ), checkVersion = FALSE),
    xml  = read_xml(  schemeDefinition, useSchemeInXml = TRUE ),
    stop("Unsupported file type!")
  )

  schemeName <- paste0(attr(scheme, "dmdSchemeName"), "_", attr(scheme, "dmdSchemeVersion"), ".", type)
  schemeFile <- file.path( system.file("schemeDefinitions", package = "dmdScheme"), schemeName  )
  excelFile  <- file.path( system.file("schemeDefinitions", package = "dmdScheme"), gsub(type, "xlsx", schemeName) )
  xmlFile    <- file.path( system.file("schemeDefinitions", package = "dmdScheme"), gsub(type, "xml",  schemeName) )

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
    write_xml(scheme, xmlFile, output = "complete")
  }

  invisible( file.copy(schemeDefinition, schemeFile, overwrite = overwrite) )
}
