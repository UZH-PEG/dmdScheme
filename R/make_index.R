#' Generic function to create the \code{index.md} file to accompany the data deposit package
#'
#'
#' @param x object from which the index file shoulkd be created
#' @param ...
#' @param path path to where the file `index.md` should be created
#' @param overwrite if TRUE, the file will be overwritten automatically.
#'
#' @return returns TRUE when successfullu created
#'
#' @rdname as_dmdScheme
#' @export
#'
#' @examples
make_index <- function(
  x,
  path = ".",
  overwrite = TRUE,
  ...
){
  UseMethod( make_index, object = x)
}
