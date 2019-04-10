#' Update data from emeScheme.xlsx --- ONLY FOR DEVLOPMENT NEEDED
#'
#' Update the data from the file \code{here::here("inst", "emeScheme.xlsx")}
#' and bump the version in the DESCRIPTION if it has changed.
#' @param force force update even if \code{here::here("inst", "emeScheme.xlsx")}
#'   has the same md5 suma s in the DESCRIPTION
#'
#' @return invisibly NULL
#'
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom tools md5sum
#'
updateFromNewSheet <- function( force = FALSE) {

  cat_ln(
    "This function is only to be used during development from withion the root directory of the package.\n",
    "There is absolutely not reason, why you should call this function as a user of the package.\n",
    "\n",
    "If you are calling this function as a non developer, it will likely result in an error!"
  )

  # prepare update ----------------------------------------------------------

  sheet <- here::here("inst", "emeScheme.xlsx")
  if ((md5sum(sheet) == read.dcf(here::here("DESCRIPTION"))[1, "emeSchemeMD5"]) & (!force)) {
    cat_ln("The sheet has not changed since the last update!")
    cat_ln("Nothing done.")
  } else {

    # update tests/testthat/emeScheme.xlsx ------------------------------------

    file.copy(sheet, here::here("tests", "testthat", "emeScheme.xlsx"), overwrite = TRUE)

    # update exported xml in tests/testthat/*.xml -----------------------------

    emeScheme_split( emeScheme_example, c("rds", "xml"), path = here::here("tests", "testthat"))

    # update data/emeScheme_raw.rda -----------------------------------------------

    cat_ln("##### Generating emeScheme_raw...")

    path <- here::here("inst", "emeScheme.xlsx")
    emeScheme_raw <- read_from_excel(
      file = path,
      keepData = FALSE,
      verbose = TRUE,
      raw = TRUE,
      validate = FALSE
    )
    ##
    save( emeScheme_raw, file = here::here("data", "emeScheme_raw.rda"))

    # update data/emeScheme.rda -----------------------------------------------

    cat_ln("##### Generating emeScheme...")
    emeScheme <- new_emeSchemeSet(
      x = emeScheme_raw,
      keepData = FALSE,
      verbose = TRUE
    )
    save( emeScheme, file = here::here("data", "emeScheme.rda"))

    # update data/emeScheme_exmple.rda ----------------------------------------

    cat_ln("##### Generating emeScheme_example...")
    emeScheme_example <- new_emeSchemeSet(
      x = emeScheme_raw,
      keepData = TRUE,
      verbose = TRUE
    )
    save( emeScheme_example, file = here::here("data", "emeScheme_example.rda"))

    # Update emeScheme.xml files -----------------------------------------------

    cat_ln("##### Generating emeScheme_example.xml...")

    emeSchemeToXml(
      x = emeScheme_example,
      file = here::here("inst", "emeScheme_example.xml"),
      output = "complete",
      confirmationCode = "secret code for testing"
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
    DESCRIPTION[1, "emeSchemeUpdate"] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    DESCRIPTION[1, "emeSchemeMD5"] <- md5sum(sheet)
    ## write new DESCRIPTION
    write.dcf(DESCRIPTION, here::here("DESCRIPTION"))
    rm( emeScheme, emeScheme_raw )

  }
  # Return invisibble NULL --------------------------------------------------------

  invisible(NULL)
}
