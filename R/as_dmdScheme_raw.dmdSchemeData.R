#' @importFrom tibble as_tibble add_column
#' @importFrom rlang !! :=
#'
#' @rdname as_dmdScheme_raw
#' @export
#'
as_dmdScheme_raw.dmdSchemeData <- function(
  x,
  ...
) {

  # Extraxt data ------------------------------------------------------------

  result <- suppressMessages( tibble::as_tibble(x) )

  if (attr(x, "propertyName") == "Experiment") {
    result <- cbind(nms = names(result), t(result))
    colnames(result) <- c("valueProperty", "DATA")
    result <- tibble::as_tibble(result)

    result <- tibble::add_column(
      result,
      propertySet = c( attr(x, "propertyName"), rep(NA, nrow(result) - 1) ),
      .before = 1
    )

    cns <- names(attributes(x))
    cns <- grep(
      "row.names|propertyName|names|class",
      cns,
      value = TRUE,
      invert = TRUE
    )

    for (cn in cns) {
      result <- tibble::add_column(
        result,
        !!(cn) := c( attr(x, cn) ),
        .before = ncol(result)
      )
    }
  } else {
    cns <- names(attributes(x))
    cns <- grep(
      "row.names|propertyName|names|class",
      cns,
      value = TRUE,
      invert = TRUE
    )
    cns <- rev(cns)
    cns <- c(cns, "names")

    for (cn in cns) {
      result <- rbind(
        attr(x, cn),
        result
      )
    }

    propSet <- names(attributes(x))
    propSet <- grep(
      "row.names|propertyName|names|class",
      propSet,
      value = TRUE,
      invert = TRUE
    )
    propSet <- c("valueProperty", propSet, "DATA", "MULTIPLE ROWS")

    noNAs <- nrow(result) - length(propSet)
    if (noNAs > 0) {
      propSet <- c(propSet,  rep(NA, noNAs))
    } else if (noNAs < 0) {
      result <- rbind(result, NA)
    }

    result <- tibble::add_column(
      result,
      propertySet = propSet,
      .before = 1
    )

    names(result) <- c("propertySet", attr(x, "propertyName"), rep(NA, ncol(result) - 2))
    result <- suppressMessages(
      as_tibble(result, .name_repair = "unique")
    )
  }



  # Make sure that all "NA" are set to NA -----------------------------------

  result[result == "NA"]  <- NA

  # set class ---------------------------------------------------------------

  class(result) <- append(
    "dmdSchemeData_raw",
    class(result)
  )

  rawClass <- paste0(class(x)[[1]], "_raw")
  if (rawClass != "dmdSchemeData_raw") {
    class(result) <- append(
      rawClass,
      class(result)
    )
  }

  # Return ------------------------------------------------------------------

  return(result)
}

