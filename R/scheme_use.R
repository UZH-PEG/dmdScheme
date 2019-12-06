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

  scheme_example <- read_xml(  schemeDefinition, useSchemeInXml = TRUE )

  unlockBinding("dmdScheme_example", as.environment("package:dmdScheme"))
  assign("dmdScheme_example", scheme_example, "package:dmdScheme")
  lockBinding("dmdScheme_example", as.environment("package:dmdScheme"))

  scheme_raw <- as_dmdScheme_raw(scheme_example)
  unlockBinding("dmdScheme_raw", as.environment("package:dmdScheme"))
  assign("dmdScheme_raw", scheme_raw, "package:dmdScheme")
  lockBinding("dmdScheme_raw", as.environment("package:dmdScheme"))

  scheme <- as_dmdScheme(scheme_raw, keepData = FALSE, checkVersion = FALSE)
  unlockBinding("dmdScheme", as.environment("package:dmdScheme"))
  assign("dmdScheme", scheme, "package:dmdScheme")
  lockBinding("dmdScheme", as.environment("package:dmdScheme"))

  message("Theme switched to ", schemeName)
}
