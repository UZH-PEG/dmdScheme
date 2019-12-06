library(devtools)
library(dmdScheme)

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
          choices = apply(scheme_list(), 1, paste0, collapse = "_"), #names(scheme_list_in_repo()),
          selected = scheme_active() %>% paste0(collapse = "_")
        ),
        textOutput(
          outputId = "loaded"
        ),

        # Download New Scheme --------------------------------------------------------

        hr(),
        h1("Download New Scheme"),

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

        # Validate Uploaded Metadata ----------------------------------------------

        hr(),
        h1("Download Validation Report"),


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
