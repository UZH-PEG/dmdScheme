#' Open the metadata scheme as a spreadsheet in a spreadsheet editor
#'
#' Open \code{system.file(paste0(schemeName, ".xlsx"), package = schemeName)} in excel.
#' New data can be entered and the file has to be saved at a different location
#' as it is a read-only file.
#'
#' @param file if not \code{NULL}, the template will be saved to this file.
#' @param open if \code{TRUE}, the file will be opened. This can produce different results depending on the OS, browsr and browser settings.
#' @param keepData if \code{TRUE} the data entry areas will be emptied. If \code{FALSE}. the example data will be included.
#' @param format if \code{FALSE} the sheet will be opened as the sheet is. if \code{TRUE}, it will be formated nicely.
#' @param overwrite if \code{TRUE}, the file specified in \code{file} will be overwritten. if \code{FALSE}, an error will be raised ehen the file exists.
#' @param verbose give verbose progress info. Useful for debugging.
#'
#' @return invisibly the fully qualified path to the file which \bold{would} have been opened, if \code{open == TRUE}.
#'
#' @importFrom utils browseURL URLencode packageName
#'
#' @export
#' @examples
#' \dontrun{
#' open_new_spreadsheet(schemeName = "dmdScheme", format = FALSE, verbose = TRUE)
#' }
#'
open_new_spreadsheet <- function(
  file = NULL,
  open = TRUE,
  keepData = FALSE,
  format = TRUE,
  overwrite = FALSE,
  verbose = FALSE
) {
  fn <- ""
  on.exit(
    {
      if (open & verbose) {
        message(
          "###############################################################\n",
          "## The template should have opened in Excel.                 ##\n",
          "##                                                           ##\n",
          "## If Excel is not in the foreground, it might               ##\n",
          "## have opened in the background.                            ##\n",
          "##                                                           ##\n",
          "## Depending on the browser, the file might                  ##\n",
          "## have been downloaded to the default download location.    ##\n",
          "##                                                           ##\n",
          "## If nothing happened either,                               ##\n",
          "## you can open the file directly in Excel from              ##\n",
          "##                                                           ##\n",
          "## In this case, please file a bug report at                 ##\n",
          "##                                                           ##\n",
          "##    https://github.com/Exp-Micro-Ecol-Hub/dmdScheme/issues ##\n",
          "##                                                           ##\n",
          "## and provide                                               ##\n",
          "##      - Operating System and version                       ##\n",
          "##      - Default browser                                    ##\n",
          "##      - file location                                      ##\n",
          "##                                                           ##\n",
          "## Thanks.                                                   ##\n",
          "###############################################################\n"
        )
      }
    }
  )
  ##

# Warning if `format = TRUE` ----------------------------------------------
  if (format) {
    message(
      "###############################################################\n",
      "## The argument `format` is set to TRUE (the default).       ##\n",
      "## Corruptions of the formated xlsx file are sometimes       ##\n",
      "## observed!.                                                ##\n",
      "##                                                           ##\n",
      "## If the resulting xlsx file is corrupt, please use         ##\n",
      "##                                                           ##\n",
      "## `format = FALSE`                                          ##\n",
      "##                                                           ##\n",
      "## when calling `open_new_spreadsheet()`                     ##\n",
      "##                                                           ##\n",
      "## However, this does NOT delete the example data.           ##\n",
      "###############################################################\n"
    )
  }

  schemeName <- scheme_path_xlsx()

# Temporary file name -----------------------------------------------------

  fnpath <- tempfile()
  dir.create(fnpath, recursive = TRUE)
  fn <- file.path( fnpath, basename(schemeName) )

# Format if asked for, otherwise copy to fn unchanged ---------------------

  schemeName <- scheme_path_xlsx()

  if (!file.exists(schemeName)) {
    stop("Scheme definition is not installed! Please use `scheme_list() to see all installed schemes!")
  }

  if (format) {
    format_dmdScheme_xlsx(
      fn_org = schemeName,
      fn_new = fn,
      keepData = keepData
    )
  } else {
    file.copy(
      from = schemeName,
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
    if (verbose) {
      message( "The template has been copied from",
               "          ", orgFn,
               "to",
               "          ", fn,
               ""
      )
    }
  }

# If open == TRUE, open the file ------------------------------------------

  if (open) {
    if (verbose) {
      message(
        "## Trying to open the file '", fn, "'\n",
        "## by opening it in the browser\n"
      )
    }
    fn <- utils::URLencode(fn)
    if (interactive()) {
      utils::browseURL(fn)
    } else {
      message("non-interactive session - would open the spreadsheet in interactive session.")
    }
  }

# Return invisibly the final file name ------------------------------------

  invisible(fn)
}

