#' Functions to manage schemes
#'
#' \bold{\code{scheme_install_r_package()}:} Install R package for scheme
#' \code{name} \code{version} definition using the script
#' \code{install_R_package.R} in the scheme package.
#' @param reinstall if \code{TRUE}, the R package will be uninstalled before
#'   installing it.
#'
#' @return invisibly \code{NULL}
#'
#' @rdname scheme
#'
#' @importFrom utils installed.packages remove.packages
#' @export
#'
#' @examples
#' \dontrun{
#' scheme_install_r_package()
#' }
#'
scheme_install_r_package <- function(
  name,
  version,
  reinstall = FALSE
){
  script <- file.path(
    cache("installedSchemes", paste0(name, "_", version), createPermanent = FALSE),
    "install_R_package.R"
  )
  if (file.exists(script)) {
    installed <- system.file(package = name) != ""
    if (installed) {
      if (reinstall) {
        utils::remove.packages("name")
      } else {
        message(
          "Package ", name, " is already installed!\n",
          "To re-install or update, please specify `reinstall = TRUE`"
        )
      }
    } else {
      source(script, echo = TRUE)
    }

  }


  invisible( NULL )
}
