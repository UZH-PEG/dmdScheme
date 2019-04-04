#' Create examples in workingdirectoryt
#'
#' This function copies the installed example into the working directory so that it can be used.
#' @param name name of the example
#'
#' @return invisibly \code{NULL}
#'
#' @importFrom knitr purl
#' @importFrom utils RShowDoc
#'
#' @export
#'
#' @examples
#' make_example()
#' \dontrun{
#' make_example("basic")
#' }
make_example <- function(
  name
) {
  source_dir <- system.file("example_data", package = "emeScheme")
  examples <- list.dirs( source_dir, recursive = FALSE, full.names = FALSE)
  if (missing(name)) {
    cat_ln("Included examples are:")
    cat_ln(examples)
  } else {
    if (!(name %in% examples)) {
      stop("Invalid example. 'name' has to be one of the following values: ", examples, ".")
    }
    # Copy Example into working directory -------------------------------------
    if (file.exists( file.path(".", name) )) {
      stop("directory '", name, "' exists. I will not overwrite it. I haven't done anything. Example creation aborted.")
    }
    file.copy(
      from = file.path(source_dir, name),
      to = file.path("."),
      recursive = TRUE
    )
    if (name == "basic") {
      format_emeScheme_xlsx(
        fn_org = system.file("emeScheme.xlsx", package = "emeScheme"),
        fn_new = file.path(".", name, "expt1_emeScheme.xlsx"),
        keepData = TRUE
      )
      rmd <- list.files( file.path(".", "basic", "code"), pattern = "Rmd")
      for (f in rmd) {
        suppressMessages(
          knitr::purl(
            input = file.path(".", "basic", "code", f),
            output = file.path(".", "basic", "code", gsub("Rmd", "R", f)),
            documentation = 2,
            quiet = TRUE
          )
        )
      }
      utils::RShowDoc("user_manual", package = "emeScheme")
  }
  }
  return(invisible(NULL))
}
