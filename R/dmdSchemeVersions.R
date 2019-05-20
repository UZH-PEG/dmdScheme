#' Returns versions of package and dmdScheme
#'
#' @param lib.loc a character vector of directory names of R libraries, or NULL.
#'   The default value of NULL corresponds to all libraries currently known. If
#'   the default is used, the loaded packages and namespaces are searched before
#'   the libraries.
#'
#' @return a named \code{list()}, containing the following objects:
#' \itemize{
#'   \item{package}{ containing an object of length on of type \code{package_version} with the version of the package}
#'   \item{dmdScheme}{ containing an object of length on of type \code{numeric_version} with the version of the metadata scheme dmdScheme}
#' }
#'
#' @importFrom utils packageDescription
#' @export
#'
#' @examples
#' dmdSchemeVersions()
dmdSchemeVersions <-function (
  lib.loc = NULL
)
{
  pkg = "dmdScheme"
  res <- suppressWarnings(
    packageDescription(
      pkg,
      lib.loc = lib.loc,
      fields = c( "Version", "dmdSchemeVersion")
    )
  )
  res <- list(
    package = package_version(res$Version),
    dmdScheme = numeric_version(res$dmdSchemeVersion)
  )
  return(res)
}
