#' Enter new metadata to fill a new scheme
#'
#' Open \code{system.file("emeScheme.xlsx", package = "emeScheme")} in excel.
#' New data can be entered and the file has to be saved at a different location
#' as it is a read-only file.
#'
#' @param file if not \code{NULL}, the te,plate will be saved to this file.
#' @param open if \code{TRUE}, the file will be opened. This can produce different results depending on the OS, browsr and browser settings.
#' @param keepData if \code{TRUE} the data entry areas will be emptied. If \code{FALSE}. the example data will be included.
#' @param format if \code{FALSE} the sheet will be opened as the sheet is. if \code{TRUE}, it will be formated nicely.
#' @param overwrite if \code{TRUE}, the file specified in \code{file} will be overwritten. if \code{FALSE}, an error will be raised ehen the file exists.
#' @param verbose if \code{TRUE} print usefull information
#' @param .skipBrowseURL internal use (testing only). if \code{TRUE} skip the call of \code{browseURL()}
#'
#' @return invisibly the fully qualified path to the file which \bold{would} have been opened, if \code{open == TRUE}.
#' @importFrom utils browseURL URLencode
#' @export
#' @examples
#' \dontrun{
#' enter_new_metadata()
#' }
#'
enter_new_metadata <- function(
  file = NULL,
  open = TRUE,
  keepData = FALSE,
  format = TRUE,
  overwrite = FALSE,
  verbose = FALSE,
  .skipBrowseURL = FALSE
) {
  fn <- ""
  on.exit(
    {
      if (open & verbose) {
        cat_ln("The template should have opened in Excel.")
        cat_ln("If Excel is not in the foreground, it might have opened in the background.")
        cat_ln("Depending on the browser, the file might have been downloaded to the efault download location.")
        cat_ln("If nothing happened either, you can open the file directly in Excel from")
        cat_ln("          ", fn)
        cat_ln()
        cat_ln("In this case, please file a bug report at")
        cat_ln("          https://github.com/Exp-Micro-Ecol-Hub/emeScheme/issues")
        cat_ln("and provide")
        cat_ln("     - Operating System and version")
        cat_ln("     - Default browser")
        cat_ln("     - file location")
        cat_ln()
        cat_ln("Thanks.")
      }
    }
  )
  ##

# Warning if `format = TRUE` ----------------------------------------------
  if (format) {
    warning(
    "The argument `format` is set to TRUE (the default).\n",
    "Corruptions of the formated xlsx filer were recently observed!.\n",
    "\n",
    "If the resulting xlsx file is corrupt, please use\n",
    "\n",
    "`format = FALSE`",
    "\n",
    "when calling `enter_new_metadata()`\n",
    "\n",
    "This does NOT delete the example data.\n"
    )
  }

# Temporary file name -----------------------------------------------------

  fn <- tempfile(pattern = "emeScheme.", fileext = ".xlsx")

# Format if asked for, otherwise copy to fn unchanged ---------------------

  if (format) {
    format_emeScheme_xlsx(
      fn_org = system.file("emeScheme.xlsx", package = "emeScheme"),
      fn_new = fn,
      keepData = keepData
    )
  } else {
    file.copy(
      from = system.file("emeScheme.xlsx", package = "emeScheme"),
      to = fn
    )
  }

# If file specified, copy temporary file to final destination -------------

  if (!is.null(file)) {
    result <- file.copy(
      from = fn,
      to = file,
      overwrite = overwrite
    )
    if (!result) {
      stop("Error during copying of the file from\n    ", fn, "\nto    ", file, "!\n Possibly because the file exists?")
    }
    orgFn <- fn
    fn <- file
    Sys.chmod(fn, "0755")
    if (verbose){
      cat_ln("The template has been copied from")
      cat_ln("          ", orgFn)
      cat_ln("to")
      cat_ln("          ", fn)
      cat_ln()
    }
  }

# If open == TRUE, open the file ------------------------------------------

  if (open) {
    if (verbose) {
      cat_ln("Trying to open the file by opening it in the browser'", fn, "'... ")
      cat_ln()
    }
    fn <- utils::URLencode(fn)
    if (!.skipBrowseURL) {
      utils::browseURL(fn)
    }
  }

# Return invisibly the final file name ------------------------------------

  invisible(fn)
}

