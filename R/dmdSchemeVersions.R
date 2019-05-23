#' Returns versions of package and dmdScheme
#'
#' @param lib.loc a character vector of directory names of R libraries, or NULL.
#'   The default value of NULL corresponds to all libraries currently known. If
#'   the default is used, the loaded packages and namespaces are searched before
#'   the libraries.
#' @param schemeName name of the scheme. Default: dmdScheme. Only for developing new schemes needed.
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
  schemeName = "dmdScheme",
  lib.loc = NULL
)
{
  pkg = schemeName
  res <- suppressWarnings(
    packageDescription(
      pkg,
      lib.loc = lib.loc,
      fields = c( "Version", paste0(schemeName, "Version") )
    )
  )
  res <- list(
    name = schemeName,
    package = package_version(res[["Version"]]),
    scheme = numeric_version(res[[paste0(schemeName, "Version")]])
  )
  return(res)
}
