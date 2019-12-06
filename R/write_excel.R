#' Write write x as an excel file to disk
#'
#' Convert the object \code{x} to an \code{xml_document} object using the function \code{as_xml()} and write it to a file.
#' If no method \code{as_xml()} exists for the object |class{x}, an error will be raised.
#' @param x object which can be convertewd to a \code{dmdSchemeSet_raw} odject using the function \code{as_dmdScheme_raw} which will
#'  saved as an \code{xlsx} file.
#' @param file Path to file or connection to write to.
#' @param ... additional parameter for the conversion function \code{(openxlsx::write.xlsx())}
#'
#' @return invisibly returns the path to the file saved to
#'
#' @importFrom writexl write_xlsx
#' @export
#'
#' @examples
#' write_excel(dmdScheme(), file = tempfile())
#' write_excel(dmdScheme_raw(), file = tempfile())
#'
write_excel <- function(
  x,
  file,
  ...
) {

  if (!inherits(x, "dmdSchemeSet_raw")) {
    x <- as_dmdScheme_raw(x)
  }

# The column names with ... need to be set to "" --------------------------

  for (i in 1:length(x)) {
    toEmpty <- grep("^\\.\\.\\.[0-9]$", colnames(x[[i]]))
    if (length(toEmpty) > 0) {
      colnames(x[[i]])[toEmpty] <- ""
    }
  }

# Write excel file --------------------------------------------------------

  # tmpfile <- tempfile(fileext = ".xlsx")

  result <- writexl::write_xlsx(
    x = x,
    path = file,
    ...
  )
#
#   format_dmdScheme_xlsx(
#     fn_org = tmpfile,
#     fn_new = file,
#     keepData = TRUE
#   )


# Return result -----------------------------------------------------------

return(invisible(result))
}
