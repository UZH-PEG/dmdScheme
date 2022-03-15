#' Return tabs in scheme definition in Excel document which need to be
#' transposed or if a tab has to be transposed
#'
#' Tabs in the Excel document need to be, for processing, transposed, if they
#' are vertical as the Experiment tab is.
#'
#' @param tabs if \code{NULL}, the
#'
#' @return if \code{tabs} is null, the \code{character} vector containing the
#'   sheets which need to be transposed. If \code{tabs} is not NULL, a
#'   \code{logical} vector of the same length as \code{tabs} which is
#'   \code{TRUE}, if the tab needs to be transposed, otherwise \code{FALSE}.
#' @export
#'
#' @examples
#' toTranspose()
#' # [1] "Experiment"     "MdBibliometric"
#'
#' toTranspose(c("Experiment", "Not"))
#' # [1]  TRUE FALSE
#'
toTranspose <- function(tabs = NULL) {
  result <- c("Experiment", "MdBibliometric")
  if (!is.null(tabs)) {
    result <- tabs %in% result
  }
  return(result)
}
