#' Update data from dmdScheme.xlsx --- ONLY FOR DEVLOPMENT NEEDED
#'
#' Update the data from the file \code{file.path( ".", "inst", "dmdScheme.xlsx")}
#' and bump the version in the DESCRIPTION if it has changed.
#' @param newDmdScheme xlsx spreadsheet containing the new \code{dmdScheme} definition
#' @param schemeName name of the scheme. Default: dmdScheme. SHould be changed because of readability!
#' @param force force update even if \code{file.path( ".", "inst", "dmdScheme.xlsx")}
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

  # prepare update ----------------------------------------------------------

  dir.create("data", showWarnings = FALSE)
  dir.create("inst", showWarnings = FALSE)
  dir.create(file.path("tests", "testthat"), showWarnings = FALSE, recursive = TRUE)
  sheet <- file.path(".", "inst", paste0(schemeName, ".xlsx"))

  # Updata dmdScheme.xlsx ---------------------------------------------------

  file.copy(
    from = newDmdScheme,
    to = sheet,
    overwrite = TRUE
  )

  # update data/dmdScheme_raw -----------------------------------------------

  message("##### Generating ", schemeName, "_raw...")

  dmdScheme_raw <- read_from_excel_raw(
    file = sheet,
    keepData = FALSE,
    verbose = TRUE,
    schemeName = schemeName,
    checkVersion = FALSE
  )
  ##
  varName <- paste0(schemeName, "_raw")
  fileName <- file.path(".", "data", paste0(varName, ".rda") )
  # eval( parse( text = sprintf("save(%s, file = %s)", varName, "fileName") ) )
  assign(
    x = varName,
    value = dmdScheme_raw
  )
  save( list = varName, file = fileName)

  # update data/dmdScheme -----------------------------------------------

  message("##### Generating dmdScheme...")
  dmdScheme <- new_dmdSchemeSet(
    x = dmdScheme_raw,
    keepData = FALSE,
    verbose = TRUE
  )
  ##
  varName <- paste0(schemeName)
  fileName <- file.path(".", "data", paste0(varName, ".rda") )
  # eval( parse( text = sprintf("save(%s, file = %s)", varName, "fileName") ) )
  assign(
    x = varName,
    value = dmdScheme
  )
  save( list = varName, file = fileName)

  # update data/dmdScheme_exmple ----------------------------------------

  message("##### Generating dmdScheme_example...")
  dmdScheme_example <- new_dmdSchemeSet(
    x = dmdScheme_raw,
    keepData = TRUE,
    verbose = TRUE
  )
  ##
  varName <- paste0(schemeName, "_example")
  fileName <- file.path(".", "data", paste0(varName, ".rda") )
  # eval( parse( text = sprintf("save(%s, file = %s)", varName, "fileName") ) )
  assign(
    x = varName,
    value = dmdScheme_example
  )
  save( list = varName, file = fileName)

  # Update dmdScheme.xml files -----------------------------------------------

  message("##### Generating dmdScheme_example.xml...")

  dmdSchemeToXml(
    x = dmdScheme_example,
    file = file.path( ".", "inst", paste0(schemeName, "_example.xml") ),
    output = "metadata"
  )

  # bump version and change description in DECRIPTION -----------------------

  ## read old DESCRIPION file
  DESCRIPTION <- read.dcf("DESCRIPTION")
  ##
  ## set Update info
  DESCRIPTION[ 1, paste0(schemeName, "Update") ] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  DESCRIPTION[ 1, paste0(schemeName, "MD5")    ] <- md5sum(sheet)
  ## write new DESCRIPTION
  write.dcf(DESCRIPTION, "DESCRIPTION")

  # update tests/testthat/dmdScheme.xlsx ------------------------------------

  file.copy(
    sheet,
    file.path( ".", "tests", "testthat", paste0(schemeName, ".xlsx")),
    overwrite = TRUE
  )

  # update exported xml in tests/testthat/*.xml -----------------------------

  dmdSchemeToXml(
    x = dmdScheme_example,
    file = file.path( ".", "tests", "testthat", paste0(schemeName, "_example.xml") )
  )

  # Return invisibble NULL --------------------------------------------------------

  invisible(NULL)
}
