#' Download scheme definition from url
#'
#'
#'  \bold{\code{scheme_repo()}:} Get or set scheme repository. If \code{repo} is specified, the scheme
#' repository to be used is set. Otherwise, the scheme repository used is only
#' returned.
#'
#' @return URL of the repo toi be used. If not set previously, the default repo
#'   at \url{https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/} is
#'   used.
#'
#' @rdname scheme
#'
#' @export
#'
#' @examples
#' # returns the repo used:
#' scheme_repo()
scheme_repo <- function(
  repo = NULL
) {
  if (!is.null(repo)) {
    assign(
      x = "default_schemeRepo",
      value = "https://github.com/Exp-Micro-Ecol-Hub/dmdSchemeRepository/raw/master/",
      envir = .dmdScheme_cache
    )
  }

  repo <- get("default_schemeRepo", envir = .dmdScheme_cache)


  return(repo)
##
}
