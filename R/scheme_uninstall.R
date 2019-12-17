#' Functions to manage schemes
#'
#' \bold{\code{scheme_uninstall()}:} Installed schemes are deleted from
#' \code{cache("installedSchemes")} and moved to a temporary folder which is
#' rteturned invisibly.
#'
#' @return invisibly returns the temporary location where the scheme definition
#'   is moved to.
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' \dontrun{
#' scheme_uninstall(name = "schemename", version = "schemeversion")
#' }
#'
scheme_uninstall <- function(
  name = NULL,
  version = NULL
){

  if (!scheme_installed(name, version)) {
    stop("Scheme with the name '", name, "' and version `", version, "` is not instaled!")
  }

  if (!version %in% scheme_list()[["version"]]) {
    stop("Version '", version, "' of scheme '", name, "' is not instaled!")
  }

  if ( all(c(name, version) == scheme_default()) ) {
    stop("You can not uninstall the default scheme definition which comes with the package!")
  }

  if ( all(c(name, version) == scheme_active()) ) {
    stop("You can not uninstall the currently active scheme definition!")
  }

  schemeName <- paste0( name, "_", version)
  tmpdir <- tempfile()
  dir.create(tmpdir, recursive = TRUE)
  file.copy(
    from = cache("installedSchemes", schemeName),
    to = tmpdir,
    recursive = TRUE
  )

  unlink(
    cache("installedSchemes", schemeName),
    recursive = TRUE
  )
  message("Scheme ", schemeName, " deleted and moved to")
  return( tmpdir )
}
