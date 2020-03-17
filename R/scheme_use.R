#' Functions to manage schemes
#'
#' \bold{\code{scheme_use()}:} Switch from the current scheme to a new scheme as defined in the scheme
#' \code{schemeDefinition}. Installed schemes can be listed by using \code{scheme_list()}.
#' New schemes can be added to the library via a call to \code{scheme_add()}.
#' The name of the active scheme is saved in \code{dmdScheme_active}
#' @param name a \code{character} string containing the name of the scheme
#'   definition
#' @param version a \code{character} string containing the version of the scheme
#'   definition
#'
#' @rdname scheme
#'
#' @importFrom tools file_ext
#'
#' @export
#'
#' @examples
#' scheme_list()
#' scheme_use(name = "dmdScheme", version = "0.9.5")
#'
scheme_use <- function(
  name = NULL,
  version = NULL
) {

  if (!scheme_installed(name, version)) {
    stop("`", name, "_", version, "`is not instaled!")
  }


  schemeName <- paste0( name, "_", version)
  schemeDefinition <- file.path(cache("installedSchemes", schemeName), paste0( schemeName, ".xml" ))

  scheme <- read_xml(  schemeDefinition, useSchemeInXml = TRUE, keepData = FALSE )
  assign("dmdScheme", scheme, envir = .dmdScheme_cache)

  scheme_example <- read_xml(  schemeDefinition, useSchemeInXml = TRUE, keepData = TRUE )
  assign("dmdScheme_example", scheme_example, envir = .dmdScheme_cache)

  scheme_raw <- as_dmdScheme_raw(scheme_example)
  assign("dmdScheme_raw", scheme_raw, envir = .dmdScheme_cache)


  message("Theme switched to ", schemeName)
}
