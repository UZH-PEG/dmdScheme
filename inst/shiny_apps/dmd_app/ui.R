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
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(

      sidebarPanel(
        selectInput(
          inputId = "scheme",
          label = "Select scheme",
          choices = dmdScheme_installed()
        ),
        textOutput("scheme"),

        actionButton(
          inputId = "open",
          label = "Open in Excel",
          icon = NULL
        ),

        fileInput(
          inputId = "spreadsheet",
          label = "Select spreadsheet containing metadata",
          multiple = FALSE,
          accept = c(".xlsx", "xls")
        ),

        actionButton(
          inputId = "validate",
          label = "Validate metadata from spreadsheet",
          icon = NULL
        ),

        actionButton(
          inputId = "export",
          label = "Export metadata from spreadsheet to xml",
          icon = NULL
        )

      ),


      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("distPlot")
      )

    )
  )
)
