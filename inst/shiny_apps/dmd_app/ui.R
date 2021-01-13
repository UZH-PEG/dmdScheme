library(devtools)
library(dmdScheme)
library(devtools)

# For emeScheme startup to make loading faster ----------------------------

library(digest)
library(magrittr)
library(methods)
library(rlang)
library(rmarkdown)
library(taxize)
library(utils)

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(magrittr)

# Based on https://gist.github.com/wch/c3653fb39a00c63b33cf
R_lib <- tempfile(pattern = "R_lib")
if (!file.exists(R_lib)) {
  dir.create(R_lib)
}
.libPaths( c(normalizePath(R_lib), .libPaths()) )

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    tags$head(
      tags$style(HTML("hr {border-top: 1px solid #000000;}"))
    ),
    # Application title
    titlePanel("Scheme App"),

    # Sidebar
    sidebarLayout(

      # Sidebar -----------------------------------------------------------------

      sidebarPanel(
        width = 7,

        # Schemes to be loaded ----------------------------------------------------

        h1("Activate available scheme definitions"),

        radioButtons(
          inputId = "loadPackage",
          label = h3("Available dmdSchemes"),
          choices = names(scheme_list_in_repo()),
          selected = scheme_active() %>% paste0(collapse = "_")
        ),
        textOutput(
          outputId = "loaded"
        ),

        # Download New Scheme --------------------------------------------------------

        hr(),
        h1("Download New Scheme"),
        h4("The download of an Empty Spreadsheet may result in a corrupted file!"),
        h5("You can either let Excel repair the spreadsheet or"),
        h5("download the Example Spreadsheet and delete all the data in it."),

        downloadButton(
          outputId = "newEmptySpreadsheet",
          label = "Empty scheme Spreadsheet"
        ),

        downloadButton(
          outputId = "newExampleSpreadsheet",
          label = "Example scheme Spreadsheet"
        ),

        # Upload Spreadsheet containing Metadata ----------------------------------

        hr(),
        h1("Upload Spreadsheet containing Metadata"),

        fileInput(
          inputId = "spreadsheet",
          label = "Select Spreadsheet",
          multiple = FALSE,
          accept = c(".xlsx", "xls")
        ),

        h1("Upload Datafiles"),

        fileInput(
          inputId = "dataFiles",
          label = "Select Datafiles",
          multiple = TRUE
        ),

        # Validate Uploaded Metadata ----------------------------------------------

        hr(),
        h1("Download Validation Report"),

        radioButtons(
          inputId = "formatValidationReport",
          label = "Format of report",
          choices = list("html" = "html", "docx" = "docx", "pdf" = "pdf"),
          selected = "html"
        ),

        downloadButton(
          outputId = "downloadValidationReport",
          label = "Create and download"
        ),

        # Export Uploded Spreadsheet to xml ---------------------------------------

        hr(),
        h1("Export Uploaded Spreadsheet to xml"),

        downloadButton(
          outputId = "downloadData",
          label = "Export to xml"
        )

      ),


      # Main Panel --------------------------------------------------------------

      mainPanel(
        width = 7,

        # output xml --------------------------------------------------------------

        verbatimTextOutput( outputId = "text" )
      )

    )
  )
)
