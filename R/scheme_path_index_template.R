#' Functions to manage schemes
#'
#' @return fully qualified path to the \code{index} template file
#' @export
#'
#' @examples
#' scheme_path_index_template()
#'
scheme_path_index_template <- function() {
  schemeName <- paste0(scheme_active()$name, "_", scheme_active()$version )

  result <- list.files(
    path = file.path(cache("installedSchemes"), schemeName),
    pattern = "index.*",
    full.names = TRUE
  )

  if (length(result) == 0) {
    result <- system.file("index.md", package = "dmdScheme")
  }

  return(result)
}
