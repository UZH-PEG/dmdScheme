#' @importFrom magrittr %<>% %>%
#' @importFrom rlang .data
#'
#' @rdname as_dmdScheme
#' @export
#'
as_dmdScheme.dmdSchemeData_raw <- function(
  x,
  keepData = TRUE,
  convertTypes = TRUE,
  warnToError = TRUE,
  checkVersion = TRUE,
  ...,
  verbose = FALSE
  ) {

# Check for class dmdSchemeSet_raw ----------------------------------------

  if (!inherits(x, "dmdSchemeData_raw")) {
    stop("x has to inherit from class 'dmdSchemeData_raw'")
  }

# identify class ----------------------------------------------------------

  newClass <- class(x)[[1]]
  newClass <- gsub("_raw", "", newClass)
  if (newClass != "dmdSchemeData") {
    newClass <- c(newClass, "dmdSchemeData")
  }


# Remove _raw classes -----------------------------------------------------

  class(x) <- grep("_raw", class(x), invert = TRUE, value = TRUE)

# Set warn to 2 to convert warnings to errors -----------------------------

  if (warnToError) {
    oldWarn <- options()$warn
    options(warn = 2)

    on.exit(options(warn = oldWarn))
  }

# transpose when toTranspose() -----------------------------------------------

  if (toTranspose(x[[1,1]])) {
    if (verbose) message("Transposing ", x[[1,1]], "...")
    #

    x <- rbind(NA, x)
    x[1,] <- names(x)
    rownames(x) <- c(x[1:2,1], 2:(nrow(x) - 1))
    x <- x[,-1]
    x <- as.data.frame(t(as.matrix(x)), stringsAsFactors = FALSE)
  }

  if (verbose) message("Processing propertySet : ", names(x)[[2]])

# set all NA in valueProperty column to "NA" ------------------------------

  x$propertySet[is.na(x$propertySet)] <- "NA"

# set propertySetName -----------------------------------------------------

  attr(x, "propertyName") <- NA

# set names ---------------------------------------------------------------

  if (verbose) message("Set names...")
  #
  # names(x) <- as.character(dplyr::filter(x, .data$propertySet == "valueProperty"))
  names(x) <- as.character(x[x[["propertySet"]] == "valueProperty",])

  # x %<>% dplyr::filter(.data$valueProperty != "valueProperty")
  x <- x[!x[["valueProperty"]] == "valueProperty",]

# extract attributes to set -----------------------------------------------

  attrToSet <- x$valueProperty
  attrToSet <- attrToSet[ 1:(grep("DATA", x$valueProperty) - 1) ]

# set attributes ----------------------------------------------------------

  if (verbose) message("Set attributes...")
  #
  for (a in attrToSet) {
    attr(x, which = a) <- as.character(x[x[["valueProperty"]] == a,])[-1]
    # dplyr::filter(x, .data$valueProperty == a)[,-1] %>%
    #  unlist() %>%
    #  as.vector()
    # x %<>% dplyr::filter(.data$valueProperty != a)
    x <- x[x[["valueProperty"]] != a,]
    rownames(x) <- NULL
  }

# remove valueProperty column ---------------------------------------------

  # x %<>% dplyr::select(-.data$valueProperty)
  attrs <- attributes(x)
  x <- x[-which(names(x) == "valueProperty")]
  attrs[["names"]] <- grep( "valueProperty", attrs[["names"]], value = TRUE, invert = TRUE)
  attributes(x) <- attrs

# if !keepData remove all but one data column , is not, only remove the ones with only NAs ----------------------------

  if (!keepData) {
    if (verbose) message("Trimming to one row of NAs...")
    #
    # x %<>% dplyr::filter(c(TRUE, rep(FALSE, nrow(x) - 1)) )
    x <- x[1,]
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

    # REPLACE x[[i]][] <- Map(`class<-`, x[[i]], types)

    if (verbose) message("Apply types...")
    #
    type <- attr(x, "type")
    for (i in 1:ncol(x)) {
      if (verbose) message("   Apply type '", type[i], "' to '", names(x)[[i]], "'...")
      #
      x[[i]] <- as(x[[i]], Class = type[i])
    }
  }

# set class ---------------------------------------------------------------

  if (verbose) message("Set class...")
  #
  class(x) <- append(
    newClass ,
    class(x),
  )

  if (verbose) message("Done")

  # attributes(x) <- attributes(x)[ order(names(attributes(x))) ]

# return object -----------------------------------------------------------

  return(x)
}
