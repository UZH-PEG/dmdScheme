#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(

    # Application title
    titlePanel("dmdScheme"),

    # Sidebar
    sidebarLayout(

      sidebarPanel(
        selectInput(
          inputId = "scheme",
          label = "Select scheme to be used",
          choices = dmdScheme_installed()
        ),
        textOutput( outputId = "scheme" ),

        hr(),

        actionButton(
          inputId = "open",
          label = "Open empty scheme in Spreadsheet",
          icon = NULL
        ),

        hr(),

        fileInput(
          inputId = "spreadsheet",
          label = "Select spreadsheet containing metadata",
          multiple = FALSE,
          accept = c(".xlsx", "xls")
        ),

        hr(),

        actionButton(
          inputId = "validate",
          label = "Validate metadata from spreadsheet",
          icon = NULL
        ),

        hr(),

        actionButton(
          inputId = "export",
          label = "Export metadata from spreadsheet to xml",
          icon = NULL
        ),

        width = 5
      ),


      # Show a plot of the generated distribution
      mainPanel(
        verbatimTextOutput( outputId = "text" ),
        width = 7
      )

    )
  )
)
