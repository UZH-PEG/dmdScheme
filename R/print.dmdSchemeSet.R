#' Print method for \code{dmdSchemeSet} object
#'
#' @param x object of type \code{dmdSchemeSet}
#' @param ... additional arguments - not used here
#' @param printAttr default \code{TRUE} - attributes are printed
#' @param printExtAttr default \code{FALSE} - additional attributes are not printed (e.g. \code{class})
#' @param printData default \code{TRUE} - data is printed
#' @param .prefix mainly for internal use - prefix for all printed lines
#'
#' @return invisibly x
#' @export
#'
print.dmdSchemeSet <- function(x, ..., printAttr = TRUE, printExtAttr = FALSE, printData = TRUE, .prefix = ""){
  ##
  cat_ln(.prefix, " ", attr(x, "propertyName"), " - dmdSchemeSet")
  lapply(
    x,
    print,
    printAttr = printAttr,
    printData = printData,
    printExtAttr = printExtAttr,
    .prefix = paste0(paste(rep(" ", 4), collapse = ""), .prefix)
  )
  ##
  invisible(x)
}
