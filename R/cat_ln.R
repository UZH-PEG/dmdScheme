#' cat with linefeed at the end Title
#'
#' Copied from tibble:::cat_line()
#' @param ... will be handed over to \code{cat(..., "\n")}
cat_ln <- function(...){
  cat(paste0( ...,  "\n"), sep = "")
}
