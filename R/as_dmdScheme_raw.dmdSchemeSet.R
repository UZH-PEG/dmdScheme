#' @rdname as_dmdScheme_raw
#' @export
#'
as_dmdScheme_raw.dmdSchemeSet <- function(
  x,
  ...
) {

  # Iterate through dmdScheme_raw and create dmdSchemeData objects -----------

  result <- lapply(
    x,
    as_dmdScheme_raw,
    ...
  )

  # Set version in Experiment as not available in the dmdSchemeData  --------

  v <- paste0("DATA ", attr(x, "dmdSchemeName"), " v", attr(x, "dmdSchemeVersion"))


  names(result[["Experiment"]])[[length(result[["Experiment"]])]] <- v

  # Set attributes ----------------------------------------------------------

  attr(result, "propertyName") <- attr(x, "propertyName")
  attr(result, "dmdSchemeName") <- attr(x, "dmdSchemeName")
  attr(result, "dmdSchemeVersion") <- attr(x, "dmdSchemeVersion")
  attr(result, "fileName") <- attr(x, "fileName")

  # set class ---------------------------------------------------------------

  class(result) <- append(
    "dmdSchemeSet_raw",
    class(result)
  )

  rawClass <- paste0(attr(result, "dmdSchemeName"), "Set_raw")
  if (rawClass != "dmdSchemeSet_raw") {
    class(result) <- append(
      rawClass,
      class(result)
    )
  }

  # Return ------------------------------------------------------------------

  return(result)
}

