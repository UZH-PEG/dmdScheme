#' Functions to manage schemes
#'
#' @param schemeDefinition path to the \code{.xlsx} file containing the
#'   \bold{definition} of the scheme as well as the \bold{example}
#' @param examples character vector of directories which should be included as
#'   examples. The name of the director will be the name of the example. The
#'   example can contain a file with the name \code{EXAMPLENAME.html} where
#'   \code{EXAMPLENAME} is the name of the folder. This html will abe
#'   automatically opened when calling \code{make_example("EXAMPLENAME")}
#'   Otherwise there are no restrictions to formats.
#' @param install_R_package path to the R script to install the R package. If \code{NULL},
#'   no command is given.
#' @param path where the final scheme definition should be created.
#' @param overwrite if \code{TRUE}, the scheme definition in \code{path} will be
#'   overwritten.
#' @param index_template the index template file which can be added
#'
#' @importFrom utils write.table
#' @importFrom tools md5sum
#'
#' @return fully qualified path to the created scheme
#' @export
#'
scheme_make <- function(
  schemeDefinition,
  examples = NULL,
  install_R_package = NULL,
  path = ".",
  overwrite = FALSE,
  index_template = NULL
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

  file.copy(
    from = schemeDefinition,
    to = file.path(tmppath, paste0(schemeName, ".xlsx"))
  )

  write_xml(
    x = scheme,
    file = file.path(tmppath, paste0(schemeName, ".xml")),
    output = "complete"
  )

  tmpExamples <- file.path(tmppath, "examples")
  dir.create( tmpExamples )
  for (exdir in examples) {
    file.copy(
      from = exdir,
      to = file.path(tmpExamples),
      recursive = TRUE
    )
  }

  if (!is.null(index_template)) {
    file.copy(
      from = index_template,
      to = file.path(tmppath, paste0("index.", file_ext(index_template)))
    )
  }

  if (!is.null(install_R_package)) {
    file.copy(
      from = install_R_package,
      to = file.path(tmppath, "install_R_package.R"))
  }

  # build package -----------------------------------------------------------

  writeLines(version, file.path(tmppath, "schemePackageVersion"))

  md5 <- tools::md5sum( list.files(tmppath, recursive = TRUE, full.names = TRUE) )
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
    to = file.path(path, paste0(schemeName, ".tar.gz")),
    overwrite = overwrite
  )

  return(file.path(path, paste0(schemeName, ".tar.gz")))
}
