#' Generic function to create the \code{index.md} file to accompany the data
#' deposit package
#'
#'
#' @param scheme a dmdScheme from which the values for the tokens in the
#'   \code{template} should be taken
#' @param path path to where the `index` should be created. The file name of the
#'   created index is identical to the file name of the template.
#' @param overwrite if TRUE, the target index file will be overwritten
#'   automatically, unless the target index is equal to the template, in which
#'   case, an error would be raised in all cases.
#' @param template template to be used for the index file. For details see the
#'   vignette \bold{Create and Customize the index template}. The default
#'   template is at \code{system.file("index.md", package = "dmdScheme")}
#' @param author of the index file
#' @param make character vector containing types into which the generated index
#'   file should be converted to. default is html and pdf. \bold{This function
#'   uses pandoc for the conversion!.}
#' @param pandoc_bin pandoc executable. Needs fully qualified path when not in
#'   \code{$PATH}.
#' @param pandoc_args arguments for calling pandoc
#' @param ... additional arguments for methods
#'
#' @return returns path to the created \code{index.md} file
#'
#' @rdname make_index
#' @export
#'
make_index <- function(
  scheme,
  path = ".",
  overwrite = FALSE,
  template = scheme_path_index_template(),
  author = NULL,
  make = c("html", "pdf"),
  pandoc_bin = "pandoc",
  pandoc_args = "-s",
  ...
){
  UseMethod( generic = "make_index", object = scheme)
}
