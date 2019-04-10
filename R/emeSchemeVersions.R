#' Returns versions of package and emeScheme
#'
#' @param lib.loc a character vector of directory names of R libraries, or NULL.
#'   The default value of NULL corresponds to all libraries currently known. If
#'   the default is used, the loaded packages and namespaces are searched before
#'   the libraries.
#'
#' @return a named \code{list()}, containing the following objects:
#' \itemize{
#'   \item{package}{ containing an object of length on of type \code{package_version} with the version of the package}
#'   \item{emeScheme}{ containing an object of length on of type \code{numeric_version} with the version of the metadata scheme emeScheme}
#' }
#'
#' @importFrom utils packageDescription
#' @export
#'
#' @examples
#' emeSchemeVersions()
emeSchemeVersions <-function (
  lib.loc = NULL
)
{
  pkg = "emeScheme"
  res <- suppressWarnings(
    packageDescription(
      pkg,
      lib.loc = lib.loc,
      fields = c( "Version", "emeSchemeVersion")
    )
  )
  res <- list(
    package = package_version(res$Version),
    emeScheme = numeric_version(res$emeSchemeVersion)
  )
  return(res)
}
