#' Update data from googlesheets
#'
#' Update the data and increase the version in the DESCRIPTION if it has changed.
#'
#' @param token token for google access. If \code{NULL} (default), user will be asked
#' @param force force update even if no newer version on google docs
#'
#' @return a googlesheet object
#'
#' importFrom googlesheets gs_auth gs_title gs_download gs_deauth
#' importFrom here here
#' @importFrom readxl read_excel
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom tools md5sum
#'
updateFromGoogleSheet <- function(
  token = NULL,
  force = FALSE
) {

# Some preparations -------------------------------------------------------

  on.exit(googlesheets::gs_deauth())
  ##
  googlesheets::gs_auth(token = token)
  emes <- googlesheets::gs_title("emeScheme_dev")
  update <- emes$updated %>% format("%Y-%m-%d %H:%M:%S")
  lastUpdate <- read.dcf(here::here("DESCRIPTION"))[1, "GSUpdate"]
  if (force) {
    lastUpdate = -1
  }

# Check if update needed --------------------------------------------------

  if ( update == lastUpdate ) {      ##### no change in google sheet
    googlesheets::gs_deauth()
  } else {

    # update inst/googlesheet/emeScheme.xlsx ----------------------------------
    cat_ln("##### Downloading emeScheme.xls...")

    googlesheets::gs_download(
      from = emes,
      to = here::here("inst", "googlesheet", "emeScheme.xlsx"),
      overwrite = TRUE
    )


    # update tests/testthat/emeScheme.xlsx ------------------------------------

    file.copy(here::here("inst", "googlesheet", "emeScheme.xlsx"), here::here("tests", "testthat", "emeScheme.xlsx"), overwrite = TRUE)

    # update data/emeScheme_raw.rda -----------------------------------------------

    cat_ln("##### Generating emeScheme_raw...")

    path <- here::here("inst", "googlesheet", "emeScheme.xlsx")
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
      paste0(" ---- ", "Data imported and version bumped at ", date(), " / ", Sys.timezone(), ".")
    ## set GSUpdate
    DESCRIPTION[1, "GSUpdate"] <- update
    ## write new DESCRIPTION
    write.dcf(DESCRIPTION, here::here("DESCRIPTION"))
    rm( emeScheme, emeScheme_raw )
  }

# Return emeScheme --------------------------------------------------------

  return(emes)
}
