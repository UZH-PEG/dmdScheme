#' Create new \code{emeSehemeData} class object from specifications
#'
#' @param x tibble as imported from the google sheet
#'
#' @return \code{emeSchemeData} object complete with all attributes
#' @importFrom dplyr filter
#' @importFrom magrittr %<>% %>%
#' @export
#'
#' @examples
#' new_emeSchemeData( x = emeSCheme_gd)
new_emeSchemeData <- function(
  x,
  trimToOne = TRUE,
  debug = FALSE
  ) {

# set propertySetName -----------------------------------------------------

  attr(x, "propertyName") <- names(x)[[2]]

# set names ---------------------------------------------------------------

  names(x) <- dplyr::filter(x, propertySet == "valueProperty")
  x %<>% dplyr::filter(valueProperty != "valueProperty")

# extract attributes to set -----------------------------------------------

  attrToSet <- x$valueProperty
  attrToSet <- attrToSet[1:(which(x$valueProperty == "Data for one dataset")-1)]

# set attributes ----------------------------------------------------------

  for (a in attrToSet) {
    attr(x, which = a) <- dplyr::filter(x, valueProperty == a)[,-1] %>%
      unlist()
    x %<>% dplyr::filter(valueProperty != a)
  }

# remove valueProperty column ---------------------------------------------

  x %<>% dplyr::select(-valueProperty)

# apply type --------------------------------------------------------------

  type <- attr(x, "type")
  for (i in 1:ncol(x)) {
    if (debug) {
      cat_ln()
    }
    x[[i]] <- as(x[[i]], Class = type[i])
  }

# if TrimToOne remove all but one data column ----------------------------

  if (trimToOne) {
    x %<>% dplyr::filter(c(TRUE, rep(FALSE, nrow(x)-1)) )
  }

# set class ---------------------------------------------------------------

  class(x) <- append(
    c(
      paste("emeSchemeData", attr(x, "propertyName"), sep = "_"),
      "emeSchemeData",
      "emeScheme"
    ),
    class(x),
  )

# return object -----------------------------------------------------------

  return(x)
}
