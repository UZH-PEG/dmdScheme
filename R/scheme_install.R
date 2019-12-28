#' Functions to manage schemes
#'
#' \bold{\code{scheme_install()}:} Installed schemes are copied to
#' \code{cache("installedSchemes")} and , if necessary, an \code{.xlsx}
#' definition is saved in addition. These can be listed by using
#' \link{scheme_list}.
#' @param repo repo of the schemes.
#' @param file if give, this file will be used as the local scheme definition,
#'   and \code{repo} will be ignored
#' @param overwrite if \code{TRUE}, the scheme will be overwritten if it exists
#' @param install_package if \code{TRUE}, install / update the accompanying R
#'   package. You can do it manually later by running
#'   \code{scheme_install_r_package("NAME", "VERSION")}.
#'
#' @return invisibly \code{NULL}
#'
#' @rdname scheme
#'
#' @importFrom utils untar
#' @importFrom tools file_path_sans_ext
#'
#' @export
#'
#' @examples
#' \dontrun{
#' scheme_install("path/to/definition.xml")
#' scheme_install("path/to/definition.xlsx")
#' }
#'
scheme_install <- function(
  name,
  version,
  repo = scheme_repo(),
  file = NULL,
  overwrite = FALSE,
  install_package = FALSE
){

  if (!is.null(file)) {
    if (!file.exists(file)) {
      stop("schemeDefinition as specified in `file` does not exist!")
    }
    schemeName <- file %>%
      basename() %>%
      tools::file_path_sans_ext() %>%
      tools::file_path_sans_ext()
    name <- strsplit(schemeName, "_")[[1]][[1]]
    version <- strsplit(schemeName, "_")[[1]][[2]]
    rm(schemeName)
  }

  if ( scheme_installed(name, version) ) {
    if (!overwrite) {
      stop("Scheme is already installed! Use `overwrite = TRUE` if you want to overwrite it!")
    }
  }

  # Download when rep == NULL -----------------------------------------------

  if (!is.null(file)) {
    schemeDefinition <- file
  } else {
    schemeDefinition <- scheme_download(
      name = name,
      version = version,
      baseurl = repo
    )
  }

  # untar and install scheme definition -------------------------------------

  if (!file.exists(schemeDefinition)) {
    stop("schemeDefinition does not exist!")
  }

  utils::untar(
    tarfile = schemeDefinition,
    exdir = cache("installedSchemes", createPermanent = FALSE)
  )


  # install R package -------------------------------------------------------

  if (install_package) {
    scheme_install_r_package( name = name, version = version, reinstall = overwrite)
  }

  # Return ------------------------------------------------------------------

  message(
    "Scheme definition `", schemeDefinition, ", installed with\n",
    "name:    ", name, "\n",
    "version: ", version
  )

  invisible( NULL )
}
