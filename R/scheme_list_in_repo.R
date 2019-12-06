#' Download list of available scheme definitions from repository
#'
#'
#' Scheme definitions can be stored in an online repo.
#' @return Returns the info about the scheme definitions in this repo as a \code{list}.
#'
#' @rdname scheme
#'
#' @importFrom utils download.file
#' @export
#'
#' @examples
#' scheme_list_in_repo()
#'
scheme_list_in_repo <- function(
  baseurl = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/",
  ...
) {

  destfile <- tempfile(fileext = ".yaml")

  url <- paste0(
    baseurl,
    "schemes/SCHEME_DEFINITIONS.yaml"
  )

  result <- utils::download.file( url = url, destfile = destfile, ...)

  if (result != 0) {
    stop("Download not successfull. Return value from `download.file() = `", result)
  }

  result <- yaml::read_yaml(destfile)

  rm(destfile)

  return(result)
##
}
