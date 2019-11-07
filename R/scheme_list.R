#' List all sinstalled schemes
#'
#' Lists all definitions for schemes which are installed. Each follows the
#' pattern \code{SCHEMENAME_SCHEMEVERSION.EXT}. All files with the same basename
#' but different extensions represent different representations of the same
#' scheme definition and are effectively equivalent, only that the tab
#' Documentation can only be found in the \code{.xls} files.
#' @return name of the default scheme
#'
#' @rdname scheme
#'
#' @export
#'
scheme_list <- function() {

  result <- list.files( system.file("installedSchemes", package = "dmdScheme") )

  return(result)
}
