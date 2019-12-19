#' Download scheme definition from url
#'
#'
#'  \bold{\code{scheme_download()}:} Scheme definitions can be stored in an online repo. The default is a github
#' repo at \url{https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository}. This
#' function dowloads a scheme definition, specified by \code{name} and
#' \code{version}, and saves it locally under the name \code{destfile}
#' @param destfile a \code{character} string containing the name of the
#'   downloaded scheme definition. If \code{NULL}, a temporary file will be used.
#' @param baseurl a \code{character} string containing the base url of the
#'   repository in which the scheme definitions are located.
#' @param ... additional parameter for the function \code{download.file}.
#'
#' @return invisibly the value of \code{destfile}
#'
#' @rdname scheme
#'
#' @importFrom utils download.file
#' @export
#'
#' @examples
#' scheme_download(
#'   name = "dmdScheme",
#'   version = "0.9.5"
#' )
scheme_download <- function(
  name,
  version,
  destfile = NULL,
  overwrite = FALSE,
  baseurl = scheme_repo(),
  ...
) {

  if (is.null(destfile)) {
    path <- tempfile()
    dir.create(path)
    destfile <- file.path(path, paste0(name, "_", version, ".tar.gz"))
  } else {
    destfile <- normalizePath(destfile)
  }

  if ( file.exists(destfile) & (!overwrite) ) {
    stop("destfile does exist!\n", "  Use `overwrite = TRUE` to overwrite destfile.")
  }

  url <- paste0(
    baseurl,
    "schemes/",
    name, "_", version, ".tar.gz"
  )

  result <- utils::download.file( url = url, destfile = destfile, ...)

  if (result != 0) {
    stop("Download not successfull. Return value from `download.file() = `", result)
  }

  return(invisible(destfile))
##
}
