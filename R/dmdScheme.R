#' Object of class \code{dmdSchemeSet} containing the authorative definition of the dmdScheme.
#'
#' The dataset contains the authorative definition of the dmdScheme. It contains no data, except one row \code{NA}.
#' There are two S3 classes defined and used:
#' \describe{
#'   \item{\code{dmdSchemeData}: }{a \code{data.frame} with the class \code{dmdSchemeData}.
#'     Each column is one property of the metadata. It has the following attributes:
#'     \describe{
#'       \item{propertyName: }{name of the data. In the spreadsheet, it is in the cell below (in the Experiment tab) or to the right (other tabs).}
#'       \item{unit: }{the unit of the data in each column.}
#'       \item{type: }{the type of the data in the column. These will be validated in the \code{\link[dmdScheme]{validate}} function. See there for details.}
#'       \item{suggestedValues: }{suggested values for the data of each column. These will be validated in the \code{\link[dmdScheme]{validate}} function. See there for details.}
#'       \item{allowedValues: }{allowed values for the data of each column. These will be validated in the \code{\link[dmdScheme]{validate}} function. See there for details.}
#'       \item{Description: }{general description of the columns.}
#'       \item{names: }{the names of the columns.}
#'     }
#'   }
#'   \item{\code{dmdSchemeSet: }}{a \code{list} with where each element is a \code{dmdSchemeData} object with additional attributes:
#'     \describe{
#'       \item{propertyName: }{name of the dmdScheme used. In the spreadsheet, it is in the cell H1 in ther in the Experiment tab (DATA dmeScheme v0.9.9.)}
#'       \item{dmdSchemeVersion: }{version of the dmdScheme used. In the spreadsheet, it is in the cell H1 in ther in the Experiment tab (DATA dmeScheme v0.9.9.)}
#'       \item{names: }{the names of the \code{dmdSchemeData} sets. In the spreadsheet, the names of the tabs.}
#'     }
#'   }
#' }
#'
#' @aliases dmdSchemeSet dmdSchemeData
#' @export
#' @examples
#' dmdScheme()
#'
dmdScheme <- function(){
  return( get("dmdScheme", envir = .dmdScheme_cache) )
}

