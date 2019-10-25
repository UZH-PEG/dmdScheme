#' @param useSchemeInXml if \code{TRUE}, use scheme definition in xml and raise
#'   an error if the xml does not contain a scheme definition. If False, use the
#'   scheme definition from the corresponding installed package, even if the xml
#'   contains a scheme definition. if \code{NULL} (the default), use the
#'   definition in the xml if it contains a definition, if not use the
#'   corresponding definition from the installed package.
#'
#' @rdname as_dmdScheme_raw
#' @export
#'
as_dmdScheme_raw.xml_document <- function(
  x,
  useSchemeInXml = NULL,
  ...
) {

  dmd <- as_dmdScheme(x, useSchemeInXml = useSchemeInXml, keepData = TRUE)
  result <- as_dmdScheme_raw( dmd, ...  )

  # Return ------------------------------------------------------------------

  return(result)
}

