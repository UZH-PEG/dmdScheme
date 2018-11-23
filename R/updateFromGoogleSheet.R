#' Update data from googlesheets
#'
#' Update the data and increase the version in the DESCRIPTION if it has changed.
#'
#' @param token token for google access. If \code{NULL} (default), user will be asked
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
  token = NULL
) {
  on.exit(gs_deauth())
  ##
  gs_auth(token = token)
  emes <- gs_title("microcosmScheme")
  update <- emes$updated %>% format("%Y-%m-%d %H:%M:%S")
  lastUpdate <- read.dcf(here("DESCRIPTION"))[1, "GSUpdate"]
  ##
  if ( update == lastUpdate ) {      ##### no change in google sheet
    gs_deauth()
  } else { ##### change in google sheet
    ## update inst/googlesheet/emeScheme.xlsx
    gs_download(
      from = emes,
      to = here("inst", "googlesheet", "emeScheme.xlsx"),
      overwrite = TRUE
    )
    ## update data/emeScheme_gd.rda
    emeScheme_gd <- gs_read(emes)
    save( emeScheme_gd, file = here("data", "emeScheme_gd.rda"))
    ## update data/emeScheme.rda
    emeScheme <- emeScheme_gd %>%
      select(starts_with("Property"))

    notNA <- emeScheme %>%
      is.na() %>%
      rowSums() %>%
      equals(ncol(emeScheme)) %>%
      not()
    emeScheme <- emeScheme[notNA,]

    save( emeScheme, file = here("data", "emeScheme.rda"))
    ##

    ##### bump version #####
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
      paste0(" ---- ", "Data imported and version bumped at ", date(), " / ", Sys.timezone())
    ## set GSUpdate
    DESCRIPTION[1, "GSUpdate"] <- update
    ## write new DESCRIPTION
    write.dcf(DESCRIPTION, here("DESCRIPTION"))
    rm( emeScheme, emeScheme_gd )
  }
  return(emes)
}
