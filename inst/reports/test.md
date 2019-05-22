---
params:
  author: unknown
  title: Validation
  x: NULL
  result: NULL
title: "Validation of data against dmdScheme"
author: "Tester"
date: "2019-05-22"
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
    toc_depth: 3
    toc: true
---




* **Author**: Tester
* **dmdScheme metadata name**: 
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


# Details


```r
valErr_extract(result) %>% 
  table %>% 
  set_names(valErr_info(names(.))$text)
```

```
##    OK error 
##    17     2
```

## Errors

```r
print(result, level = 2, listLevel = 20, type = "details", error = 3)
```


## **<span style="color:#FF0000">Overall MetaData - error</span>**

The details contain the different validations of the metadata as a hierarchical list. errors propagate towards the root, i.e., if the 'worst' is a 'warning' in a validation in `details` the error here will be a 'warning' as well.



|x  |
|:--|
|NA |


### **<span style="color:#FF0000">DataFileMetaData - error</span>**

The details are a table with one row per unique validation.
 The column `Module` contains the name of the validation,
 The column `error` contains the actual error of the validation.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If the validation was `OK`.
    FALSE: If the validation was an `error`, `warning` or `note`.
    NA   : If at least one v alidation resulted in `NA
 
 One or more FALSE or missing values values will result in an ERROR.



|Module         |errorCode |isOK  |
|:--------------|:---------|:-----|
|types          |OK        |TRUE  |
|allowedValues  |OK        |TRUE  |
|dataFilesExist |error     |FALSE |


#### **<span style="color:#FF0000">`dataFile` exists in path - error</span>**

The details are a table with one row per unique `variable` The following values are possible for the column `isTRUE`:
 
    TRUE : If `dataFile` exist in the given `path`
    FALSE: If `dataFile` does not exist in the given `path`
    NA   : empty cell
 
 One or more FALSE or missing values will result in an ERROR.



|dataFileName                  |IsOK  |
|:-----------------------------|:-----|
|dissolved_oxygen_measures.csv |FALSE |
|smell.csv                     |FALSE |
|abundances.csv                |FALSE |

## Warnings

```r
print(result, level = 2, listLevel = 20, type = "details", error = 2)
```

## Notes

```r
print(result, level = 2, listLevel = 20, type = "details", error = 1)
```

## OK

```r
print(result, level = 2, listLevel = 20, type = "details", error = 0)
```


### **<span style="color:#00FF00">Structural / Formal validity - OK</span>**





|x    |
|:----|
|TRUE |


### **<span style="color:#00FF00">Experiment - OK</span>**

The details are a table with one row per unique validation.
 The column `Module` contains the name of the validation,
 The column `error` contains the actual error of the validation.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If the validation was `OK`.
    FALSE: If the validation was an `error`, `warning` or `note`.
    NA   : If at least one v alidation resulted in `NA
 
 One or more FALSE or missing values values will result in an ERROR.



|Module |errorCode |isOK |
|:------|:---------|:----|
|types  |OK        |TRUE |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|name |temperature |light |humidity |incubator |container |microcosmVolume |mediaType |mediaConcentration |cultureConditions |comunityType |mediaAdditions |duration |comment |
|:----|:-----------|:-----|:--------|:---------|:---------|:---------------|:---------|:------------------|:-----------------|:------------|:--------------|:--------|:-------|
|TRUE |TRUE        |TRUE  |TRUE     |TRUE      |TRUE      |TRUE            |TRUE      |TRUE               |TRUE              |TRUE         |TRUE           |TRUE     |NA      |


### **<span style="color:#00FF00">Genus - OK</span>**

