library(shiny)
library(dmdScheme)



# Server definition -----------------------------------------------------------


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

    output$newEmptySpreadsheet <- downloadHandler(
      filename = function(){paste0(scheme_active()$name, "_", scheme_active()$version, ".xlsx")},
      content = function(file) {
        open_new_spreadsheet(file = file, keepData = FALSE)
      }
    )

    output$newExampleSpreadsheet <- downloadHandler(
      filename = function(){paste0(scheme_active()$name, "_", scheme_active()$version, "_example.xlsx")},
      content = function(file) {
        open_new_spreadsheet(file = file, keepData = TRUE)
      }
    )

    # Validate ----------------------------------------------------------------

    output$downloadValidationReport <- downloadHandler(
      filename = function(){
        paste0(input$spreadsheet$name, "_ValidationReport.", input$formatValidationReport)
      },
      content = function(file) {
        report( x = input$spreadsheet$datapath, open = FALSE, report = input$formatValidationReport, file = file )
      }
    )

    # Export to xml -----------------------------------------------------------

    output$downloadData <- downloadHandler(
      filename = function(){
        ifelse(
          is.null(input$spreadsheet$name),
          "export.xml",
          gsub(".xlsx", ".xml", input$spreadsheet$name)
        )
      },
      content = function(file) {
        x <- write_xml( x = read_excel(input$spreadsheet$datapath), file = file, output = "complete" )
      }
    )

# End ---------------------------------------------------------------------


  }
)
