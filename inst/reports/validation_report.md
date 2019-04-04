---
params:
  author: unknown
  title: Validation
  x: NULL
  result: NULL
title: "Validation"
author: "unknown"
date: "2019-04-04"
output:
  html_document: 
    number_sections: true
    toc_depth: 3
    toc: true
    toc_float: true
    keep_md: true
  pdf_document: 
    number_sections: true
    toc_depth: 3
    toc: true
  word_document: 
    number_sections: true
    toc_depth: 3
    toc: true
---




* **Author**: unknown
* **emeScheme metadata name**: emeScheme
* **data package path**: `add this` 

# Introduction
This validation report validates the most likely an excelsheet containing the data.
The headers do represent sections of validations, while the bullets reperesent individual validations. Sections of the validation and are hierarchical, i.e. a higher level validation result depends on the lower level validation results. The headers and validations follow the structure of

**Error_Level** : **Name of the validation**

The error level can be:
- **OK**: the validation passed
- **note**: the validation contains an inconsistency which migh be an error or on purpose. Please check these!
- **warning**: the validation contains an inconsistency which could be an error or on purpose. Please check these!
- **error**: the validation failed and contains an error - needs to be fixewd before the data can be exported!

An ideal validation will not contain any errors or warnings.

Validation results are accumulated by forwarding the highest error to the validation of the next 
level. If validation 1.3. contains an error, 1. will be classified as an error as well, 
irrespective of 1.1, 1.2, ....

The details do contain the individual tests and are explained in detail in the sections

Details **Error_Level** : **Name of the validation**


<!-- ################################### -->
<!-- ################################### -->
<!-- Overall MetaData -->
<!-- ################################### -->
<!-- ################################### -->

# Overall

```r
valErr_extract(result) %>% 
  table %>% 
  set_names(valErr_info(names(.))$text)
```

```
##      OK warning   error 
##      15      11       7
```

# Overview

```r
print(result, level = 2, listLevel = 20, type = "summary")
```


## **<span style="color:black">Overall MetaData - NA</span>**

The result of the overall validation of the data.


### **<span style="color:#00FF00">Structural / Formal validity - OK</span>**

Test if the structure of the metadata is correct.  This includes column names, required info, ...  Should normally be OK, if no modification has been done.


### **<span style="color:#AA5500">Experiment - warning</span>**

Test if the metadata concerning **Experiment** is correct.  This includes column names, required info, ... 


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


### **<span style="color:#AA5500">Species - warning</span>**

Test if the metadata concerning **Species** is correct.  This includes column names, required info, ... 


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">Test if `speciesID` is unique - OK</span>**

Test if the speciesID is unique in this metadata set. The functions returns `TRUE` if all speciesID are unique.


#### **<span style="color:#00FF00">Test if the scientific name is correct - OK</span>**

Test if the scientific name in the column `name` is correct. This uses the function `taxize::gnr_resolve()` The functions returns `TRUE` if all species have a score of >= 0.7.


### **<span style="color:#AA5500">Treatment - warning</span>**

Test if the metadata concerning **Treatment** is correct.  This includes column names, required info, ... 


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">Test if treatmentID is in mappingColumn - warning</span>**

Test if the `treatmentID` is in the `DataFileMetaData$mappingColumn` column. The `error` can have the following values apart from `OK`:
 
    error   : If `treatmentID` contains missing values.
    warning : If not all `treatmentID` are in the `DataFileMetaData$mappingColumn`.
 



### **<span style="color:#AA5500">Measurement - warning</span>**

Test if the metadata concerning **Measurement** is correct.  This includes column names, required info, ... 


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">names unique - OK</span>**

Check if the names specified in `measurementID` are unique.


#### **<span style="color:#00FF00">measuredFrom is 'raw', 'NA', NA or in name - OK</span>**

Test if the `measuredFrom` is in the `x$Measurement$measurementID` column, 'raw', 'NA', or `NA`. The `error` is 'error' if can have the following values apart from `OK`:
 
    error   : If the value is not in in the `x$Measurement$measurementID` column, 'raw', 'NA', or `NA`
 



#### **<span style="color:#AA5500">Test if `variable` is in mappingColumn - warning</span>**

Test if the `variable` is in the `DataFileMetaData$mappingColumn` column. The `error` can have the following values apart from `OK`:
 
    error   : If `variable` contains missing values.
    warning : If not all `treatmentID` are in the `DataFileMetaData$mappingColumn`.
 



