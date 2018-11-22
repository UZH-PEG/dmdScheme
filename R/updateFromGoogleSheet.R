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
  mcs <- gs_title("microcosmScheme")
  update <- mcs$updated %>% format("%Y-%m-%d %H:%M:%S")
  lastUpdate <- read.dcf(here("DESCRIPTION"))[1, "GSUpdate"]
  ##
  if ( update == lastUpdate ) {      ##### no change in google sheet
    gs_deauth()
  } else { ##### change in google sheet
    ## update inst/googlesheet/microcosmSheme.xlsx
    gs_download(
      from = mcs,
      to = here("inst", "googlesheet", "microcosmScheme.xlsx"),
      overwrite = TRUE
    )
    ## update data/microcosmSheme_gd.rda
    microcosmScheme_gd <- gs_read(mcs)
    save( microcosmScheme_gd, file = here("data", "microcosmScheme_gd.rda"))
    ## update data/microcosmSheme.rda
    microcosmScheme <- microcosmScheme_gd %>%
      select(starts_with("Property"))

    notNA <- microcosmScheme %>%
      is.na() %>%
      rowSums() %>%
      equals(ncol(microcosmScheme)) %>%
      not()
    microcosmScheme <- microcosmScheme[notNA,]

    save( microcosmScheme, file = here("data", "microcosmScheme.rda"))
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
    rm( microcosmScheme, microcosmScheme_gd )
  }
  return(mcs)
}
