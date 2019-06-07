#' Create new package containg the definitions for new domain metadata scheme.
#'
#' A new metadata scheme can be created as a package Depending on
#' \code{dmdScheme}. This function uses the function \code{package.skelleton()}
#' to create a new directory for the new metadata scheme, imports the scheme
#' and adds some functions which make working easier.
#' @param schemeDefinition \code{xlsx} Excel file containing the definition of
#'   the metadata scheme
#' @param path path where the package should be created. Defeoult is the current working directory
#'
#' @return invisibly \code{NULL}
#'
#' @importFrom utils package.skeleton
#' @export
#'
#' @examples
#' \dontrun{
#' make_new_scheme(
#'   schemeDefinition = "./../emeScheme/emeScheme.xlsx",
#'   path = tempdir()
#' )
#' }
make_new_scheme <- function(
  schemeDefinition,
  path = "."
){
  oldwd <- getwd()
  on.exit(
    {
      setwd(oldwd)
      if (!success) {
        unlink(
          x = file.path(path, schemeName),
          recursive = TRUE,
          force = TRUE
        )
      }
    }
  )
  ##
  schemeDefinition <- normalizePath(schemeDefinition)

  success <- FALSE

  # Extract name and version of scheme --------------------------------------

  v <- readxl::read_excel(path = schemeDefinition, sheet = "Experiment") %>%
    names() %>%
    grep("DATA", ., value = TRUE) %>%
    strsplit(" ")
  schemeName <- v[[1]][2]
  schemeVersion <- gsub("v", "", v[[1]][3])

  # Create package skeleton -------------------------------------------------

  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  utils::package.skeleton(
    name = schemeName,
    force = FALSE,
    path = path
  )

  # Add info to DECRIPTION file ---------------------------------------------

  cat(
    "LazyData: true",
    "Depends: dmdScheme",
    paste0("schemeName: ",    schemeName ),
    paste0("schemeVersion: ", schemeVersion),
    paste0("schemeUpdate: EMPTY"),
    paste0("schemeMD5: EMPTY"),
    "\n",
    sep = "\n",
    file = file.path(path, schemeName, "DESCRIPTION"),
    append = TRUE
  )
  ##

  setwd(file.path(path, schemeName))
  ##
  update_from_new_sheet(
    newDmdScheme = schemeDefinition,
    updateSchemeVersion = TRUE,
    updatePackageName = TRUE
  )
  ##
  success <- TRUE
  invisible(NULL)
}