#### **<span style="color:#00FF00">dataExtractionID is 'none', 'NA', NA, or in DataExtraction$dataExtractionID - OK</span>**

Test if the `dataExtractionID` is in the `DataExtraction$dataExtractionID` column, 'none', 'NA', or `NA`. The `error` is 'error' if can have the following values apart from `OK`:
 
    error   : If the value is not in in the `DataExtraction$dataExtractionID` column, 'none', 'NA', or `NA`
 



### **<span style="color:#FF0000">DataExtraction - error</span>**

Test if the metadata concerning **DataExtraction** is correct.  This includes column names, required info, ... 


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">values in suggestedValues - OK</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#FF0000">names unique - error</span>**

Check if the names specified in `dataExtractionID` are unique.


#### **<span style="color:#AA5500">name is in Measurement$dataExtractionID - warning</span>**

Test if the `dataExtractionID` is in the `Measurement$dataExtractionID` column. The `error` can have the following values apart from `OK`:
 
    error   : If not all `dataExtractionID` are in `Measurement$dataExtractionID`
 



### **<span style="color:#FF0000">DataFileMetaData - error</span>**

Test if the metadata concerning **DataExtraction** is correct.  This includes column names, required info, ... 


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">values in allowedValues - OK</span>**

Test if the metadata entered is ion the allowedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#FF0000">`dataFile` exists in path - error</span>**

Test if all `dataFile` exist in the given `path`. The `error` can have the following values apart from `OK`:
 
    error   : If not all `dataFile` exist in the given `path`
 



#### **<span style="color:#00FF00">Test if date time format has been specified if required - OK</span>**

Test if date time format has been specified in the `description` column when `type` is equal to 'datetime'. The `error` can have the following values apart from `OK`:
 
    error   : If not all `description` contain a date time format when `type` equals 'datetime'
 
 DOES NOT YET CHECK FOR THE VALIDITY OF THE FORMAT!!!!!


#### **<span style="color:#FF0000">correct values in `mappingColumn`` in dependence on columnData - error</span>**

Test if `mappingColumn` is found in the appropriate table. The `error` can have the following values apart from `OK`:
 
    error   : If not all `mappingColumn` are found in the appropriate columns
 



#### **<span style="color:#FF0000">`columnName` in column names found in column names in `dataFileName` - error</span>**

Test if `columnName` is found in the `dataFileName`. The `error` can have the following values apart from `OK`:
 
    error   : If not all `columnName` are found in column names in `dataFileName`
 



#### **<span style="color:#FF0000">column names in dataFileName in `columnName` - error</span>**

Test if column names in `dataFileName` are found in `columnName`. The `error` can have the following values apart from `OK`:
 
    error   : If not all column names in `dataFileName` are found in `columnName`
 



### **<span style="color:black">Data Files - NA</span>**

Test if the data files as mentioned in `DataFileMetaData$dataFileName` is correct.  This includes column names, required info, ... 

## **<span style="color:red">TODO</span>** 
### result$DataFiles$header
result$DataFiles$description

- [ ] ranges of numeric columns
- [ ] values of text columns
- [ ] ???

### <== Treatment
- [ ] the **values** in the column describing the treatment (i.e. treatment levels) have to be in the column `Treatment$treatmentLevel` of the corresponding `Treatment$parameter`

### <== Measurement
- [ ] type checks of `columnName` compared to `type`

## Other Validity Checks
- [ ] ???


<!-- ################################### -->
<!-- ################################### -->
<!-- Details -->
<!-- ################################### -->
<!-- ################################### -->


# Details


```r
print(result, level = 2, listLevel = 20, type = "details", format = "markdown")
```


## **<span style="color:black">Overall MetaData - NA</span>**

The details contain the different validations of the metadata as a hierarchical list. errors propagate towards the root, i.e., if the 'worst' is a 'warning' in a validation in `details` the error here will be a 'warning' as well.



|x  |
|:--|
|NA |


### **<span style="color:#00FF00">Structural / Formal validity - OK</span>**

No further details available.



|x    |
|:----|
|TRUE |


### **<span style="color:#AA5500">Experiment - warning</span>**

