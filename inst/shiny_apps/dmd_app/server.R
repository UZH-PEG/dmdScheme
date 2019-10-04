library(shiny)
library(dmdScheme)


shinyServer(
  function(input, output) {

    # Load Packages -----------------------------------------------------------

    observeEvent(
      eventExpr = input$loadPackage,
      ignoreNULL = FALSE,
      handlerExpr = {
        pkgs_inst <- dmdScheme_installed()[,"Package"]
        if (is.null(input$loadPackage)) {
          toLoad <- character(0)
        } else {
          toLoad <- sapply(
            strsplit(input$loadPackage, " "),
            "[[",
            1
          )
        }
        toUnLoad <- pkgs_inst[ !(pkgs_inst %in% toLoad) ]
        # unload unchecked schemes
        for (x in toUnLoad) {
          if ( isNamespaceLoaded(x) ) {
            detach(paste0("package:", x), unload = TRUE, character.only = TRUE)
          }
        }
        # load checked schemes
        for (x in toLoad) {
          require(x, character.only = TRUE)
        }
        ##
        loaded <- "Packages Loaded:"
        for (x in pkgs_inst) {
          if ( isNamespaceLoaded(x) ) {
            loaded <- paste(loaded, x)
          }
        }
        output$loaded <- renderPrint(loaded)
      }
    )

    # Open new Spreadsheet ----------------------------------------------------

    observeEvent(
      eventExpr = input$open,
      handlerExpr = {
        open_new_spreadsheet( schemeName = strsplit(input$loadPackage, " ")[[1]][[1]] )
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

    observeEvent(
      eventExpr = input$export,
      handlerExpr = {
        x <- as_xml( x = input$spreadsheet$datapath )
        output$text <- renderPrint(x)
      }
    )

# End ---------------------------------------------------------------------


  }
)
