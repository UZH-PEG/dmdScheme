#' Returns versions of package and loaded dmdScheme
#'
#' The \code{name} and \code{version} of the \code{scheme}are retrieved from the
#' loadeed scheme (\code{scheme_use()}), therefore can change when a different
#' scheme is used. The version of the \code{package} is specific to the package.
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
dmdScheme_versions <- function(){
  result <- list(
    name = attr(dmdScheme, "dmdSchemeName"),
    scheme = numeric_version(attr(dmdScheme, "dmdSchemeVersion")),
    package = package_version(
      utils::packageDescription(
        pkg = "dmdScheme",
        fields = "Version"
      )
    )
  )
  return(result)
}