No further details available.



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|name |temperature |light |humidity |incubator |container |microcosmVolume |mediaType |mediaConcentration |cultureConditions |comunityType |mediaAdditions |duration |comment |
|:----|:-----------|:-----|:--------|:---------|:---------|:---------------|:---------|:------------------|:-----------------|:------------|:--------------|:--------|:-------|
|TRUE |TRUE        |TRUE  |TRUE     |TRUE      |TRUE      |TRUE            |TRUE      |TRUE               |TRUE              |TRUE         |TRUE           |TRUE     |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell value is not contained in the suggestedValues list.
    TRUE : If the cell value is contained in the suggestedValues list.
    NA   : empty cell
 
 One or more FALSE values will result in a WARNING.



|temperature |light |humidity |incubator |cultureConditions |comunityType |
|:-----------|:-----|:--------|:---------|:-----------------|:------------|
|FALSE       |FALSE |FALSE    |FALSE     |TRUE              |FALSE        |


### **<span style="color:#AA5500">Species - warning</span>**

No further details available.



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|speciesID |name |strain |source |density |functionalGroup |comment |
|:---------|:----|:------|:------|:-------|:---------------|:-------|
|TRUE      |TRUE |TRUE   |TRUE   |TRUE    |TRUE            |TRUE    |
|TRUE      |TRUE |TRUE   |TRUE   |NA      |TRUE            |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell value is not contained in the suggestedValues list.
    TRUE : If the cell value is contained in the suggestedValues list.
    NA   : empty cell
 
 One or more FALSE values will result in a WARNING.



|density |functionalGroup |
|:-------|:---------------|
|FALSE   |TRUE            |
|TRUE    |FALSE           |


#### **<span style="color:#00FF00">Test if `speciesID` is unique - OK</span>**

Returns a named vector, with the following possible values:
 
    TRUE  : the value in `speciesID` is unique
    FALSE : the value in `speciesID` is not unique
 
 One or more FALSE or a missing value will result in an ERROR.



|speciesID |isOK |
|:---------|:----|
|tt_1      |TRUE |
|unknown   |TRUE |


#### **<span style="color:#00FF00">Test if the scientific name is correct - OK</span>**

The details are a table as returned from the funcrtion `taxize::gnr_resolve()`. The columns are:
 
    user_supplied_name : the name as in column `name`
    submitted_name     : the actual name passed on to be resolved
    matched_name       : the matched named
    data_source_title  : the name of the data source which returned the best match
    score              : a score from the match
 
 **Not matched species are not listed here!**.



|user_supplied_name      |submitted_name          |matched_name            |data_source_title | score|
|:-----------------------|:-----------------------|:-----------------------|:-----------------|-----:|
|Tetrahymena thermophila |Tetrahymena thermophila |Tetrahymena thermophila |NCBI              | 0.988|
|unknown                 |Unknown                 |Unknown                 |EOL               | 0.750|


### **<span style="color:#AA5500">Treatment - warning</span>**

No further details available.



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|treatmentID |unit |treatmentLevel |comment |
|:-----------|:----|:--------------|:-------|
|TRUE        |TRUE |TRUE           |NA      |
|TRUE        |NA   |TRUE           |NA      |
|TRUE        |TRUE |TRUE           |NA      |
|TRUE        |TRUE |TRUE           |NA      |
|TRUE        |TRUE |TRUE           |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell value is not contained in the suggestedValues list.
    TRUE : If the cell value is contained in the suggestedValues list.
    NA   : empty cell
 
 One or more FALSE values will result in a WARNING.



|treatmentID |unit  |treatmentLevel |
|:-----------|:-----|:--------------|
|FALSE       |FALSE |FALSE          |
|FALSE       |TRUE  |FALSE          |
|FALSE       |FALSE |FALSE          |
|FALSE       |FALSE |FALSE          |
|FALSE       |FALSE |FALSE          |


#### **<span style="color:#AA5500">Test if treatmentID is in mappingColumn - warning</span>**

The details are a table with one row per unique `treatmentID`. The following values are possible for the column `isTRUE`:
 
    TRUE : If the value is in `DataFileMetaData$mappingColumn`.
    FALSE: If the value is not in `DataFileMetaData$mappingColumn`.
    NA   : empty cell
 
 One or more FALSE or missing values values will result in an ERROR.



|treatmentID   |isOK  |
|:-------------|:-----|
|Lid_treatment |TRUE  |
|species_1     |TRUE  |
|species_2     |FALSE |
|species_3     |TRUE  |


### **<span style="color:#AA5500">Measurement - warning</span>**

