---
title: "Notes"
author: "Rainer M Krug"
output: html_document
---
# Metadata "properties"
on [CEDAR](https://metadatacenter.org/tools-training/cedar-template-tools) they outline the properties of theitr metadata fields:

- recommended name == `valueProperty`
- type == `type`
- description == `Description`
- link to one or more semantic concepts == **not included (yet?)**
- constraints on the accepted values == `allowedValues` and `suggestedValues`

We are mainly providoing the information included in their layouts which should make it possible to define ontologies using e.g. OWL.

WHAT THE HECK IS OWL?????????????????


# Species
Species (i.e. `speciesID`) can be either
- specified as a treatment (`treatmentID`) where the `treatmentLevel` contains a comma separated list of the `speciesID` in a treatmentLevel, or
