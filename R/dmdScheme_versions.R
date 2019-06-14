#' Returns versions of package and dmdScheme
#'
#' The versions of the \code{scheme} and version of the \code{package} are
#' retrieved from the installed scheme as specified by the argument
#' \code{schemeName}.
#' @param schemeName name of the scheme. This can be used when more than one
#'   scheme is installed, to query the versions of a specific scheme.
#'
#' @return a named \code{list}, containing the following objects:
#' \itemize{
#'   \item{package}{ containing an object of length on of type \code{package_version} with the version of the package}
#'   \item{dmdScheme}{ containing an object of length on of type \code{numeric_version} with the version of the metadata scheme dmdScheme}
#' }
#'
#' @importFrom utils packageDescription
#' @export
#'
#' @examples
#' dmdScheme_versions()
#' dmdScheme_versions(schemeName = "dmdScheme")
dmdScheme_versions <- function (
  schemeName = "dmdScheme"
)
{
  pkg = schemeName
  res <- suppressWarnings(
    utils::packageDescription(
      pkg,
      fields = c( "schemeName", "Version", "schemeVersion" )
    )
  )
  res <- list(
    name = res[["schemeName"]],
    package = package_version(res[["Version"]]),
    scheme = numeric_version(res[["schemeVersion"]])
  )
  return(res)
}
