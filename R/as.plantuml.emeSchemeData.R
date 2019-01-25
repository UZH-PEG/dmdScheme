#' Generic function to convert \code{emeSchemeData} to a \code{plantuml} object
#'
#' @param x object to be converted
#' @param complete internal
#' @param nm internal
#' @param ... other arguments passed to other functions
#'
#' @return object of class \code{plantuml} which can be plotted
#' @export
#'
as.plantuml.emeSchemeData <- function(x, complete, nm, ...){
  if (!requireNamespace("plantuml")) {
    stop("Can only be used when plantuml is installed!")
  }
  attr(x, "Description") %<>% strtrim(10) %>% paste0("...")
  NextMethod("as.plantuml", x, complete, nm, ...)
}
