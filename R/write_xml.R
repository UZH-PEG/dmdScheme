#' Write write x as an XML file to disk
#'
#' Convert the object \code{x} to an \code{xml_document} object using the function \code{as_xml()} and write it to a file.
#' If no method \code{as_xml()} exists for the object |class{x}, an error will be raised.
#' @param x object which will be converted to and saved as an xml file.
#' @param file Path to file or connection to write to.
#' @param output specifies the content and format of the exported xml. see \link{as_xml} for details
#' @param ... additional parameter for the conversion function \code{as_xml}
#'
#' @importFrom xml2 write_xml
#' @export
#'
#' @examples
#' write_xml(dmdScheme(), file = tempfile())
#'
write_xml <- function(
  x,
  file,
  output = "metadata",
  ...
) {

  xml_list <- as_xml_list( x = x, output = output, ... )

  if (length(xml_list) == 1) {
    xml2::write_xml(
      x = xml_list[[1]],
      file = file
    )
    result <- file
  } else {
    path <- dirname(file)
    fn <- basename(file)

    result <- lapply(
      names(xml_list),
      function(nm) {
        xml <- xml_list[[nm]]
        fn <- file.path(
          path,
          paste(nm, "xml", sep = ".")
        )
        xml2::write_xml(
          x = xml,
          file = fn
        )
        fn
      }
    )
  }
  return(result)
}
