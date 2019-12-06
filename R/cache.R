#' Return cache directory
#'
#' If the cache folder does not exist, it is created.
#' @param ... sub caches
#' @param delete if \code{TRUE}, the cache directory will be deleted.
#' @param create if \code{TRUE}, the folder will be created. This is done, when
#'   \code{delete = TRUE} after deleting the directory.
#'
#' @return fully qualified path to the cache folder
#'
#' @importFrom rappdirs
#' @export
#'
#' @examples
cache <- function(
  ...,
  delete = FALSE,
  create = FALSE
) {
  path <- file.path(
    rappdirs::user_config_dir(appname = "dmdScheme", appauthor = "dmdScheme"),
    ...
  )
  # if (!dir.exists(rappdirs::user_config_dir(appname = "dmdScheme"))) {
  #   ok <- askYesNo(
  #     msg = paste0(
  #       "The package `dmdScheme` wants to create and write into the directory/n",
  #       "    ", path, "\n",
  #       "tp store installed schemes there.\n",
  #       "This is necessary to install additional scheme definitions.\n",
  #       "You have to confirm to continue."
  #       )
  #   )
  #   if (!isTRUE(ok)) {
  #     stop("Can not continue. Need write to cache directory!")
  #   }
  # }
  ##
  if (delete) {
    unlink(path, recursive = TRUE, force = TRUE)
    path <- NULL
  }
  if (create) {
    dir.create(path, recursive = TRUE,showWarnings = FALSE)
  }
  return(path)
}
