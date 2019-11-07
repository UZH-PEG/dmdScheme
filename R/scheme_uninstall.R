#' Remove \code{schemeName} file from installed schemes
#'
#' Installed schemes are deleted from \code{system.file("installedSchemes",
#' package = "dmdScheme")}.
#' @param schemeDefinition complete scheme name \bold{without} the extension
#' @param delete if \code{TRUE}, the scheme definitions will be deleted, if
#'   \code{FALSE}, the paths will be returned
#'
#' @return if \code{delete = TRUE}, the result from the function
#'   \link{unlink()}, otherwise the fully qualified paths of the files which
#'   would be deleted.
#'
#' @rdname scheme
#'
#' @export
#'
scheme_uninstall <- function(
  schemeName,
  delete = FALSE
){

  if (schemeName == scheme_default()) {
    stop("You can not uninstall the scheme definition which comes with the package!")
  }

  result <- list.files(
    path = system.file("installedSchemes", package = "dmdScheme"),
    pattern = paste0("^", schemeName, "\\."),
    full.names = TRUE
  )

  if (delete) {
    result <- unlink(result)
    invisible( result )
  } else {
    return(result)
  }
}
