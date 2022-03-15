#' @rdname as_dmdScheme_raw
#' @export
#'
as_dmdScheme_raw.dmdSchemeData <- function(
  x,
  ...
) {

  # Extraxt data ------------------------------------------------------------
  result <- as.data.frame(x, stringsAsFactors = FALSE)

  cns <- names(attributes(x))
  cns <- grep(
    "row.names|propertyName|names|class",
    cns,
    value = TRUE,
    invert = TRUE
  )

  if (toTranspose(attr(x, "propertyName"))) {

    result <- cbind(nms = names(result), t(result))
    colnames(result) <- c("valueProperty", "DATA")
    result <- as.data.frame(result, stringsAsFactors = FALSE)
    rownames(result) <- 1:nrow(result)

    result <- cbind.data.frame(
      propertySet = c( attr(x, "propertyName"), rep(NA, nrow(result) - 1) ),
      result,
      stringsAsFactors = FALSE
    )

    for (cn in cns) {
      result <- cbind.data.frame(
        result,
        attr(x, cn),
        stringsAsFactors = FALSE
      )
      colnames(result)[ncol(result)] <- cn
    }

    nm <- colnames(result)
    result <- result[c( nm[1:2], cns, nm[3] )]


  } else {

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

    result <- cbind.data.frame(
      propertySet = propSet,
      result,
      stringsAsFactors = FALSE
    )

    # result <- tibble::add_column(
    #   result,
    #   propertySet = propSet,
    #   .before = 1
    # )

    # Emulate the name repair = "unique" from readxl::read_excel ----------------


    names(result) <- c("propertySet", attr(x, "propertyName"), paste0("...", 3:length(names(result) )))

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

