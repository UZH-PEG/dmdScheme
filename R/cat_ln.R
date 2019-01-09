#' cat with linefeed at the end Title
#'
cat_ln <- function(...){
  cat(paste0( ...,  "\n"), sep = "")
}
