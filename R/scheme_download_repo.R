#' Download scheme definition from repo
#'
#'
#' Scheme definitions can be stored in an online repo. The default is a github
#' repo at \url{https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository}. This
#' function dowloads a scheme definition, specified by \code{name} and
#' \code{version}, and saves it locally under the name \code{destfile}
#' @param destfile a \code{character} string containing the name of the
#'   downloaded scheme definition
 #' @param baseurl a \code{character} string containing the base url of the
#'   directory where the scheme definitions are located.
#' @param ... additional parameter for the function \code{download.file}.
#'
#' @return return An invisibleinteger value, \code{0} indicating success,
#'   noon-zero indicates an error. See \link{download.file} for details.
#'
#' @rdname scheme
#'
#' @importFrom utils download.file
#' @export
#'
#' @examples
#' scheme_download_repo(
#'   name = "dmdScheme",
#'   version = "0.9.5",
#'   type = "xml",
#'   destfile = tempfile()
#' )
scheme_download_repo <- function(
  name,
  version,
  type = "xlsx",
  destfile = paste0(name, "_", version, ".", type),
  overwrite = FALSE,
  baseurl = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/schemes/",
  ...
) {

  if ( file.exists(destfile) & (!overwrite) ) {
    stop("destfile does exist!\n", "  Use `overwrite = TRUE` to overwrite destfile.")
  }

  url <- paste0(
    baseurl,
    name, "_", version, ".", type
  )
  utils::download.file( url = url, destfile = destfile, ...)
##
}
