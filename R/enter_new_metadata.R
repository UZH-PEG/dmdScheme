#' Enter new metadata to fill a new scheme
#'
#' Open \code{emeScheme.xlsx} from system.file("inst", "googlesheet",
#' "emeScheme.xlsx", package = "emeScheme") in excel. New data can be entered
#' and the file has to be saved at a different location as it is a read-only
#' file.
#' @return NULL
#' @importFrom utils browseURL
#' @export
#' @examples
#' \dontrun{
#' enter_new_metadata()
#' }
#'
enter_new_metadata <- function() {
  fn <- system.file("inst", "googlesheet", "emeScheme.xlsx", package = "emeScheme")
  browseURL(fn)
}
