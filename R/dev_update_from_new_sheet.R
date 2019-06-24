#' Update scheme definitiuon in the scheme definition package in the working directory
#'
#' **This function is not for the user of a scheme, but for the development process of a new scheme.**
#'
#' Update the data in the source package in the current working directory with the new scheme definition as specified in the `newDmdScheme` spreadsheet.
#' It will
#'   * save a new scheme definition, scheme example and scheme raw data files and the xlsx file
#'   * create a versioned copy of the old `.xlsx` file if the version has changed
#'   * create a backup of the old `.xlsx` file with the extension `.xlsx.bak` (should be deleted before final packaging)
#'   * update the example `.xml` file
#'   * update the corresponding files for tests
#'   * in the `DESCRIPTION` file
#'       * set `schemeUpdate` to the current date and time
#'       * set `schemeMD5` to the MD% checksum of the `newDmdScheme` file
#'       * if `updateSchemeVersion == TRUE`
#'           * set `schemeVersion` as defined in `newDmdScheme`
#'       * if `updatePackageName == TRUE`
#'           * set `schemeName` as defined in `newDmdScheme`
#'           * set `Package` as defined in `newDmdScheme`
#'
#' @param newDmdScheme xlsx spreadsheet containing the new `dmdScheme`
#'   definition
#' @param updateSchemeVersion if `TRUE`, the field `dmdSchemeVersion`
#'   in the `DESCRIPTION` file is updated.
#' @param updatePackageName if `TRUE`, the field `Package` as well as `schemeName` in the
#'   DESCRIPOTIN file is updated. This should be used with caution, as it might
#'   need other changes in the poackage.
#'
#' @return invisibly NULL
#'
#' @md
#'
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom tools md5sum
#' @importFrom readxl read_excel
#'
dev_update_from_new_sheet <- function(
  newDmdScheme,
  updateSchemeVersion = TRUE,
  updatePackageName = FALSE
) {

  message(
    "\n",
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
  if (!file.exists(sheet)) {
    stop("So,ething is wrong here - the file ", sheet, " does not exist although it should!!!")
  }
  sheet_versioned <- file.path(".", "inst", paste0(schemeName, ".", as.character(dmdScheme_versions()[["scheme"]]), ".xlsx"))

  # Create backup of scheme -------------------------------------------------

  message("##### Creating backup of ", sheet, "...")
  file.copy(
    from = sheet,
    to = paste(sheet, "bak"),
    overwrite = TRUE
  )

  # Create scheme version numbered backup -----------------------------------

  message("##### Creating versioned copy ", sheet_versioned, "...")
  ##
  if (file.exists(sheet_versioned)) {
    message("## versioned copy ", sheet_versioned, " exists. Keeping old versioned copy. ##")
  } else {
    message("## creating versioned copy ", sheet_versioned, " ##")
    file.copy(
      from = sheet,
      to = sheet_versioned,
      overwrite = FALSE
    )
  }

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
  dmdScheme <- new_dmdScheme(
    x = dmdScheme_raw,
    keepData = FALSE,
    verbose = TRUE,
    checkVersion = FALSE
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
  dmdScheme_example <- new_dmdScheme(
    x = dmdScheme_raw,
    keepData = TRUE,
    verbose = TRUE,
    checkVersion = FALSE
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
  dmdScheme_to_xml(
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
  dmdScheme_to_xml(
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

  message("IMPORTANT:\n\n", "Reload the package with `devtools::load_all() to finalise the import!\n\n")

  invisible(NULL)
}
