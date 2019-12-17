#' Print method for \code{dmdSchemeData} object
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
print.dmdSchemeData <- function(x, ..., printAttr = TRUE, printExtAttr = FALSE, printData = TRUE, .prefix = ""){
  ##
  cat_ln(.prefix, " ", attr(x, "propertyName"), " - dmdSchemeData")
  if (printAttr) {
    cat_ln("A   ", .prefix, "Names : ", paste(attr(x, "names"), collapse = " | "))
    cat_ln("A   ", .prefix, "Units : ", paste(attr(x, "unit"), collapse = " | "))
    cat_ln("A   ", .prefix, "Type  : ", paste(attr(x, "type"), collapse = " | "))
    cat_ln()
  }
  #
  if (printExtAttr) {
    for (a in names(attributes(x))) {
      if (!(a %in% c("names", "unit", "type"))) {
        cat_ln("XA  ", .prefix, a, ": ", paste(attr(x, a), collapse = " | "))
      }
    }
    cat_ln()
  }
  ##
  if (printData) {
    x <- as.data.frame(x)

    ### adapted from print.data.frame
    n <- length(row.names(x))
    if (length(x) == 0L) {
      cat(sprintf(ngettext(n, "data with 0 columns and %d row",
                           "data with 0 columns and %d rows"), n), "\n",
          sep = "")
    }
    else if (n == 0L) {
      cat_ln("D   ", .prefix, "###### No Data in dmdSchemeData ######")
    }
    else {
      .prefix <- paste0("D   ", .prefix, row.names(x))
      rownames(x) <- .prefix
      # .rowNamesDF(x, make.names = TRUE) <- .prefix
      print(x)
    }
    ###

    cat_ln()
  }
  ##
  invisible(x)
}
