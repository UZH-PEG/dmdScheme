#' Update data from dmdScheme.xlsx --- ONLY FOR DEVLOPMENT NEEDED
#'
#' Update the data from the file \code{file.path( ".", "inst",
#' "dmdScheme.xlsx")} and bump the version in the DESCRIPTION if it has changed.
#' @param newDmdScheme xlsx spreadsheet containing the new \code{dmdScheme}
#'   definition has the same md5 suma s in the DESCRIPTION
#' @param updateSchemeVersion if \code{TRUE}, the field \code{dmdSchemeVersion}
#'   in the DESCRIPOTION file is updated. Default: \code{TRUE}
#' @param updatePackageName if \code{TRUE}, the field \code{Package} in the
#'   DESCRIPOTION file is updated. This should be used with caution, as it might
#'   need other changes in the poackage. Only useful for the first import.
#'   Default: \code{FALSE}
#'
#' @return invisibly NULL
#'
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom tools md5sum
#'
updateFromNewSheet <- function(
  newDmdScheme,
  updateSchemeVersion = TRUE,
  updatePackageName = FALSE
) {

# Helper functions --------------------------------------------------------

  # saveToData <- function(schemeName, data) {
  #   rdataFile <- paste0(schemeName, ".rda")
  #   ## Assign data to the name saved in schemeName
  #   assign(x = schemeName, value = data)
  #   ## Save as RData file
  #   save(list = schemeName, file = file.path( ".", "data", rdataFile))
  #   cat(
  #     "load(\"./", rdataFile, "\")", sep = '',
  #     file = file.path( ".", "data", paste0(schemeName, ".R"))
  #   )
  # }

# Main --------------------------------------------------------------------


  message(
    "##########################################################\n",
    "## This function is only to be used during development  ##\n",
    "## from within the root directory of the package.       ##\n",
    "## There is absolutely not reason, why you should call  ##\n",
    "## this function as a user of the package.              ##\n",
    "##                                                      ##\n",
    "## If you are calling this function as a non developer, ##\n",
    "## it will likely result in an error!                   ##\n",
    "##########################################################\n",
    "\n"
  )

  # read file and extract scheme and version --------------------------------

  message("##### Loading ", newDmdScheme, "...")

  dmdScheme_raw <- read_from_excel_raw(
    file = newDmdScheme,
    keepData = FALSE,
    verbose = TRUE,
    checkVersion = FALSE
  )

  schemeName <- attr(dmdScheme_raw, "propertyName")
  schemeVersion <- attr(dmdScheme_raw, "dmdSchemeVersion")

  # prepare update ----------------------------------------------------------

  message("##### Preparing update...")
  ##
  dir.create("data", showWarnings = FALSE)
  dir.create("inst", showWarnings = FALSE)
  dir.create(file.path("tests", "testthat"), showWarnings = FALSE, recursive = TRUE)
  sheet <- file.path(".", "inst", paste0(schemeName, ".xlsx"))

  # Updata dmdScheme.xlsx ---------------------------------------------------

  message("##### Updating ", sheet, "...")
  ##
  file.copy(
    from = newDmdScheme,
    to = sheet,
    overwrite = TRUE
  )

  # update data/dmdScheme_raw -----------------------------------------------

  message("##### Generating ", schemeName, "_raw...")
  ##
  varName <- paste0(schemeName, "_raw")
  fileName <- file.path(".", "data", paste0(varName, ".rda") )
  assign(
    x = varName,
    value = dmdScheme_raw
  )
  save( list = varName, file = fileName)

  # update data/dmdScheme -----------------------------------------------

  message("##### Generating ", schemeName, "...")
  ##
  dmdScheme <- new_dmdSchemeSet(
    x = dmdScheme_raw,
    keepData = FALSE,
    verbose = TRUE
  )
  ##
  varName <- paste0(schemeName)
  fileName <- file.path(".", "data", paste0(varName, ".rda") )
  assign(
    x = varName,
    value = dmdScheme
  )
  save( list = varName, file = fileName)

  # update data/dmdScheme_exmple ----------------------------------------

  message("##### Generating ", schemeName, "_example...")
  ##
  dmdScheme_example <- new_dmdSchemeSet(
    x = dmdScheme_raw,
    keepData = TRUE,
    verbose = TRUE
  )
  ##
  varName <- paste0(schemeName, "_example")
  fileName <- file.path(".", "data", paste0(varName, ".rda") )
  assign(
    x = varName,
    value = dmdScheme_example
  )
  save( list = varName, file = fileName)

  # Update dmdScheme.xml files -----------------------------------------------

  fp <- file.path( ".", "inst", paste0(schemeName, "_example.xml") )
  message("##### Generating ", fp, ".xml...")
  ##
  dmdSchemeToXml(
    x = dmdScheme_example,
    file = fp,
    output = "metadata"
  )

  # update tests/testthat/dmdScheme.xlsx ------------------------------------

  fp <- file.path( ".", "tests", "testthat", paste0(schemeName, ".xlsx") )
  message("##### Generating ", fp, "...")
  ##
  file.copy(
    sheet,
    fp,
    overwrite = TRUE
  )

  # update exported xml in tests/testthat/*.xml -----------------------------

  fp <- file.path( ".", "tests", "testthat", paste0(schemeName, "_example.xml") )
  message("##### Generating ", fp, "...")
  ##
  dmdSchemeToXml(
    x = dmdScheme_example,
    file = fp
  )

  # Set info in DESCRIPTION file --------------------------------------------

  message("##### Updating DESCRIPTION...")
  ## read old DESCRIPION file
  DESCRIPTION <- read.dcf("DESCRIPTION")
  ## set dmdSchemeVersion
  if (updatePackageName)   {
    DESCRIPTION[ 1, "Package"       ] <-  schemeName
  }
  if (updatePackageName)   {
    DESCRIPTION[ 1, "schemeName"    ] <-  schemeName
  }
  if (updateSchemeVersion) {
    DESCRIPTION[ 1, "schemeVersion" ] <-  schemeVersion
  }
  ## set Update info
  DESCRIPTION[ 1, paste0("schemeUpdate") ] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  DESCRIPTION[ 1, paste0("schemeMD5")    ] <- tools::md5sum(sheet)
  ## write new DESCRIPTION
  write.dcf(DESCRIPTION, "DESCRIPTION")

  # Return invisibble NULL --------------------------------------------------------

  invisible(NULL)
}
