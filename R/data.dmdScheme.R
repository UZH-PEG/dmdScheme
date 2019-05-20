#' Authorative definition of the dmdScheme.
#'
#' The dataset contains the authorative definition of the dmdScheme.
#' There are three S3 classes defined and used:
#' \describe{
#'   \item{\code{dmdScheme: }}{all all properties in the scheme have the class
#'     \code{dmdScheme}} \item{\code{dmdSchemeSet: }}{Property Sets which contain
#'     other Property Sets have the class \code{dmdSchemeSet}}
#'   \item{\code{dmdSchemeData: }}{Propertiey Sets which contain only Value
#'     Properties (in R a \code{tibblle}) have the class \code{dmdSchemeData}}
#' }
#'
#' In addition, the last two properties are available with a \code{_NAME} suiffix, specifyinf the name of the Property.
#' \describe{
#'   \item{Property Level x}{TODO}
#'   ...
#' }
#'
#' @examples
#' \dontrun{
#' ## Created by using
#' dmdScheme <- new_dmdSchemeSet(
#'   x = dmdScheme_raw,
#'   keepData = FALSE,
#'   verbose = TRUE
#' )
#' }
"dmdScheme"