No further details available.



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|measurementID |variable |method |unit |object |noOfSamplesInTimeSeries |samplingVolume |dataExtractionID |measuredFrom |comment |
|:-------------|:--------|:------|:----|:------|:-----------------------|:--------------|:----------------|:------------|:-------|
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell value is not contained in the suggestedValues list.
    TRUE : If the cell value is contained in the suggestedValues list.
    NA   : empty cell
 
 One or more FALSE values will result in a WARNING.



|variable |method |unit  |object |dataExtractionID |measuredFrom |
|:--------|:------|:-----|:------|:----------------|:------------|
|FALSE    |TRUE   |TRUE  |TRUE   |TRUE             |TRUE         |
|TRUE     |FALSE  |TRUE  |TRUE   |TRUE             |TRUE         |
|FALSE    |FALSE  |FALSE |TRUE   |TRUE             |TRUE         |
|TRUE     |FALSE  |FALSE |FALSE  |TRUE             |TRUE         |


#### **<span style="color:#00FF00">names unique - OK</span>**

Returns a named vector, with the following possible values:
 
    TRUE  : the value in `speciesID` is unique
    FALSE : the value in `speciesID` is not unique
 
 One or more FALSE or a missing value will result in an ERROR.



|measurementID        |isOK |
|:--------------------|:----|
|oxygen concentration |TRUE |
|abundance            |TRUE |
|smell                |TRUE |
|sequenceData         |TRUE |


#### **<span style="color:#00FF00">measuredFrom is 'raw', 'NA', NA or in name - OK</span>**

The details are a table with one row per unique `result$details The following values are possible for the column `isTRUE`:
 
    TRUE : If the value is in `x$Measurement$measurementID` column, 'raw', 'NA', or `NA`.
    FALSE: If the value is not in `x$Measurement$measurementID` column, 'raw', 'NA', or `NA`.
    NA   : empty cell
 
 One or more FALSE or missing values values will result in an ERROR.



|measurementID        |isOK |
|:--------------------|:----|
|oxygen concentration |TRUE |
|abundance            |TRUE |
|smell                |TRUE |
|sequenceData         |TRUE |


#### **<span style="color:#AA5500">Test if `variable` is in mappingColumn - warning</span>**

The details are a table with one row per unique `variable` The following values are possible for the column `isTRUE`:
 
    TRUE : If the value is in `DataFileMetaData$mappingColumn`.
    FALSE: If the value is not in `DataFileMetaData$mappingColumn.
    NA   : empty cell
 
 One or more FALSE or missing values values will result in an ERROR.



|variable  |isOK  |
|:---------|:-----|
|DO        |FALSE |
|abundance |TRUE  |
|smell     |TRUE  |
|DNA       |FALSE |


#### **<span style="color:#00FF00">dataExtractionID is 'none', 'NA', NA, or in DataExtraction$dataExtractionID - OK</span>**

The details are a table with one row per unique `result$details The following values are possible for the column `isTRUE`:
 
    TRUE : If the value is in `DataExtraction$dataExtractionID` column, 'none', 'NA', or `NA`
    FALSE: If the value is not in `DataExtraction$dataExtractionID` column, 'none', 'NA', or `NA`
    NA   : empty cell
 
 One or more FALSE will result in an ERROR.



|dataExtractionID    |isOK |
|:-------------------|:----|
|none                |TRUE |
|Mol_Analy_pipeline1 |TRUE |
|none                |TRUE |
|none                |TRUE |


### **<span style="color:#FF0000">DataExtraction - error</span>**

No further details available.



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|dataExtractionID |method |parameter |value |comment |
|:----------------|:------|:---------|:-----|:-------|
|TRUE             |NA     |NA        |NA    |TRUE    |
|NA               |NA     |NA        |NA    |NA      |


#### **<span style="color:#00FF00">values in suggestedValues - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell value is not contained in the suggestedValues list.
    TRUE : If the cell value is contained in the suggestedValues list.
    NA   : empty cell
 
 One or more FALSE values will result in a WARNING.



|method |
|:------|
|TRUE   |
|TRUE   |


#### **<span style="color:#FF0000">names unique - error</span>**

Returns a named vector, with the following possible values:
 
    TRUE  : the value in `speciesID` is unique
    FALSE : the value in `speciesID` is not unique
 
 One or more FALSE or a missing value will result in an ERROR.



|dataExtractionID    |isOK |
|:-------------------|:----|
|Mol_Analy_pipeline1 |TRUE |
|NA                  |TRUE |


#### **<span style="color:#AA5500">name is in Measurement$dataExtractionID - warning</span>**

The details are a table with one row per unique `variable` The following values are possible for the column `isTRUE`:
 
    TRUE : If the value is in `DataFileMetaData$mappingColumn`.
    FALSE: If the value is not in `DataFileMetaData$mappingColumn.
    NA   : empty cell
 
 One or more FALSE will result in an ERROR.



