#' emeScheme: A package containing the definition for a metadata scheme for Experimental Microcosm Ecological experiments.
#'
#' Metadata is essential for the managing of data. Consequentally, metadata
#' schemes play an importent role in this. Nevertheless (or because of this),
#' metadata schemes are usuallu big, complex, difficult to read and understant,
#' and, in consequence, are not used as often as they dshould be. Therefore, we
#' developed a metadata scheme, called \code{emeScheme} which is focussed on one
#' homogeneous field, so that the metadata scheme is not to complex and can easiliy
#' used.
#' This package provides:
#' 1) the authorative definition of the emeScheme
#' 2) object definitions for this scheme for R
#' 3) Excel spreadsheet for entering the metadata for an experiment, i.e. multiple data files
#' 4) functions to validate this metadata
#' 5) functions to export the metadata to xml files, one per data file
#'
#' @docType package
#' @name pkg.emeScheme
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".", "emeScheme", "emeScheme_raw", "propSets"))
