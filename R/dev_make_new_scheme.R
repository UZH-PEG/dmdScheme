#' Create anew package skelleton containg the definitions for new domain metadata scheme.
#'
#' **This function is not for the user of a scheme, but for the development process of a new scheme.**
#'
#' A new metadata scheme can be created as a package which will depend on
#' \code{dmdScheme}. This function uses the function `package.skeleton()` from
#' the `utils` package to create a new directory for the new metadata scheme,
#' imports the scheme as defined in `schemeDefinition` and adds some functions
#' which make working with the new scheme easier. For a documentation of
#' the workflow to create a new scheme, see the
#' vignette **Howto Create a new scheme**.
#' @param schemeDefinition \code{xlsx} Excel file containing the definition of
#'   the metadata scheme. The version and the scheme name should be edited
#'   before the spreadsheet is used here.
#' @param path path where the package should be created. Default is the current
#'   working directory.
#'
#' @return invisibly \code{NULL}
#'
#' @importFrom utils package.skeleton
#' @export
#'
#' @md
#'
#' @examples
#' \dontrun{
#' dev_make_new_scheme(
#'   schemeDefinition = "./../emeScheme/emeScheme.xlsx",
#'   path = tempdir()
#' )
#' }
dev_make_new_scheme <- function(
  schemeDefinition,
  path = "."
){
  oldwd <- getwd()
  schemeName <- NULL
  success <- FALSE
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

  # Copy new scheme to the inst directory -----------------------------------

  dir.create( file.path(path, schemeName, "inst"), showWarnings = FALSE)
  file.copy(
    from = schemeDefinition,
    to = file.path(path, schemeName, "inst", paste0(schemeName, ".xlsx"))
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

# Update from new sheet ---------------------------------------------------

  dev_update_from_new_sheet(
    newDmdScheme = schemeDefinition,
    updateSchemeVersion = TRUE,
    updatePackageName = TRUE
  )
  ##
  success <- TRUE
  invisible(NULL)
}
