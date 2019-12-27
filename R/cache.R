#' Return cache directory
#'
#' If the cache folder does not exist, and \code{createPermanent = FALSE}, a temporary location is used. To make the cache permanent, call
#'
#' \code{cache(createPermanent = TRUE)}
#'
#' and restart your R session.
#' @param ... sub caches
#' @param delete if \code{TRUE}, the cache directory will be deleted.
#' @param createPermanent if \code{TRUE}, the folder will be created. This is done, when
#'   \code{delete = TRUE} after deleting the directory.
#'
#' @return fully qualified path to the cache folder
#'
#' @importFrom rappdirs user_config_dir
#' @export
#'
cache <- function(
  ...,
  delete = FALSE,
  createPermanent = FALSE
) {
  basedirConfig <- rappdirs::user_config_dir(appname = "dmdScheme", appauthor = "dmdScheme")
  if (createPermanent) {
    if (!dir.exists(basedirConfig)) {
      dir.create(
        basedirConfig,
        recursive = TRUE,
        showWarnings = FALSE
      )
      message(
        "\n",
        "#############################################\n",
        "Permanent cache created at\n",
        "   ", basedirConfig, "\n",
        "You have to restart R to use this cache!\n",
        "#############################################\n",
        "\n"
      )
    }
  } else {
    if (exists("basedirConfig", envir = .dmdScheme_cache)) {
      basedirConfig <- get("basedirConfig", envir = .dmdScheme_cache)
    } else {
      if (dir.exists(basedirConfig)) {
        assign("basedirConfig", basedirConfig, envir = .dmdScheme_cache)
      } else {
        basedirConfig <- tempfile(pattern = "dmdScheme_" )
        dir.create(
          basedirConfig,
          recursive = TRUE,
          showWarnings = FALSE
        )
        assign("basedirConfig", basedirConfig, envir = .dmdScheme_cache)
        message(
          "\n",
          "#############################################\n",
          "The cache will be in a temporary location and be deleted when you quit R.\n",
          "It is located at\n",
          "   ", basedirConfig, "\n",
          "To make it permanent, call\n",
          "   cache(createPermanent = TRUE)\n",
          "and restart R\n",
          "and a permanent cache will be created which will survive restarts.\n",
          "#############################################\n",
          "\n"
        )
      }
    }
  }
  ##

  path <- file.path(
    basedirConfig,
    ...
  )

  if (delete) {
    unlink(path, recursive = TRUE, force = TRUE)
    path <- NULL
  }
  #
  return(path)
}
