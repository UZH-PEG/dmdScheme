#' Use a scheme in the package
#'
#' Switch from the current scheme to a new scheme as defined in the file
#' \code{schemeDefinition}. The name of the scheme definition as in the folder \code{}.
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
#' use_scheme("dmdScheme.xml)
#' use_scheme("dmdScheme.xlsx)
#' \dontrun{
#' scheme_add("path/to/definition.xml)
#' scheme_add("path/to/definition.xlsx)
#' }
scheme_use <- function(
  schemeDefinition = "dmdScheme.xml"
) {
  type <- tools::file_ext(schemeDefinition)

  schemeDefinition <- system.file("schemeDefinitions", schemeDefinition, package = "dmdScheme")

  scheme_example <- switch(
    type,
    xlsx = as_dmdScheme( read_excel_raw( schemeDefinition, checkVersion = FALSE ), checkVersion = FALSE),
    xml  = read_xml(  schemeDefinition, useSchemeInXml = TRUE ),
    stop("Unsupported file type!")
  )

  assign("dmdScheme_example", scheme_example, "package:dmdScheme")
  scheme_raw <- as_dmdScheme_raw(scheme_example)
  assign("dmdScheme_raw", scheme_raw, "package:dmdScheme")
  scheme <- as_dmdScheme(scheme_raw, keepData = FALSE)
  assign("dmdScheme", scheme, "package:dmdScheme")
}
