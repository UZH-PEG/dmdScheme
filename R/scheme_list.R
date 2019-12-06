#' List all sinstalled schemes
#'
#' \bold{\code{scheme_list()}:} Lists all definitions for schemes which are installed. Each follows the
#' pattern \code{SCHEMENAME_SCHEMEVERSION.EXT}. All files with the same basename
#' but different extensions represent different representations of the same
#' scheme definition and are effectively equivalent, only that the tab
#' Documentation can only be found in the \code{.xls} files.
#' @return \code{data.frame} with two columns containing name and version of the intalled schemes
#'
#' @rdname scheme
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom magrittr %>%
#'
#' @export
#'
scheme_list <- function() {

  result <- cache("installedSchemes") %>%
    list.dirs(full.names = FALSE, recursive = FALSE) %>%
    strsplit("_")

  result <- data.frame(
    name = sapply(result, "[[", 1),
    version = sapply(result, "[[", 2),
    stringsAsFactors = FALSE
  )

  return(result)
}
