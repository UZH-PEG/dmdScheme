#' Functions to manage schemes
#'
#' \bold{\code{scheme_uninstall()}:} Installed schemes are deleted from \code{system.file("installedSchemes",
#' package = "dmdScheme")}.
#' @param delete if \code{TRUE}, the scheme definitions will be deleted, if
#'   \code{FALSE}, the paths will be returned
#'
#' @return if \code{delete = TRUE}, the result from the function
#'   \link{unlink}, otherwise the fully qualified paths of the files which
#'   would be deleted.
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
  version = NULL,
  delete = FALSE
){

  if (!name %in% scheme_list()[["name"]]) {
    stop("Scheme with the name '", name, "' is not instaled!")
  }

  if (!version %in% scheme_list()[["version"]]) {
    stop("Version '", version, "' of scheme '", name, "' is not instaled!")
  }

  if ( all(c(name, version) == scheme_default()) ) {
    stop("You can not uninstall the default scheme definition which comes with the package!")
  }

  schemeName <- paste0( name, "_", version)
  result <- list.files(
    path = system.file("installedSchemes", package = "dmdScheme"),
    pattern = paste0("^", schemeName, "\\."),
    full.names = TRUE
  )

  if (delete) {
    result <- unlink(result)
    message("Theme ", schemeName, "deleted")
    invisible( result )
  } else {
    return(result)
  }
}
