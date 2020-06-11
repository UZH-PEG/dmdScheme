# dev
- Adds bibliometric metadata and handling of multiple "vertiiical" sheets
- Adds autocreation of index file which summarises the metadata
- Adds additional tests
# release 1.2
This is a feature add release.

New features are:
- default scheme (`dmdScheme 0.9.9`) includes bibliometric metadata
- all functions can now handle multiple "vertical" tabs / sheets
- the function `make_index()` creates an index document which is, when pandoc is installed, converted to word, pdf or html format. This is based on a template file which contains tokens which are replaced with metadatafrom a supplied scheme.

# release 1.1.3.1
Make use of pandoc in examples as dontrun to make CRAN happy

# release 1.1.3

Fix https://github.com/Exp-Micro-Ecol-Hub/dmdScheme/issues/23 which caused errors in validation due to CR LF versus LF in Excel sheet.

NB: The Description is now ignored in the structural validation!

# release 1.1.0

Doe to incompatibilities in the new release of tibble and expected incompatibilities o=in dplyr, these two dependencies were removed.

# release 1.0.0

* Due to change in serialization format in R 3.6.0, only compatible with R >= 3.5.0 

* suggestedValues validation has been, in case of a fail, be declassified as a Note (previous: Warning).
* Include wildcards and regular expressions in columnName in DataFileMetaData. Wildcards (i.e. * and ?) have to be enclosed by three exclamation marks (`!!!`), e.g. `Species_!!!*!!!` which will match all `Species_1` as well as `Species_Not KnownSoFar`. Regular expressions do not need to be enclosed with any special characters.
* fix error where a minimum of two rows were imported, even if the second one contains only NAs. Introduced an exclusion of all NA rows (commit db53c83).
* Add error level to print of validation results
* Add xml import to re-import xml data and validate certain features (types) during the import.

## Fix
* invalid xml export
* fixed missing export of ...ID fields


# release 0.9.1

* added descriptions of validation results and details to validate() function
TO BE ADDED FROM master

# release 0.9
* added suggestedValues to Measurement$dataExtractionMethod and Measurement$measuredFrom on spreadsheet
* added suggestedValues to Measurement$dataExtractionMethod and Measurement$measuredFrom on spreadsheet
* Measurement$dataExtractionMethod uses **none** as sugested on spreadsheet

# release 0.8
This is the first **beta** release for public testing and contains numerous changes from the earlier versions.
The scheme itself as well as the functions should be stable now.

# Rename to emeScheme 0.0.1.0

# microcosmScheme 0.0.0.9000

* Continuous work on scheme
* Added a `NEWS.md` file to track changes to the package.



**<span style="color:red">TODO</span>**
