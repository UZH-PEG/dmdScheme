#' Authorative definition of the emeScheme.
#'
#' The dataset contains the authorative definition of the emeScheme.
#' There are three S3 classes defined and used:
#' \describe{
#'   \item{\code{emeScheme: }}{all all properties in the scheme have the class
#'     \code{emeScheme}} \item{\code{emeSchemeSet: }}{Property Sets which contain
#'     other Property Sets have the class \code{emeSchemeSet}}
#'   \item{\code{emeSchemeData: }}{Propertiey Sets which contain only Value
#'     Properties (in R a \code{tibblle}) have the class \code{emeSchemeData}}
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
#' emeScheme <- new_emeSchemeSet(
#'   x = emeScheme_raw,
#'   keepData = FALSE,
#'   verbose = TRUE
#' )
#' }
"emeScheme"
