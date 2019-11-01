#' Title
#'
#' @param schemeDefinition
#'
#' @return
#'
#' @importFrom tools, file_ext
#'
#' @export
#'
#' @examples
use_scheme <- function(
  schemeDefinition = "dmdScheme.xml"
) {
  type <- tools::file_ext(schemeDefinition)
  scheme <- switch(
    type,
    xlsx = read_excel(system.file("schemeDefinitions", schemeDefinition, package = "dmdScheme")),
    xml  = read_xml(  system.file("schemeDefinitions", schemeDefinition, package = "dmdScheme")),
    stop("Unsupported file type!")
  )
  assign("dmdScheme", 1, "package:dmdScheme")
  assign("dmdScheme_raw", as_dmdScheme_raw(scheme), "package:dmdScheme")
  assign("dmdScheme_example", scheme, "package:dmdScheme")
}
