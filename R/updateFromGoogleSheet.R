#' Update data from googlesheets
#'
#' Update the data and increase the version in the DESCRIPTION if it has changed.
#'
#' @param token token for google access. If \code{NULL} (default), user will be asked
#' @param force force update even if no newer version on google docs
#'
#' @return a googlesheet object
#'
#' importFrom googlesheets gs_auth gs_title gs_read gs_download gs_deauth
#' importFrom here here
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom tools md5sum
#' @importFrom dplyr select starts_with
#'
updateFromGoogleSheet <- function(
  token = NULL,
  force = FALSE
) {
  on.exit(googlesheets::gs_deauth())
  ##
  googlesheets::gs_auth(token = token)
  emes <- googlesheets::gs_title("microcosmScheme")
  update <- emes$updated %>% format("%Y-%m-%d %H:%M:%S")
  lastUpdate <- read.dcf(here::here("DESCRIPTION"))[1, "GSUpdate"]
  if (force) {
    lastUpdate = -1
  }
  ##
  if ( update == lastUpdate ) {      ##### no change in google sheet
    googlesheets::gs_deauth()
  } else { ##### change in google sheet

# update data/emeScheme.rda -----------------------------------------------

    emeScheme_gd <- googlesheets::gs_read(emes)
    ##
    notNARow <- emeScheme_gd %>%
      is.na() %>%
      rowSums() %>%
      equals(ncol(emeScheme_gd)) %>%
      not()
    notNACol <- emeScheme_gd %>%
      is.na() %>%
      colSums() %>%
      equals(nrow(emeScheme_gd)) %>%
      not()
    emeScheme_gd <- emeScheme_gd[notNARow, notNACol]
    ##
    save( emeScheme_gd, file = here::here("data", "emeScheme_gd.rda"))

# update data/emeScheme.rda -----------------------------------------------

    emeScheme <- gdToScheme(emeScheme_gd)

    save( emeScheme, file = here::here("data", "emeScheme.rda"))

# update inst/googlesheet/emeScheme.xlsx ----------------------------------

    ## make the xlsx writable
    Sys.chmod(here::here("inst", "googlesheet", "emeScheme.xlsx"), "0777")

    googlesheets::gs_download(
      from = emes,
      to = here::here("inst", "googlesheet", "emeScheme.xlsx"),
      overwrite = TRUE
    )

    format_emeScheme_xlsx(
      fn = here::here("inst", "googlesheet", "emeScheme.xlsx"),
      emeScheme_gd = emeScheme_gd
    )

    file.copy(here::here("inst", "googlesheet", "emeScheme.xlsx"), here::here("tests", "testthat", "emeScheme.xlsx"), overwrite = TRUE)

    ## write protect it again
    Sys.chmod(here::here("inst", "googlesheet", "emeScheme.xlsx"), "0444")


# Update emeScheme.xml file -----------------------------------------------

    addDataToEmeScheme( x = emeScheme_gd, s = emeScheme, dataSheet = 1, dataCol = 1) %>%
      emeSchemeToXml(file = here::here("inst", "emeScheme_example.xml"))

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
    rm( emeScheme, emeScheme_gd )
  }

# Return emeScheme --------------------------------------------------------

  return(emes)
}