|dataExtractionID    |isOK  |
|:-------------------|:-----|
|Mol_Analy_pipeline1 |TRUE  |
|NA                  |FALSE |


### **<span style="color:#FF0000">DataFileMetaData - error</span>**

No further details available.



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|dataFileName |columnName |columnData |mappingColumn |type |description |comment |
|:------------|:----------|:----------|:-------------|:----|:-----------|:-------|
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |TRUE        |NA      |
|TRUE         |TRUE       |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |NA         |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |TRUE        |NA      |
|TRUE         |TRUE       |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |NA         |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |TRUE        |NA      |
|TRUE         |TRUE       |TRUE       |TRUE          |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |NA            |TRUE |NA          |NA      |
|TRUE         |TRUE       |TRUE       |TRUE          |TRUE |NA          |NA      |


#### **<span style="color:#00FF00">values in allowedValues - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell value is not contained in the allowedValues list.
    TRUE : If the cell value is contained in the allowedValues list.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|columnData |type |
|:----------|:----|
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |
|TRUE       |TRUE |


#### **<span style="color:#FF0000">`dataFile` exists in path - error</span>**

The details are a table with one row per unique `variable` The following values are possible for the column `isTRUE`:
 
    TRUE : If `dataFile` exist in the given `path`
    FALSE: If `dataFile` does not exist in the given `path`
    NA   : empty cell
 
 One or more FALSE or missing values will result in an ERROR.



|dataFileName                  |IsOK  |
|:-----------------------------|:-----|
|dissolved_oxygen_measures.csv |TRUE  |
|smell.csv                     |TRUE  |
|abundances.csv                |FALSE |


#### **<span style="color:#00FF00">Test if date time format has been specified if required - OK</span>**

The details are a table with one row per 'datetime' format row The following values are possible for the column `isTRUE`:
 
    TRUE : If `description` contains a value
    FALSE: If `description` does not contain a value
    NA   : empty cell
 
 One or more FALSE or missing values will result in an ERROR.



|dataFileName                  |columnName |type     |description |IsOK |
|:-----------------------------|:----------|:--------|:-----------|:----|
|dissolved_oxygen_measures.csv |Date_time  |datetime |ymdhms      |TRUE |
|smell.csv                     |Date       |datetime |ymdhms      |TRUE |
|abundances.csv                |Date_time  |datetime |ymdhms      |TRUE |


#### **<span style="color:#FF0000">correct values in `mappingColumn`` in dependence on columnData - error</span>**

The details are a table with one row per `mappingColumn` value format row The following values are possible for the column `isTRUE`:
 
    TRUE : If `mappingColumn` is found in ppropriate table or NA
    FALSE: If `mappingColumn` is not found in ppropriate table
 
 One or more FALSE or missing values will result in an ERROR.



|mappingColumn        |IsOK  |
|:--------------------|:-----|
|NA                   |FALSE |
|oxygen concentration |FALSE |
|NA                   |FALSE |
|NA                   |FALSE |
|NA                   |FALSE |
|NA                   |FALSE |
|Lid_treatment        |FALSE |
|NA                   |FALSE |
|NA                   |FALSE |
|species_1            |FALSE |
|smell                |FALSE |
|NA                   |FALSE |
|Lid_treatment        |FALSE |
|NA                   |FALSE |
|species_3            |FALSE |
|NA                   |FALSE |
|NA                   |FALSE |
|Lid_treatment        |FALSE |
|NA                   |FALSE |
|abundance            |FALSE |


#### **<span style="color:#FF0000">`columnName` in column names found in column names in `dataFileName` - error</span>**

The details are a table with one row per `columnName` value. The following values are possible for the column `isTRUE`:
 
    TRUE : If `columnName` is found in column names in `dataFileName` or NA
    FALSE: If `columnName` is not found in column names in `dataFileName`
 
 One or more FALSE or missing values will result in an ERROR.



