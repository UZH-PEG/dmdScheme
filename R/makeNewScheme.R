#' Create new package containg the definitions for new domain metadata scheme.
#'
#' A new metadata scheme can be created as a package Depending on
#' \code{dmdScheme}. This function uses the function \code{package.skelleton()}
#' to create a new directory for the new metadata scheme, imports the scheme
#' and adds some functions which make working easier.
#' @param schemeName name of the scheme you want to use and name of the
#'   resulting package skelleton
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
#' makeNewScheme(
#'   schemeName = "testScheme",
#'   schemeDefinition = "./../emeScheme/emeScheme.xlsx",
#'   path = tempdir()
#' )
#' }
makeNewScheme <- function(
  schemeName,
  schemeDefinition,
  path = "."
){
  oldwd <- getwd()
  on.exit(
    {
      setwd(oldwd)
    }
  )
  ##
  schemeDefinition <- normalizePath(schemeDefinition)
  ##
  utils::package.skeleton(
    name = schemeName,
    force = FALSE,
    path = path
  )
  ##
  cat(
    "Depends: dmdScheme",
    paste0(schemeName, "Version: 0.1"),
    paste0(schemeName, "Update: EMPTY"),
    paste0(schemeName, "MD5: EMPTY"),
    "\n",
    sep = "\n",
    file = file.path(path, schemeName, "DESCRIPTION"),
    append = TRUE
  )
  ##
  setwd(file.path(path, schemeName))
  ##
  updateFromNewSheet(
    newDmdScheme = schemeDefinition,
    schemeName = schemeName
  )
  ##
  invisible(NULL)
}
