#' Functions to manage schemes
#'
#' @param schemeDefinition path to the \code{.xlsx} fle containing the \bold{definition} of the scheme as well as the \bold{example}
#' @param path where the final scheme definition should be created.
#' @param overwrite if \code{TRUE}, the scheme definition in \code{path} will be overwritten.
#'
#' @importFrom utils write.table
#'
#' @return fully qualified path to the created scheme
#' @export
#'
scheme_make <- function(
  schemeDefinition,
  path = ".",
  overwrite = FALSE
){

  scheme <- as_dmdScheme(
    read_excel_raw(
      file = schemeDefinition,
      checkVersion = FALSE
    ),
    checkVersion = FALSE,
    keepData = TRUE
  )

  name <- attr(scheme, "dmdSchemeName")
  version <- attr(scheme, "dmdSchemeVersion")
  schemeName <- paste0(name, "_", version)

  if (file.exists(file.path(path, paste0(schemeName, ".tar.gz")))) {
    if (!overwrite) {
      stop("Output file exists! To overwrite it, specify `overwrite = TRUE`!")
    }
  }

  # assemble package --------------------------------------------------------

  rootpath <- tempfile()
  tmppath <- file.path(rootpath, schemeName)
  dir.create(tmppath, recursive = TRUE)

  file.copy(schemeDefinition, tmppath)

  write_xml(
    x = scheme,
    file = file.path(tmppath, paste0(schemeName, ".xml")),
    output = "complete"
  )

# build package -----------------------------------------------------------

  md5 <- md5sum(list.files(tmppath, full.names = TRUE))
  names(md5) <- basename(names(md5))

  utils::write.table(md5, file.path(tmppath, "md5sum.txt"))

  oldwd <- setwd(rootpath)
  try(
    utils::tar(
      tarfile = file.path(rootpath, paste0(schemeName, ".tar.gz")),
      files = schemeName,
      compression = "gzip"
    )
  )
  setwd(oldwd)


  # move definition and return ----------------------------------------------

  file.copy(
    from = file.path(rootpath, paste0(schemeName, ".tar.gz")),
    to = file.path(path, paste0(schemeName, ".tar.gz"))
  )

  return(file.path(path, paste0(schemeName, ".tar.gz")))
}
