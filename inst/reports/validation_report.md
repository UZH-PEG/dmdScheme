---
params:
  author: unknown
  title: Validation
  x: NULL
  result: NULL
title: "Validation"
author: "unknown"
date: "2019-03-28"
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
##      15      12       3
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

To Be Added


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


### **<span style="color:#AA5500">Species - warning</span>**

To Be Added


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">name in species database and report score (using taxize::gnr_resolve()) - OK</span>**

To Be Added


### **<span style="color:#AA5500">Treatment - warning</span>**

To Be Added


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">treatmentID is in mappingColumn - warning</span>**

To Be Added


### **<span style="color:#AA5500">Measurement - warning</span>**

To Be Added


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">names unique - OK</span>**

Check if the names specified in `measurementID` are unique.


#### **<span style="color:#00FF00">measuredFrom is 'raw', 'NA', NA or in name - OK</span>**

Check if the names specified in `measurementID` are unique.


#### **<span style="color:#AA5500">variable is in mappingColumn - warning</span>**

To Be Added


#### **<span style="color:#00FF00">dataExtractionID is 'none', 'NA', NA, or in DataExtraction$dataExtractionID - OK</span>**

To Be Added


### **<span style="color:#AA5500">DataExtraction - warning</span>**

To Be Added


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">values in suggestedValues - OK</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">names unique - OK</span>**

Check if the names specified in `dataExtractionID` are unique.


#### **<span style="color:#AA5500">name is in Measurement$dataExtractionID - warning</span>**

To Be Added


### **<span style="color:black">DataFileMetaData - NA</span>**

To Be Added


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#00FF00">values in allowedValues - OK</span>**

Test if the metadata entered is ion the allowedValues list. The value NA is allowed in all column types, empty cells should be avoided.


#### **<span style="color:#FF0000">dataFile exists in path - error</span>**

To Be Added


#### **<span style="color:#00FF00">if type == 'datetime', description has format information - OK</span>**

To Be Added


#### **<span style="color:black">correct values in mappingColumn in dependence on columnData - NA</span>**

To Be Added


#### **<span style="color:#FF0000">columnName in column names in dataFileName - error</span>**

To Be Added


#### **<span style="color:#FF0000">column names in dataFileName in columnName - error</span>**

To Be Added


### **<span style="color:black">Data Files - NA</span>**

To Be Added

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

The result of the overall validation of the data.



|x  |
|:--|
|NA |


### **<span style="color:#00FF00">Structural / Formal validity - OK</span>**

Test if the structure of the metadata is correct.  This includes column names, required info, ...  Should normally be OK, if no modification has been done.



|x    |
|:----|
|TRUE |


### **<span style="color:#AA5500">Experiment - warning</span>**

To Be Added



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.



|name |temperature |light |humidity |incubator |container |microcosmVolume |mediaType |mediaConcentration |cultureConditions |comunityType |mediaAdditions |duration |comment |
|:----|:-----------|:-----|:--------|:---------|:---------|:---------------|:---------|:------------------|:-----------------|:------------|:--------------|:--------|:-------|
|TRUE |TRUE        |TRUE  |TRUE     |TRUE      |TRUE      |TRUE            |TRUE      |TRUE               |TRUE              |TRUE         |TRUE           |TRUE     |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.



|temperature |light |humidity |incubator |cultureConditions |comunityType |
|:-----------|:-----|:--------|:---------|:-----------------|:------------|
|FALSE       |FALSE |FALSE    |FALSE     |TRUE              |FALSE        |


### **<span style="color:#AA5500">Species - warning</span>**

To Be Added



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.



|speciesID |name |strain |source |density |functionalGroup |comment |
|:---------|:----|:------|:------|:-------|:---------------|:-------|
|TRUE      |TRUE |TRUE   |TRUE   |TRUE    |TRUE            |TRUE    |
|TRUE      |TRUE |TRUE   |TRUE   |NA      |TRUE            |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.



|density |functionalGroup |
|:-------|:---------------|
|FALSE   |TRUE            |
|TRUE    |FALSE           |


#### **<span style="color:#00FF00">name in species database and report score (using taxize::gnr_resolve()) - OK</span>**

To Be Added



