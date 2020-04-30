#'
#' @rdname as_eml
#' @family conversion
#' @export
#'
#'
as_eml.default <- function(x, ...) {
  stop(
    "\n\n",
    "The conversion of the object x of the class `", paste(class(x), collapse = ", "), "` is not supported!\n",
    "The generic `dmdScheme` objects can not be exported, and specific exporters for other schemes need to be written!"
  )
}
