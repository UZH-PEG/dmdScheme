#' Print method for \code{dmdScheme_validation} object
#'
#' When using different values for \code{format}, different outputs are generated:
#' \itemize{
#'    \item{"default"}{print \code{x} as \code{list}}
#'    \item{"summary"}{print the description and errors of \code{x} as structured output, using the format as specified in the argument \code{format}}
#'    \item{"details"}{print the details of \code{x} as structured output, using the format as specified in the argument \code{format}}
#' }
#' @param x object of class \code{dmdScheme_validation}
#' @param level level at which the header structure should start
#' @param listLevel level at which the elements should be represented as lists and not headers anymore
#' @param type type of output, can be either \code{"default"}, \code{"summary"} or \code{"details"}. Default is \code{"default"}
#' @param format format in which the details tables should be printed. All values as used in \code{knitr::kable()} are allowed.
#' @param error numeric v ector, containing error levels to print. Default is all error levels.
#' @param ... additional arguments for the function \code{knitr::kable()} function to format the table.
#'
#' @return invisibly returns x
#' @export
#'
#' @examples
#' x <- validate(dmdScheme_raw())
#'
#' ## default printout as list
#' x
#'
#' ## the same as
#' print(x, type = "default")
#'
#' ## the summary
#' print(x, type = "summary")
#'
#' ## and the details
#' print(x, type = "details")
#'
#' ## can be used in a Rmd file like:
#' # ```{r, results = "asis"}
#' #    print(result, level = 2, listLevel = 20, type = "summary")
#' # ```
print.dmdScheme_validation <- function(x, level = 1, listLevel = 3, type = "default", format = "markdown", error = c(0, 1, 2, 3, NA), ...) {
  switch(
    type,
    default = NextMethod(),
    summary = print_dmdScheme_validation_summary(x, level = level, listLevel = listLevel, error = error),
    details = print_dmdScheme_validation_details(x, level = level, listLevel = listLevel, format = format, error = error),
    stop("type has to be `default`, summary` or `details`!")
  )
}

#' Internal function to ptint dmdScheme_validation of format \code{summary}
#'
#' @param x as in print.dmdScheme_validation
#' @param level as in print.dmdScheme_validation
#' @param listLevel as in print.dmdScheme_validation
#' @param error numeric v ector, containing error levels to print. Default is all error levels.
#'
#' @return as in print.dmdScheme_validation
#'
print_dmdScheme_validation_summary <- function(x, level, listLevel, error = c(0, 1, 2, 3, NA)) {
  if (!inherits(x, "dmdScheme_validation")) {
    stop("'x' has to be of type 'dmdScheme_validation'")
  }
  if (x$error %in% error) {
    if (level < listLevel) {
      cat_ln()
      cat_ln( paste(rep("#", level), collapse = ""), " ", x$header)
      cat_ln()
      cat_ln("", x$description)
      cat_ln()
    } else {
      cat_ln("- ", " ", x$header, "   ")
      cat_ln("    ", x$description)
      cat_ln()
    }
  }
  for (i in 1:length(x)) {
    if (inherits(x[[i]], "dmdScheme_validation")) {
      print_dmdScheme_validation_summary(x = x[[i]], level = level + 1, listLevel = listLevel, error = error)
    }
  }
  invisible(x)
}

#' Internal function to ptint dmdScheme_validation of format \code{summary}
#'
#' @param x as in print.dmdScheme_validation
#' @param level as in print.dmdScheme_validation
#' @param listLevel as in print.dmdScheme_validation
#' @param format as in print.dmdScheme_validation
#' @param error numeric v ector, containing error levels to print. Default is all error levels.
#' @param ... as in print.dmdScheme_validation
#'
#' @return as in print.dmdScheme_validation
#' @importFrom knitr kable
#'
print_dmdScheme_validation_details <- function(x, level, listLevel, format, error = c(0, 1, 2, 3, NA), ...) {
  if (!inherits(x, "dmdScheme_validation")) {
    stop("'x' has to be of type 'dmdScheme_validation'")
  }
  if (x$error %in% error) {
    if (level < listLevel) {
      cat_ln()
      cat_ln( paste(rep("#", level), collapse = ""), " ", x$header)
      cat_ln()
      cat_ln("", x$descriptionDetails)
      cat_ln()
    } else {
      cat_ln("- ", " ", x$header, "   ")
      cat_ln(x$descriptionDetails, "  ")
    }
    print(knitr::kable(x$details, format = format))
    cat_ln("")
  }
  for (i in 1:length(x)) {
    if (inherits(x[[i]], "dmdScheme_validation")) {
      print_dmdScheme_validation_details(x = x[[i]], level = level + 1, listLevel = listLevel, format = format, error = error, ...)
    }
  }
  invisible(x)
}
