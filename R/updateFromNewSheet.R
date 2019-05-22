#' Update data from dmdScheme.xlsx --- ONLY FOR DEVLOPMENT NEEDED
#'
#' Update the data from the file \code{here::here("inst", "dmdScheme.xlsx")}
#' and bump the version in the DESCRIPTION if it has changed.
#' @param newDmdScheme xlsx spreadsheet containing the new \code{dmdScheme} definition
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
  force = FALSE
) {

  cat_ln(
    "This function is only to be used during development from withion the root directory of the package.\n",
    "There is absolutely not reason, why you should call this function as a user of the package.\n",
    "\n",
    "If you are calling this function as a non developer, it will likely result in an error!"
  )

  # prepare update ----------------------------------------------------------

  sheet <- here::here("inst",  "dmdScheme.xlsx")
  if ((md5sum(newDmdScheme) == read.dcf(here::here("DESCRIPTION"))[1, "dmdSchemeMD5"]) & (!force)) {
    cat_ln("The sheet has not changed since the last update!")
    cat_ln("Nothing done.")
  } else {


# Updata dmdScheme.xlsx ---------------------------------------------------

    file.copy(newDmdScheme, sheet, overwrite = TRUE)

    # update data/dmdScheme_raw.rda -----------------------------------------------

    cat_ln("##### Generating dmdScheme_raw...")

    dmdScheme_raw <- read_from_excel(
      file = sheet,
      keepData = FALSE,
      verbose = TRUE,
      raw = TRUE,
      validate = FALSE
    )
    ##
    save( dmdScheme_raw, file = here::here("data", "dmdScheme_raw.rda"))

    # update data/dmdScheme.rda -----------------------------------------------

    cat_ln("##### Generating dmdScheme...")
    dmdScheme <- new_dmdSchemeSet(
      x = dmdScheme_raw,
      keepData = FALSE,
      verbose = TRUE
    )
    save( dmdScheme, file = here::here("data", "dmdScheme.rda"))

    # update data/dmdScheme_exmple.rda ----------------------------------------

    cat_ln("##### Generating dmdScheme_example...")
    dmdScheme_example <- new_dmdSchemeSet(
      x = dmdScheme_raw,
      keepData = TRUE,
      verbose = TRUE
    )
    save( dmdScheme_example, file = here::here("data", "dmdScheme_example.rda"))

    # Update dmdScheme.xml files -----------------------------------------------

    cat_ln("##### Generating dmdScheme_example.xml...")

    dmdSchemeToXml(
      x = dmdScheme_example,
      file = here::here("inst", "dmdScheme_example.xml"),
      output = "complete"
    )

    # bump version and change description in DECRIPTION -----------------------

    ## read old DESCRIPION file
    DESCRIPTION <- read.dcf(here::here("DESCRIPTION"))
    ##
    ## Increase Version
    currVersion <- DESCRIPTION[1, "Version"]
    splitVersion <- strsplit(currVersion, ".", fixed = TRUE)[[1]]
    nVer <- length(splitVersion)
    currEndVersion <- as.integer(splitVersion[nVer])
    newEndVersion <- as.character(currEndVersion + 1)
    splitVersion[nVer] <- newEndVersion
    newVersion <- paste(splitVersion, collapse = ".")
    DESCRIPTION[1, "Version"] <- newVersion
    ##
    ## Set Date
    DESCRIPTION[1, "Date"] <- format(Sys.time(), '%Y-%m-%d')
    ##
    ## adjust Description
    DESCRIPTION[1, "Description"] %<>%
      strsplit(" ---- ") %>%
      extract2(1) %>%
      extract(1) %>%
      paste0(" ---- ", "Data updated and version bumped at ", date(), " / ", Sys.timezone(), ".")
    ## set GSUpdate
    DESCRIPTION[1, "dmdSchemeUpdate"] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    DESCRIPTION[1, "dmdSchemeMD5"] <- md5sum(sheet)
    ## write new DESCRIPTION
    write.dcf(DESCRIPTION, here::here("DESCRIPTION"))
    rm( dmdScheme, dmdScheme_raw )

  }

  # update tests/testthat/dmdScheme.xlsx ------------------------------------

  file.copy(sheet, here::here("tests", "testthat", "dmdScheme.xlsx"), overwrite = TRUE)

  # update exported xml in tests/testthat/*.xml -----------------------------

  dmdSchemeToXml(
    x = dmdScheme_example,
    file = here::here("tests", "testthat", "dmdScheme_example.xml")
  )

  # Return invisibble NULL --------------------------------------------------------

  invisible(NULL)
}
