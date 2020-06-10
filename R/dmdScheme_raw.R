#' Object of class \code{dmdScheme_raw } containing the raw data as read in.
#'
#' The dataset contains raw data. An object of class \code{dmdScheme_raw} is
#' returned by the function \code{\link[dmdScheme]{read_excel_raw}} with the argument
#' \code{raw = TRUE} and \code{\link[dmdScheme]{read_excel_raw}}. It is usually an
#' intermediate object, as in the normal workflow, this object is automatically
#' converted to an object of class \code{dmdSchemeSet}.
#'
#' \describe{
#'   \item{\code{dmdSchemeData_raw}: }{a \code{data.frame} as returned by the function \code{\link[readxl]{read_excel}} with the class \code{dmdSchemeData_raw}}
#'   \item{\code{dmdSchemeSet_raw: }}{a \code{list} with where each element is a \code{dmdSchemeData_raw} object with additional attributes:
#'     \describe{
#'       \item{propertyName: }{name of the dmdScheme for which this object contains the raw data. In the spreadsheet, it is in the cell H1 in ther in the Experiment tab (DATA dmeScheme v0.9.9.)}
#'       \item{dmdSchemeVersion: }{version of the dmdScheme used. In the spreadsheet, it is in the cell H1 in ther in the Experiment tab (DATA dmeScheme v0.9.9.)}
#'       \item{names: }{the names of the \code{dmdSchemeData_raw} sets. In the spreadsheet, the names of the tabs.}
#'     }
#'   }
#' }
#'
#' @aliases dmdSchemeSet_raw dmdSchemeData_raw
#' @export
#' @examples
#' dmdScheme_raw()
#'
dmdScheme_raw <- function(){
  return( get("dmdScheme_raw", envir = .dmdScheme_cache) )
}

