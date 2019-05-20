#' Create new \code{dmdSchemeData} class object from specifications
#'
#' Usually only called from within the function \code{new_dmdSchemeSet()}.
#' @param x a sheet of the spreadsheet displayed by calling
#'   \code{enter_new_metadata()} converted to a \code{data.frame} or
#'   \code{tibble} by calling \code{readxl::read_excel()}. Class has to be \code{dmdSchemeData_raw}.
#' @param keepData if the data should be trimmed to one row with NAs
#' @param convertTypes if \code{TRUE}, the types specified in the types column
#'   are used for the data type. Otherwise, they are left at type \code{character}
#' @param verbose give messages to make finding errors in data easier
#' @param warnToError if \code{TRUE}, warnings generated during the conversion will raise an error
#'
#' @return \code{dmdSchemeData} Data object
#'
#' @importFrom dplyr filter
#' @importFrom magrittr %<>% %>%
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#'
#' @export
#'
#' @examples
#' new_dmdSchemeData(dmdScheme_raw$Experiment)
#'
new_dmdSchemeData <- function(
  x,
  keepData = TRUE,
  convertTypes = TRUE,
  verbose = FALSE,
  warnToError = TRUE
  ) {

  if(verbose) cat_ln("propertySet : ", names(x)[[2]])


# Check for class dmdSchemeSet_raw ----------------------------------------

  if (!inherits(x, "dmdSchemeData_raw")) {
    stop("x has to be of class 'dmdSchemeData_raw'")
  }

# Set warn to 2 to convert warnings to errors -----------------------------

  if (warnToError) {
    oldWarn <- options()$warn
    options(warn = 2)

    on.exit(options(warn = oldWarn))
  }

# transpose when Experiment -----------------------------------------------

  if (x[[1,1]] == "Experiment") {
    if(verbose) cat_ln("Transposing...")
    #
    x %<>%
      t() %>%
      tibble::as_tibble(rownames = NA, .name_repair = "unique") %>%
      tibble::rownames_to_column("propertySet") %>%
      dplyr::rename(Experiment = 2) %>%
      dplyr::filter( .data$propertySet != "propertySet")
  }

# set all NA in valueProperty column to "NA" ------------------------------

  x$propertySet[is.na(x$propertySet)] <- "NA"

# set propertySetName -----------------------------------------------------

  attr(x, "propertyName") <- names(x)[[2]]

# set names ---------------------------------------------------------------

  if(verbose) cat_ln("Set names...")
  #
  names(x) <- as.character(dplyr::filter(x, .data$propertySet == "valueProperty"))

  x %<>% dplyr::filter(.data$valueProperty != "valueProperty")

# extract attributes to set -----------------------------------------------

  attrToSet <- x$valueProperty
  attrToSet <- attrToSet[1:(grep("DATA", x$valueProperty)-1)]

# set attributes ----------------------------------------------------------

  if(verbose) cat_ln("Set attributes...")
  #
  for (a in attrToSet) {
    attr(x, which = a) <- dplyr::filter(x, .data$valueProperty == a)[,-1] %>%
      unlist()
    x %<>% dplyr::filter(.data$valueProperty != a)
  }

# remove valueProperty column ---------------------------------------------

  x %<>% dplyr::select(-.data$valueProperty)

# if !keepData remove all but one data column , is not, only remove the ones with only NAs ----------------------------

  if (!keepData) {
    if(verbose) cat_ln("Trimming to one row of NAs...")
    #
    x %<>% dplyr::filter(c(TRUE, rep(FALSE, nrow(x)-1)) )
    x[] <- NA
  } else {
    allNA <- apply(
      is.na(x),
      1,
      all
    )
    x <- x[!allNA,]
  }

# apply type --------------------------------------------------------------

  if (convertTypes) {
    if(verbose) cat_ln("Apply types...")
    #
    type <- attr(x, "type")
    for (i in 1:ncol(x)) {
      if(verbose) cat_ln("   Apply type '", type[i], "' to '", names(x)[[i]], "'...")
      #
      x[[i]] <- as(x[[i]], Class = type[i])
    }
  }

# set class ---------------------------------------------------------------

  if(verbose) cat_ln("Set class...")
  #
  class(x) <- append(
    c(
      paste("dmdSchemeData", attr(x, "propertyName"), sep = "_"),
      "dmdSchemeData",
      "dmdScheme"
    ),
    class(x),
  )

  if(verbose) cat_ln("Done")
  #
# return object -----------------------------------------------------------

  return(x)
}
