#' Title
#'
#'
#' @importFrom tools file_ext
#' @importFrom knitr kable
#' @importFrom stringr str_length str_pad
#' @export
#'
#' @rdname make_index
#'
#' @examples
#' \dontrun{
#'   # takes to long for CRAN
#'   make_index( dmdScheme_example(), path = tempdir() )
#' }
#'
make_index.dmdSchemeSet <- function(
  scheme,
  path = ".",
  overwrite = FALSE,
  template = scheme_path_index_template(),
  author = NULL,
  make = c("pdf", "html"),
  pandoc_bin = "pandoc",
  pandoc_args = "-s",
  ...
) {

  # HELPER toString.data.frame ----------------------------------------------
  ## From Bruno Zamengo - see https://stackoverflow.com/a/45541857/632423

  toString.data.frame = function (
    object,
    ...,
    digits = NULL,
    quote = FALSE,
    right = TRUE,
    row.names = TRUE,
    cellSep = ""
  ) {
    nRows = length(row.names(object));
    if (length(object)==0) {
      return(paste(
        sprintf(ngettext(nRows, "data frame with 0 columns and %d row", "data frame with 0 columns and %d rows")
                , nRows)
        , "\\n", sep = "")
      );
    } else if (nRows==0) {
      return(gettext("<0 rows> (or 0-length row.names)\\n"));
    } else {
      # get text-formatted version of the data.frame
      m = as.matrix(format.data.frame(object, digits=digits, na.encode=FALSE));
      # define row-names (if required)
      if (isTRUE(row.names)) {
        rowNames = dimnames(object)[[1]];
        if(is.null(rowNames)) {
          # no row header available -> use row numbers
          rowNames = as.character(1:NROW(m));
        }
        # add empty header (used with column headers)
        rowNames = c("", rowNames);
      }
      # add column headers
      m = rbind(dimnames(m)[[2]], m);
      # add row headers
      m = cbind(rowNames, m);
      # max-length per-column
      maxLen = apply(apply(m, c(1,2), stringr::str_length), 2, max, na.rm=TRUE);

      # add right padding
      ##  t is needed because "If each call to FUN returns a vector of length n, then apply returns an array of dimension c(n, dim(X)[MARGIN])"
      m = t(apply(m, 1, stringr::str_pad, width=maxLen, side="right"));
      m = t(apply(m, 1, stringr::str_pad, width=maxLen+3, side="left"));
      # merge columns
      m = apply(m, 1, paste, collapse = cellSep);
      # merge rows (and return)
      return(paste(m, collapse="\n"));
    }
  }


  # HELPER: lookup_to_md ----------------------------------------------------

  lookup_to_md <- function( lookup ) {
    options(knitr.kable.NA = "")
    result <- lapply(
      lookup,
      function(x){
        if (inherits(x, "data.frame")){
          md <- knitr::kable(x, format = "markdown")
          md <- paste(md, collapse = "\n")
        } else {
          md <- as.character(x)
          md <- paste( md, collapse = ", ")
        }
        return( md )
      }
    )
    return(result)
  }

  # HELPER: lookup_to_text --------------------------------------------------

  lookup_to_text <- function( lookup) {
    result <- lapply(
      lookup,
      function(x){
        if (inherits(x, "data.frame")){
          md <- toString( x, format = "markdown")
        } else {
          md <- toString(x)
        }
        return(md)
      }
    )
    return(result)
  }

  # The creation of index ---------------------------------------------------

  fn <- file.path(path, basename(template))

  # Check fn and template paths ---------------------------------------------

  if (path.expand(fn) == path.expand(template)) {
    stop("The output file is the same as the template and it is not possible to overwrite the template!")
  }
  if (file.exists(fn)) {
    if (!overwrite) {
      stop("File ", fn, " does Exist!\n", "If you want to overwrite it, use `overwrite = TRUE`!")
    }
  }
  if (!file.exists(template)) {
    stop("Template does not exist!")
  }

  # Replace tokens ----------------------------------------------------------

  index <- readLines(template)

  tokenlines <- grep("%%\\S*%%", index, value = TRUE)
  tokens <- simplify2array(
    regmatches(tokenlines, gregexpr( "%%(.*?)%%", tokenlines, perl = TRUE ))
  )
  tokens <- grep("%%\\S*%%", tokens, value = TRUE)
  lookup <- lookup_tokens(tokens, scheme, author)

  lookup <- switch (
    tools::file_ext(template),
    md = lookup_to_md(lookup),
    txt = lookup_to_text(lookup),
    lookup_to_text(lookup)
  )

  for (token in names(lookup)) {
    index <- gsub(
      pattern = token,
      replacement = lookup[[token]],
      x = index
    )
  }

  writeLines(index, fn)

  # TODO - add tests before trying!

  for (type_out in make) {
    fn_in <- fn
    type_in <- tools::file_ext(fn_in)
    fn_out <- gsub(
      paste0(".", type_in),
      paste0(".", type_out),
      fn
    )
    arguments <- paste( " ", pandoc_args, fn_in,  "-o", fn_out)
    message("Using pandoc command `", pandoc_bin, arguments, "`")
    system2(
      command = pandoc_bin,
      args = arguments
    )
  }

  invisible(index)
}
