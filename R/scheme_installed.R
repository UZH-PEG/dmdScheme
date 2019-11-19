#' Functions to manage schemes
#'
#' \bold{\code{scheme_installed()}:} Checks if a scheme is installed
#'
#' @return \code{TRUE} if the theme is installed, \code{FALSE} if not
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' \dontrun{
#' scheme_installed("dmdScheme", "0.9.5")
#' scheme_installed("dmdScheme", "0.7.3")
#' }
scheme_installed <- function(
  name,
  version
) {
  result <- paste0(name, "_", version) %in% apply(scheme_list(), MARGIN = 1, paste, collapse = "_")
  return(result)
}