|user_supplied_name      |submitted_name          |matched_name            |data_source_title | score|
|:-----------------------|:-----------------------|:-----------------------|:-----------------|-----:|
|Tetrahymena thermophila |Tetrahymena thermophila |Tetrahymena thermophila |NCBI              | 0.988|
|unknown                 |Unknown                 |Unknown                 |EOL               | 0.750|


### **<span style="color:#AA5500">Treatment - warning</span>**

To Be Added



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.



|treatmentID |unit |treatmentLevel |comment |
|:-----------|:----|:--------------|:-------|
|TRUE        |TRUE |TRUE           |NA      |
|TRUE        |NA   |TRUE           |NA      |
|TRUE        |TRUE |TRUE           |NA      |
|TRUE        |TRUE |TRUE           |NA      |
|TRUE        |TRUE |TRUE           |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.



|treatmentID |unit  |treatmentLevel |
|:-----------|:-----|:--------------|
|FALSE       |FALSE |FALSE          |
|FALSE       |TRUE  |FALSE          |
|FALSE       |FALSE |FALSE          |
|FALSE       |FALSE |FALSE          |
|FALSE       |FALSE |FALSE          |


#### **<span style="color:#AA5500">treatmentID is in mappingColumn - warning</span>**

To Be Added



|              |x     |
|:-------------|:-----|
|Lid_treatment |TRUE  |
|species_1     |TRUE  |
|species_2     |FALSE |
|species_3     |TRUE  |


### **<span style="color:#AA5500">Measurement - warning</span>**

To Be Added



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.



|measurementID |variable |method |unit |object |noOfSamplesInTimeSeries |samplingVolume |dataExtractionID |measuredFrom |comment |
|:-------------|:--------|:------|:----|:------|:-----------------------|:--------------|:----------------|:------------|:-------|
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |
|TRUE          |TRUE     |TRUE   |TRUE |TRUE   |TRUE                    |TRUE           |TRUE             |TRUE         |NA      |


#### **<span style="color:#AA5500">values in suggestedValues - warning</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.



|variable |method |unit  |object |dataExtractionID |measuredFrom |
|:--------|:------|:-----|:------|:----------------|:------------|
|FALSE    |TRUE   |TRUE  |TRUE   |TRUE             |TRUE         |
|TRUE     |FALSE  |TRUE  |TRUE   |TRUE             |TRUE         |
|FALSE    |FALSE  |FALSE |TRUE   |TRUE             |TRUE         |
|TRUE     |FALSE  |FALSE |FALSE  |TRUE             |TRUE         |


#### **<span style="color:#00FF00">names unique - OK</span>**

Check if the names specified in `measurementID` are unique.



|                     |x    |
|:--------------------|:----|
|oxygen concentration |TRUE |
|abundance            |TRUE |
|smell                |TRUE |
|sequenceData         |TRUE |


#### **<span style="color:#00FF00">measuredFrom is 'raw', 'NA', NA or in name - OK</span>**

Check if the names specified in `measurementID` are unique.



|                     |x    |
|:--------------------|:----|
|oxygen concentration |TRUE |
|abundance            |TRUE |
|smell                |TRUE |
|sequenceData         |TRUE |


#### **<span style="color:#AA5500">variable is in mappingColumn - warning</span>**

To Be Added



|          |x     |
|:---------|:-----|
|DO        |FALSE |
|abundance |TRUE  |
|smell     |TRUE  |
|DNA       |FALSE |


#### **<span style="color:#00FF00">dataExtractionID is 'none', 'NA', NA, or in DataExtraction$dataExtractionID - OK</span>**

To Be Added



|x    |
|:----|
|TRUE |
|TRUE |
|TRUE |
|TRUE |


### **<span style="color:#AA5500">DataExtraction - warning</span>**

To Be Added



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.



|dataExtractionID |method |parameter |value |comment |
|:----------------|:------|:---------|:-----|:-------|
|TRUE             |NA     |NA        |NA    |TRUE    |
|NA               |NA     |NA        |NA    |NA      |


#### **<span style="color:#00FF00">values in suggestedValues - OK</span>**

Test if the metadata entered is ion the suggestedValues list. The value NA is allowed in all column types, empty cells should be avoided.



|method |
|:------|
|TRUE   |
|TRUE   |


#### **<span style="color:#00FF00">names unique - OK</span>**

