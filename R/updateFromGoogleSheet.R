#' Update data from googlesheets
#'
#' Update the data and increase the version in the DESCRIPTION if it has changed.
#'
#' @param token token for google access. If \code{NULL} (default), user will be asked
#' @param force force update even if no newer version on google docs
#'
#' @return a googlesheet object
#'
#' @importFrom googlesheets gs_auth gs_title gs_read gs_download gs_deauth
#' @importFrom magrittr %>% %<>% equals not extract extract2
#' @importFrom here here
#' @importFrom tools md5sum
#' @importFrom dplyr select starts_with
#'
updateFromGoogleSheet <- function(
  token = NULL,
  force = FALSE
) {
  on.exit(gs_deauth())
  ##
  gs_auth(token = token)
  emes <- gs_title("microcosmScheme")
  update <- emes$updated %>% format("%Y-%m-%d %H:%M:%S")
  lastUpdate <- read.dcf(here("DESCRIPTION"))[1, "GSUpdate"]
  if (force) {
    lastUpdate = -1
  }
  ##
  if ( update == lastUpdate ) {      ##### no change in google sheet
    gs_deauth()
  } else { ##### change in google sheet

# update data/emeScheme.rda -----------------------------------------------

    emeScheme_gd <- gs_read(emes)
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
    save( emeScheme_gd, file = here("data", "emeScheme_gd.rda"))

# update data/emeScheme.rda -----------------------------------------------

    emeScheme <- gdToScheme(emeScheme_gd)

    save( emeScheme, file = here("data", "emeScheme.rda"))

# update inst/googlesheet/emeScheme.xlsx ----------------------------------
    Sys.chmod(here("inst", "googlesheet", "emeScheme.xlsx"), "0777")

    gs_download(
      from = emes,
      to = here("inst", "googlesheet", "emeScheme.xlsx"),
      overwrite = TRUE
    )
    format_emeScheme_xlsx(emeScheme_gd = emeScheme_gd)

    Sys.chmod(here("inst", "googlesheet", "emeScheme.xlsx"), "0444")

    file.copy(here("inst", "googlesheet", "emeScheme.xlsx"), here("tests", "testthat", "emeScheme.xlsx"))

# bump version and change description in DECRIPTION -----------------------

    ## read old DESCRIPION file
    DESCRIPTION <- read.dcf(here("DESCRIPTION"))
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
    write.dcf(DESCRIPTION, here("DESCRIPTION"))
    rm( emeScheme, emeScheme_gd )
  }

# Return emeScheme --------------------------------------------------------

  return(emes)
}
