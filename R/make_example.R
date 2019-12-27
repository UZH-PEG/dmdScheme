#' Create examples in working directory
#'
#' Each package based on a \code{dmdScheme} can contain examples. This function is the interface to these examples.
#' In the package \code{dmdScheme}, no examples are included.
#' The function has two basic usages:
#'   1. by using `make_example(schemeName = "NameOfTheScheme")` all included
#'      examples are listed
#'   2. by using `make_example(name = "basic", schemeName =
#'      "NameOfTheScheme")` it will create the example named `basic` in a
#'      subdirectory in the current working directory. An existing directory with
#'      the same name, will nod be overwritten!
#'
#' The examples have to be located in a directory called `example_data`.
#' The function is doing two things:
#'   1. Copying the **complete** directory from the `example_data` directory
#'      to the current working directory
#'   2. running `knitr::purl` on **all** `./code/*.Rmd` to extract the code into `.R`
#'      script files. If you want to include an RMarkdown files in the `./code`
#'      directory from thisa, use the `.rmd` extension (small letters).
#' @param name name of the example
#'
#' @return invisibly \code{NULL}
#'
#' @importFrom knitr purl
#' @importFrom utils RShowDoc
#'
#' @export
#'
#' @md
#' @examples
#' make_example()
#' \dontrun{
#' make_example("basic")
#' }
make_example <- function(
  name
) {
  example_dir <- cache("installedSchemes", paste0(scheme_active()$name, "_", scheme_active()$version), "examples")
  examples <- list.dirs( example_dir, recursive = FALSE, full.names = FALSE)


  if (missing(name)) {
    message("Included examples are:")
    message(paste(examples, collapse = "\n"))
  } else {
    if (!(name %in% examples)) {
      stop("Invalid example. 'name' has to be one of the following values: ", examples, ".")
    }

    # Define example and to directory -----------------------------------------

    example_dir <- file.path(example_dir, name)
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

    # Show name.html --------------------------------------------------------

    doc <- file.path(example_dir, paste0(name, ".html"))
    if (file.exists(doc)) {
      utils::browseURL(
        url = doc,
        encodeIfNeeded = TRUE
      )
    } else {
      message("No documentation included in the example `", name, "`!")
    }
  }

  # Return ------------------------------------------------------------------

  return(invisible(NULL))
}
