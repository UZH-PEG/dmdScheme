#' Use a scheme in the package
#'
#' Switch from the current scheme to a new scheme as defined in the scheme
#' \code{schemeDefinition}. Installed schemes can be listed by using \code{scheme_list()}.
#' New schemes can be added to the library via a call to \code{scheme_add()}.
#' @param schemeDefinition
#'
#' @rdname scheme
#'
#' @importFrom tools file_ext
#'
#' @export
#'
#' @examples
#' scheme_list()
#' use_scheme("dmdScheme_0.9.5.xml)
#' use_scheme("dmdScheme_0.9.5.xlsx)
#' \dontrun{
#' scheme_install("path/to/definition.xml)
#' scheme_install("path/to/definition.xlsx)
#' }
scheme_use <- function(
  schemeDefinition = NULL
) {
  type <- tools::file_ext(schemeDefinition)

  schemeName <- schemeDefinition

  schemeDefinition <- system.file("installedSchemes", schemeDefinition, package = "dmdScheme")

  if (!file.exists(schemeDefinition)) {
    "Scheme is not installed. Use `scheme_list()` to see all installed themes!"
  }

  scheme_example <- switch(
    type,
    xlsx = as_dmdScheme( read_excel_raw( schemeDefinition, checkVersion = FALSE ), checkVersion = FALSE),
    xml  = read_xml(  schemeDefinition, useSchemeInXml = TRUE ),
    stop("Unsupported file type!")
  )

  assign("dmdScheme_example", scheme_example, "package:dmdScheme")
  scheme_raw <- as_dmdScheme_raw(scheme_example)
  assign("dmdScheme_raw", scheme_raw, "package:dmdScheme")
  scheme <- as_dmdScheme(scheme_raw, keepData = FALSE, checkVersion = FALSE)
  assign("dmdScheme", scheme, "package:dmdScheme")

  message("Theme switched to ", schemeName)
  assign("dmdScheme_active", schemeName, "package:dmdScheme")
}