|dataFileName                  |columnName    |IsOK  |
|:-----------------------------|:-------------|:-----|
|dissolved_oxygen_measures.csv |Jar_ID        |FALSE |
|dissolved_oxygen_measures.csv |DO            |FALSE |
|dissolved_oxygen_measures.csv |Unit_1        |FALSE |
|dissolved_oxygen_measures.csv |Mode          |FALSE |
|dissolved_oxygen_measures.csv |Location      |FALSE |
|dissolved_oxygen_measures.csv |Date_time     |FALSE |
|dissolved_oxygen_measures.csv |Lid_treatment |FALSE |
|dissolved_oxygen_measures.csv |Jar_type      |FALSE |
|dissolved_oxygen_measures.csv |Jar_ID        |FALSE |
|smell.csv                     |NA            |FALSE |
|smell.csv                     |smell         |FALSE |
|smell.csv                     |Date          |FALSE |
|smell.csv                     |Lid_treatment |FALSE |
|smell.csv                     |Jar_type      |FALSE |
|abundances.csv                |NA            |FALSE |
|abundances.csv                |Jar_ID        |FALSE |
|abundances.csv                |Date_time     |FALSE |
|abundances.csv                |Lid_treatment |FALSE |
|abundances.csv                |Jar_type      |FALSE |
|abundances.csv                |count_number  |FALSE |


#### **<span style="color:#FF0000">column names in dataFileName in `columnName` - error</span>**

The details are a list of tables, one per `dataFileName`,  indicating if the column names in `dataFileName` are found in `columnName`.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If column name in `dataFileName` is found in `columnName`
    FALSE: If column name in `dataFileName` is not found in `columnName`
 
 One or more FALSE will result in an ERROR.



|dataFile                      |columnNameInDataFileName |IsOK  |
|:-----------------------------|:------------------------|:-----|
|dissolved_oxygen_measures.csv |Jar_ID                   |TRUE  |
|dissolved_oxygen_measures.csv |DO                       |TRUE  |
|dissolved_oxygen_measures.csv |Unit_1                   |TRUE  |
|dissolved_oxygen_measures.csv |Mode                     |FALSE |
|dissolved_oxygen_measures.csv |Location                 |TRUE  |
|dissolved_oxygen_measures.csv |Date_time                |TRUE  |
|dissolved_oxygen_measures.csv |Lid_treatment            |FALSE |
|dissolved_oxygen_measures.csv |Jar_type                 |TRUE  |
|dissolved_oxygen_measures.csv |Jar_ID                   |TRUE  |

|dataFile  |columnNameInDataFileName |IsOK  |
|:---------|:------------------------|:-----|
|smell.csv |NA                       |FALSE |
|smell.csv |smell                    |FALSE |
|smell.csv |Date                     |TRUE  |
|smell.csv |Lid_treatment            |FALSE |
|smell.csv |Jar_type                 |TRUE  |

|dataFile       |columnNameInDataFileName |IsOK  |
|:--------------|:------------------------|:-----|
|abundances.csv |NA                       |TRUE  |
|abundances.csv |Jar_ID                   |FALSE |
|abundances.csv |Date_time                |FALSE |
|abundances.csv |Lid_treatment            |FALSE |
|abundances.csv |Jar_type                 |FALSE |
|abundances.csv |count_number             |FALSE |


### **<span style="color:black">Data Files - NA</span>**

No further details available.



|x  |
|:--|
|NA |



# Structure info

```r
attributes(x)
```

```
## $names
## [1] "Experiment"       "Species"          "Treatment"       
## [4] "Measurement"      "DataExtraction"   "DataFileMetaData"
## 
## $fileName
## [1] "emeScheme"
## 
## $class
## [1] "emeSchemeSet_raw" "list"
```

# Confirmation code

The following code needs to be entered in the `emeSchemeToXml()` function to confirm that the validation has been done and read. **No export is possible without this code!**:
 **<span style="color:red">TODO implement in emeSchemeToXML()</span>**

```
Please fix all errors before continuing!

The following code will not be printed in the final version!!!!!

2d3e68a6741bfe61626a0c26c8d9137fafd5d2c8
```


# <span style="color:red">TODO</span>  
- Use conditional text to explicitly say pass or fail, so that users don't have to read the R output (or at least get lovely green text for pass, and red for fail!)
- Validation out of attempt to parse date variables
