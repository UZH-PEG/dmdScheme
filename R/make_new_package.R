#' Create anew package skelleton to add functiuonality to the currently active scheme.
#'
#' **This function is not for the user of a scheme, but for the development process of a new scheme.**
#'
#' A new metadata scheme can be created by using the function
#' \code{\link{scheme_make}}. This function will create a package to add
#' functionality to the currently used scheme as a package which will depend on
#' \code{scheme_active()}. This function uses the function `package.skeleton()`
#' from the `utils` package to create a new directory for the new metadata
#' scheme, and adds a function \code{aaa.R} which loads the current package
#' whenever the new package is loaded as well as some fields to the
#' \code{DESCRIPTION} file.
#'
#' For a documentation of the workflow to create a new scheme, see the vignette
#' **Howto Create a new scheme**.
#' @param path path where the package should be created. Default is the current
#'   working directory.
#'
#' @return invisibly \code{NULL}
#'
#' @importFrom utils package.skeleton
#' @export
#'
#' @md
#'
#' @examples
#' make_new_package(
#'   path = tempdir()
#' )
make_new_package <- function(
  path = "."
){
  success <- FALSE
  on.exit(
    {
      if (!success) {
        unlink(
          x = file.path(path, scheme_active()$name),
          recursive = TRUE,
          force = TRUE
        )
        stop("Something went wrong - package not created!")
      }
    }
  )

  # Create package skeleton -------------------------------------------------

  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  success <- TRUE
  utils::package.skeleton(
    name = scheme_active()$name,
    path = path,
    force = FALSE,
    code_files = system.file("aaa.R", package = packageName())
  )
  success <- FALSE

  # Add default scheme and version to aaa.R ---------------------------------

  aaaFile <- file.path(path, scheme_active()$name, "R", "aaa.R")
  aaa  <- readLines(aaaFile)
  aaa  <- gsub(pattern = "XXXyyyschemNameyyyXXX",    x = aaa, replacement = dmdScheme::scheme_active()$name   )
  aaa  <- gsub(pattern = "XXXyyyschemVersionyyyXXX", x = aaa, replacement = dmdScheme::scheme_active()$version)
  writeLines(aaa, con = aaaFile)

  # Add info to DECRIPTION file ---------------------------------------------

  cat(
    "LazyData: true",
    "Depends: dmdScheme",
    "\n",
    sep = "\n",
    file = file.path(path, scheme_active()$name, "DESCRIPTION"),
    append = TRUE
  )

  # Update from new sheet ---------------------------------------------------

  success <- TRUE

  invisible(NULL)
}
