#' dmdScheme: A package containing the framework for Domain specific MetaData Schemes
#'
#' Metadata is essential for the managing and archiving of data. Consequentially, metadata
#' schemes, which standardise the property names used in specifying the metadata, play an essential role in this. Nevertheless (or because of this),
#' metadata schemes are usually big, complex, difficult to read and understand,
#' and, in consequence, are not used as often as they should be.
#'
#' This package provides a framework called `dmdScheme`, which
#'
#'   * **makes it easier to develop a domain specific metadata scheme**: by using a spreadsheet as the base for defining the new scheme
#'   * **provides basic functionality for the new metadata scheme**: including entering, validating, exporting and saving of the new metadata
#'   * **makies it easier to enter new metadata**: by uising a spreadsheet to enter the new metadata which can than be imported and exported as xml
#'
#'
#' This package provides for the **creator** of a new Domain Specific MetaData Scheme:
#'   1. a simple way of discussing and developing a new scheme as it is
#'   represented in a spreadsheet
#'   2. a function to create a new R package for a
#'   new domain specific metadata scheme which is based on a spreadsheet
#'   containing the definition and inherits all the functionality of this
#'   package (validation, printing, export, import, ...)
#'   3. easy update of the new scheme based by re-importing the new
#'   version of the scheme from the spreadsheet by simply calling one function
#'   4. easy extension of the functionality as the whole architecture is based
#'   on S3 methods and the new scheme inherits from the `dmdScheme` objects.
#'
#'
#' This package provides for the **user** of a Domain Specific MetaData Scheme:
#'   1. the authorative definition of an example `dmdScheme`
#'   2. object definitions for this scheme for R
#'   3. Excel spreadsheet for entering the metadata for an experiment
#'   4. functions to validate this metadata
#'   5. functions to export the metadata to xml files, one per data file
#'
#'
#' @md
#' @docType package
#' @name pkg.dmdScheme
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".", "dmdScheme", "dmdScheme_raw"))
