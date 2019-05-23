#' Update data from dmdScheme.xlsx --- ONLY FOR DEVLOPMENT NEEDED
#'
#' Update the data from the file \code{here::here("inst", "dmdScheme.xlsx")}
#' and bump the version in the DESCRIPTION if it has changed.
#' @param newDmdScheme xlsx spreadsheet containing the new \code{dmdScheme} definition
#' @param schemeName name of the scheme. Default: dmdScheme. SHould be changed because of readability!
#' @param force force update even if \code{here::here("inst", "dmdScheme.xlsx")}
#'   has the same md5 suma s in the DESCRIPTION
#'
#' @return invisibly NULL
#'
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom tools md5sum
#'
updateFromNewSheet <- function(
  newDmdScheme,
  force = FALSE,
  schemeName = "dmdScheme"
) {

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

  # prepare update ----------------------------------------------------------

  sheet <- here::here("inst",  paste0(schemeName, ".xlsx"))

  # Updata dmdScheme.xlsx ---------------------------------------------------

  file.copy(
    from = newDmdScheme,
    to = sheet,
    overwrite = TRUE
  )

  # update data/dmdScheme_raw -----------------------------------------------

  message("##### Generating ", schemeName, "_raw...")

  dmdScheme_raw <- read_from_excel(
    file = sheet,
    keepData = FALSE,
    verbose = TRUE,
    raw = TRUE,
    validate = FALSE,
    schemeName = schemeName
  )
  ##
  rdsFile <- paste0(schemeName, "_raw.rds")
  varName <- paste0(schemeName, "_raw")
  saveRDS(
    dmdScheme_raw,
    file = here::here( "data", rdsFile )
  )
  cat(
    paste0(varName, " <- readRDS(\"./", rdsFile, "\")"),
    file = here::here( "data", paste0(varName, ".R") )
  )

  # update data/dmdScheme -----------------------------------------------

  message("##### Generating dmdScheme...")
  dmdScheme <- new_dmdSchemeSet(
    x = dmdScheme_raw,
    keepData = FALSE,
    verbose = TRUE
  )
  ##
  rdsFile <- paste0(schemeName, ".rds")
  varName <- paste0(schemeName)
  saveRDS(
    dmdScheme,
    file = here::here( "data", rdsFile )
  )
  cat(
    paste0(varName, " <- readRDS(\"./", rdsFile, "\")"),
    file = here::here( "data", paste0(varName, ".R") )
  )

  # update data/dmdScheme_exmple ----------------------------------------

  message("##### Generating dmdScheme_example...")
  dmdScheme_example <- new_dmdSchemeSet(
    x = dmdScheme_raw,
    keepData = TRUE,
    verbose = TRUE
  )
  ##
  rdsFile <- paste0(schemeName, "_example.rds")
  varName <- paste0(schemeName, "_example")
  saveRDS(
    dmdScheme_example,
    file = here::here( "data", rdsFile )
  )
  cat(
    paste0(varName, " <- readRDS(\"./", rdsFile, "\")"),
    file = here::here( "data", paste0(varName, ".R") )
  )

  # Update dmdScheme.xml files -----------------------------------------------

  message("##### Generating dmdScheme_example.xml...")

  dmdSchemeToXml(
    x = dmdScheme_example,
    file = here::here( "inst", paste0(schemeName, "_example.xml") ),
    output = "metadata"
  )

  # bump version and change description in DECRIPTION -----------------------

  ## read old DESCRIPION file
  DESCRIPTION <- read.dcf(here::here("DESCRIPTION"))
  ##
  ## set Update info
  DESCRIPTION[ 1, paste0(schemeName, "Update") ] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  DESCRIPTION[ 1, paste0(schemeName, "MD5")    ] <- md5sum(sheet)
  ## write new DESCRIPTION
  write.dcf(DESCRIPTION, here::here("DESCRIPTION"))

  # update tests/testthat/dmdScheme.xlsx ------------------------------------

  file.copy(
    sheet,
    here::here("tests", "testthat", paste0(schemeName, ".xlsx")),
    overwrite = TRUE
  )

  # update exported xml in tests/testthat/*.xml -----------------------------

  dmdSchemeToXml(
    x = dmdScheme_example,
    file = here::here( "tests", "testthat", paste0(schemeName, "_example.xml") )
  )

  # Return invisibble NULL --------------------------------------------------------

  invisible(NULL)
}
