#' print function for \code{emeScheme_validation}
#'
#' When using different values for \code{format}, different outputs are generated:
#' \itemize{
#'    \item{"default"}{print \code{x} as \code{list}}
#'    \item{"summary"}{print the description and errors of \code{x} as structured output, using the format as specified in the argument \code{format}}
#'    \item{"details"}{print the details of \code{x} as structured output, using the format as specified in the argument \code{format}}
#' }
#' @param x object of class \code{emeScheme_validation}
#' @param level level at which the header structure should start
#' @param listLevel level at which the elements should be represented as lists and not headers anymore
#' @param type type of output, can be either \code{"default"}, \code{"summary"} or \code{"details"}. Default is \code{"default"}
#' @param format format in which the details tables should be printed. All values as used in \code{knitr::kable()} are allowed.
#' @param ... additional arguments for the function \code{knitr::kable()} function to format the table.
#'
#' @return invisibly returns x
#' @export
#'
#' @examples
#' x <- validate(emeScheme_raw)
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
print.emeScheme_validation <- function(x, level = 1, listLevel = 3, type = "default", format = "markdown", ...) {
  switch (type,
    default = NextMethod(),
    summary = print_emeScheme_validation_summary(x, level = level, listLevel = listLevel),
    details = print_emeScheme_validation_details(x, level = level, listLevel = listLevel, format = format),
    stop("type has to be `summary` or `details`!")
  )
}

#' Internal function to ptint emeScheme_validation of format \code{summary}
#'
#' @param x as in print.emeScheme_validation
#' @param level as in print.emeScheme_validation
#' @param listLevel as in print.emeScheme_validation
#'
#' @return as in print.emeScheme_validation
#'
print_emeScheme_validation_summary <- function(x, level, listLevel) {
  if (!inherits(x, "emeScheme_validation")) {
    stop("'x' has to be of type 'emeScheme_validation'")
  }
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
  for (i in 1:length(x)) {
    if (inherits(x[[i]], "emeScheme_validation")) {
      print_emeScheme_validation_summary(x = x[[i]], level = level + 1, listLevel = listLevel)
    }
  }
  invisible(x)
}

#' Internal function to ptint emeScheme_validation of format \code{summary}
#'
#' @param x as in print.emeScheme_validation
#' @param level as in print.emeScheme_validation
#' @param listLevel as in print.emeScheme_validation
#' @param format as in print.emeScheme_validation
#' @param ... as in print.emeScheme_validation
#'
#' @return as in print.emeScheme_validation
#' @importFrom knitr kable
#'
print_emeScheme_validation_details <- function(x, level, listLevel, format, ...) {
  if (!inherits(x, "emeScheme_validation")) {
    stop("'x' has to be of type 'emeScheme_validation'")
  }
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
  for (i in 1:length(x)) {
    if (inherits(x[[i]], "emeScheme_validation")) {
      print_emeScheme_validation_details(x = x[[i]], level = level + 1, listLevel = listLevel, format = format, ...)
    }
  }
  invisible(x)
}
