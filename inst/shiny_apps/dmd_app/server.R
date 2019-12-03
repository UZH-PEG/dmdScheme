library(shiny)


# Install dmdScheme from github -------------------------------------------

  library(remotes)
  remotes::install_github("Exp-Micro-Ecol-Hub/dmdScheme", ref = "separateDefinition")
  library(dmdScheme)


# Server definition\ ------------------------------------------------------


shinyServer(
  function(input, output) {

    # Load Packages -----------------------------------------------------------

    observeEvent(
      eventExpr = input$loadPackage,
      ignoreNULL = FALSE,
      handlerExpr = {
        name <-  strsplit(input$loadPackage, "_")[[1]][[1]]
        version <-  strsplit(input$loadPackage, "_")[[1]][[2]]
        if (!scheme_installed(name, version)) {
          scheme_install( name = name, version = version )
        }
        scheme_use( name = name, version = version )

        output$loaded <- renderPrint(paste("Active scheme is ", scheme_active()$name, " version ", scheme_active()$version))
      }
    )

    # Open new Spreadsheet ----------------------------------------------------

    observeEvent(
      eventExpr = input$open,
      handlerExpr = {
        open_new_spreadsheet( keepData = TRUE )
      }
    )

    observeEvent(
      eventExpr = input$openExample,
      handlerExpr = {
        open_new_spreadsheet( keepData = TRUE )
      }
    )

    # Validate ----------------------------------------------------------------

    observeEvent(
      eventExpr = input$validate,
      handlerExpr = {
        report( x = input$spreadsheet$datapath )
      }
    )

    # Export to xml -----------------------------------------------------------

    output$downloadData <- downloadHandler(
      filename = ifelse(
        is.null(input$spreadsheet$datapath),
        "export.xml",
        gsub(".xlsx", ".xml", basename(input$spreadsheet$datapath))
      ),
      content = function(file) {
        x <- write_xml( x = read_excel(input$spreadsheet$datapath), file = file, output = "complete" )
      }
    )

# End ---------------------------------------------------------------------


  }
)
