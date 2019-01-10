#' Generic print function for \code{emeSchemeData}
#'
#' @param x object of type \code{emeSchemeSet}
#' @param ... additional arguments - not used here
#' @param printAttr default \code{TRUE} - attributes are printed
#' @param printExtAttr default \code{FALSE} - additional attributes are not printed (e.g. \code{class})
#' @param printData default \code{TRUE} - data is printed
#' @param .prefix mainly for internal use - prefix for all printed lines
#'
#' @return invisibly x
#' @export
#'
print.emeSchemeData <- function(x, ..., printAttr = TRUE, printExtAttr = FALSE, printData = TRUE, .prefix = ""){
  ##
  cat_ln(.prefix, " ", attr(x, "propertyName"), " - emeSchemeData")
  if (printAttr) {
    cat_ln("A   ", .prefix, "Names : ", paste(attr(x, "names"), collapse = " "))
    cat_ln("A   ", .prefix, "Units : ", paste(attr(x, "unit"), collapse = " "))
    cat_ln("A   ", .prefix, "Class : ", paste(attr(x, "type"), collapse = " "))
    cat_ln()
  }
  #
  if (printExtAttr) {
    cat_ln("XA  ", .prefix, "Types : ", paste(attr(x, "class"), collapse = " "))
    cat_ln()
  }
  ##
  if (printData) {
    x <- as.data.frame(x)
    .prefix <- paste0("D   ", .prefix, row.names(x))
    .rowNamesDF(x, make.names = TRUE) <- .prefix
    print(x)
    cat_ln()
  }
  ##
  invisible(x)
}