Check if the names specified in `dataExtractionID` are unique.



|dataExtractionID    |isOK |
|:-------------------|:----|
|Mol_Analy_pipeline1 |TRUE |
|NA                  |TRUE |


#### **<span style="color:#AA5500">name is in Measurement$dataExtractionID - warning</span>**

To Be Added



|dataExtractionID    |isOK  |
|:-------------------|:-----|
|Mol_Analy_pipeline1 |TRUE  |
|NA                  |FALSE |


### **<span style="color:black">DataFileMetaData - NA</span>**

To Be Added



|x  |
|:--|
|NA |


#### **<span style="color:#00FF00">conversion of values into specified type lossless possible - OK</span>**

Test if the metadata entered follows the type for the column, i.e. integer, characterd, .... The validation is done by verifying if the column can be losslessly converted from character to the columnb type specified. the value NA is allowed in all column types, empty cells should be avoided.



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

Test if the metadata entered is ion the allowedValues list. The value NA is allowed in all column types, empty cells should be avoided.



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


#### **<span style="color:#FF0000">dataFile exists in path - error</span>**

To Be Added



|dataFileName                  |IsOK  |
|:-----------------------------|:-----|
|dissolved_oxygen_measures.csv |TRUE  |
|smell.csv                     |TRUE  |
|abundances.csv                |FALSE |


#### **<span style="color:#00FF00">if type == 'datetime', description has format information - OK</span>**

To Be Added



|dataFileName                  |columnName |type     |description |IsOK |
|:-----------------------------|:----------|:--------|:-----------|:----|
|dissolved_oxygen_measures.csv |Date_time  |datetime |ymdhms      |TRUE |
|smell.csv                     |Date       |datetime |ymdhms      |TRUE |
|abundances.csv                |Date_time  |datetime |ymdhms      |TRUE |


#### **<span style="color:black">correct values in mappingColumn in dependence on columnData - NA</span>**

To Be Added



|mappingColumn        |IsOK |
|:--------------------|:----|
|NA                   |TRUE |
|oxygen concentration |TRUE |
|NA                   |TRUE |
|NA                   |TRUE |
|NA                   |TRUE |
|NA                   |TRUE |
|Lid_treatment        |TRUE |
|NA                   |TRUE |
|NA                   |TRUE |
|species_1            |NA   |
|smell                |TRUE |
|NA                   |TRUE |
|Lid_treatment        |TRUE |
|NA                   |TRUE |
|species_3            |NA   |
|NA                   |TRUE |
|NA                   |TRUE |
|Lid_treatment        |TRUE |
|NA                   |TRUE |
|abundance            |TRUE |


#### **<span style="color:#FF0000">columnName in column names in dataFileName - error</span>**

To Be Added



|dataFileName                  |columnName    |IsOK  |
|:-----------------------------|:-------------|:-----|
|dissolved_oxygen_measures.csv |Jar_ID        |TRUE  |
|dissolved_oxygen_measures.csv |DO            |TRUE  |
|dissolved_oxygen_measures.csv |Unit_1        |TRUE  |
|dissolved_oxygen_measures.csv |Mode          |FALSE |
|dissolved_oxygen_measures.csv |Location      |TRUE  |
|dissolved_oxygen_measures.csv |Date_time     |TRUE  |
|dissolved_oxygen_measures.csv |Lid_treatment |FALSE |
|dissolved_oxygen_measures.csv |Jar_type      |TRUE  |
|dissolved_oxygen_measures.csv |Jar_ID        |TRUE  |
|smell.csv                     |NA            |FALSE |
|smell.csv                     |smell         |FALSE |
|smell.csv                     |Date          |TRUE  |
|smell.csv                     |Lid_treatment |FALSE |
|smell.csv                     |Jar_type      |TRUE  |
|abundances.csv                |NA            |TRUE  |
|abundances.csv                |Jar_ID        |FALSE |
|abundances.csv                |Date_time     |FALSE |
|abundances.csv                |Lid_treatment |FALSE |
|abundances.csv                |Jar_type      |FALSE |
|abundances.csv                |count_number  |FALSE |


#### **<span style="color:#FF0000">column names in dataFileName in columnName - error</span>**

To Be Added



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

To Be Added



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