The details are a table with one row per unique validation.
 The column `Module` contains the name of the validation,
 The column `error` contains the actual error of the validation.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If the validation was `OK`.
    FALSE: If the validation was an `error`, `warning` or `note`.
    NA   : If at least one v alidation resulted in `NA
 
 One or more FALSE or missing values values will result in an ERROR.



|Module  |errorCode |isOK |
|:-------|:---------|:----|
|types   |OK        |TRUE |
|IDField |OK        |TRUE |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|speciesID |colour |density |functionalGroup |comment |
|:---------|:------|:-------|:---------------|:-------|
|TRUE      |TRUE   |TRUE    |TRUE            |TRUE    |
|TRUE      |TRUE   |NA      |TRUE            |NA      |


#### **<span style="color:#00FF00">ID Field presendt and in the first column - OK</span>**

Returns a boolean value, with the following possible values:
 
    TRUE  : The tab's first column is an ID field
    FALSE : The tab's first column is not an ID field
 
 FALSE will result in an ERROR.



|hasIDField                       |isOK |
|:--------------------------------|:----|
|tab has ID field in first column |TRUE |


### **<span style="color:#00FF00">Treatments - OK</span>**

The details are a table with one row per unique validation.
 The column `Module` contains the name of the validation,
 The column `error` contains the actual error of the validation.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If the validation was `OK`.
    FALSE: If the validation was an `error`, `warning` or `note`.
    NA   : If at least one v alidation resulted in `NA
 
 One or more FALSE or missing values values will result in an ERROR.



|Module  |errorCode |isOK |
|:-------|:---------|:----|
|types   |OK        |TRUE |
|IDField |OK        |TRUE |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|treatmentID |treatmentLevelHeight |comment |
|:-----------|:--------------------|:-------|
|TRUE        |TRUE                 |NA      |
|TRUE        |TRUE                 |NA      |
|TRUE        |TRUE                 |NA      |
|TRUE        |TRUE                 |NA      |
|TRUE        |TRUE                 |NA      |


#### **<span style="color:#00FF00">ID Field presendt and in the first column - OK</span>**

Returns a boolean value, with the following possible values:
 
    TRUE  : The tab's first column is an ID field
    FALSE : The tab's first column is not an ID field
 
 FALSE will result in an ERROR.



|hasIDField                       |isOK |
|:--------------------------------|:----|
|tab has ID field in first column |TRUE |


### **<span style="color:#00FF00">Measurement - OK</span>**

The details are a table with one row per unique validation.
 The column `Module` contains the name of the validation,
 The column `error` contains the actual error of the validation.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If the validation was `OK`.
    FALSE: If the validation was an `error`, `warning` or `note`.
    NA   : If at least one v alidation resulted in `NA
 
 One or more FALSE or missing values values will result in an ERROR.



|Module  |errorCode |isOK |
|:-------|:---------|:----|
|types   |OK        |TRUE |
|IDField |OK        |TRUE |


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


#### **<span style="color:#00FF00">ID Field presendt and in the first column - OK</span>**

Returns a boolean value, with the following possible values:
 
    TRUE  : The tab's first column is an ID field
    FALSE : The tab's first column is not an ID field
 
 FALSE will result in an ERROR.



|hasIDField                       |isOK |
|:--------------------------------|:----|
|tab has ID field in first column |TRUE |


### **<span style="color:#00FF00">DataExtraction - OK</span>**

The details are a table with one row per unique validation.
 The column `Module` contains the name of the validation,
 The column `error` contains the actual error of the validation.
 The following values are possible for the column `isTRUE`:
 
    TRUE : If the validation was `OK`.
    FALSE: If the validation was an `error`, `warning` or `note`.
    NA   : If at least one v alidation resulted in `NA
 
 One or more FALSE or missing values values will result in an ERROR.



|Module  |errorCode |isOK |
|:-------|:---------|:----|
|types   |OK        |TRUE |
|IDField |OK        |TRUE |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

The details are a table of the same dimension as the input (green) area of the meatadata sheet. The following values are possible:
 
    FALSE: If the cell contains an error, i.e. can not be losslessly converted.
    TRUE : If the cell can be losslessly converted and is OK.
    NA   : empty cell
 
 One or more FALSE values will result in an ERROR.



|dataExtractionID |method |parameter |value |comment |
|:----------------|:------|:---------|:-----|:-------|
|TRUE             |NA     |NA        |NA    |TRUE    |


#### **<span style="color:#00FF00">ID Field presendt and in the first column - OK</span>**

Returns a boolean value, with the following possible values:
 
    TRUE  : The tab's first column is an ID field
    FALSE : The tab's first column is not an ID field
 
 FALSE will result in an ERROR.



|hasIDField                       |isOK |
|:--------------------------------|:----|
|tab has ID field in first column |TRUE |


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

# Structure info

```r
attributes(x)
```

```
## NULL
```

# <span style="color:red">TODO</span>  
- Use conditional text to explicitly say pass or fail, so that users don't have to read the R output (or at least get lovely green text for pass, and red for fail!)
- Validation out of attempt to parse date variables
