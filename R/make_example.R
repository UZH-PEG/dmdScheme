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
  example_dir <- system.file("example_data", package = "emeScheme")
  examples <- list.dirs( example_dir, recursive = FALSE, full.names = FALSE)
  if (missing(name)) {
    cat_ln("Included examples are:")
    cat_ln(examples)
  } else {
    if (!(name %in% examples)) {
      stop("Invalid example. 'name' has to be one of the following values: ", examples, ".")
    }

    # Define example and to directory -----------------------------------------

    example_dir <- system.file("example_data", name, package = "emeScheme")
    to_dir <- file.path(".", name)

    # Copy Example into working directory -------------------------------------

    if (file.exists( to_dir )) {
      stop("directory '", name, "' exists. I will not overwrite it. I haven't done anything. Example creation aborted.")
    }
    file.copy(
      from = example_dir,
      to = file.path("."),
      recursive = TRUE
    )

    # Extract R code from all .Rmd files --------------------------------------

    rmd <- list.files( file.path(to_dir, "code"), pattern = "Rmd")
    for (f in rmd) {
      suppressMessages(
        knitr::purl(
          input = file.path(to_dir, "code", f),
          output = file.path(to_dir, "code", gsub("Rmd", "R", f)),
          documentation = 2,
          quiet = TRUE
        )
      )
    }

    # Show user_manual --------------------------------------------------------

    utils::RShowDoc("user_manual", package = "emeScheme")
  }

  # Return ------------------------------------------------------------------

  return(invisible(NULL))
}
