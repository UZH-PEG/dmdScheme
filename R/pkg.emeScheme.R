#' emeScheme: A package containing the definition for a metadata scheme for Experimental Microcosm Ecological experiments.
#'
#' The package provides:
#' 1) the authorative definition of the emeScheme
#' 2) object definitions for this scheme for R
#'
#' @docType package
#' @name pkg.emeScheme
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".", "emeScheme", "emeScheme_raw", "propSets"))
