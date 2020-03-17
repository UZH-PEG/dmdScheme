library(shiny)
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

# Server definition -----------------------------------------------------------



shinyServer(
  function(input, output) {

    # Load Packages -----------------------------------------------------------

    observeEvent(
      eventExpr = input$loadPackage,
      ignoreNULL = FALSE,
      handlerExpr = withProgress(
        message = 'Loading Scheme and R Package - this might take some time',
        min = 0,
        max = 4,
        value = 0,
        {
          name <-  strsplit(input$loadPackage, "_")[[1]][[1]]
          version <-  strsplit(input$loadPackage, "_")[[1]][[2]]
          if (!scheme_installed(name, version)) {
            incProgress(1, message = "Installing Scheme...")
            scheme_install(
              name = name,
              version = version,
              overwrite = TRUE
            )
            incProgress(1, message = "Instaling R Package - this can take some time...")
            scheme_install_r_package(
              name = name,
              version = version,
              reinstall = TRUE
            )
          }
          incProgress(1, message = "Loading R Package and Scheme...")
          do.call(library, list(name))
          scheme_use( name = name, version = version )

          incProgress(1, message = "Done!")

          output$loaded <- renderPrint(paste("Active scheme is ", scheme_active()$name, " version ", scheme_active()$version))
        }
      )
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
        reportFormat <- input$formatValidationReport
        if (reportFormat == "docx") {
          reportFormat <- "word"
        }
        metadata <- input$spreadsheet$datapath
        dataPath <- dirname(input$dataFiles$datapath)[[1]]
        dataFiles <- file.path(dataPath, input$dataFiles$name)
        file.copy(
          from = input$dataFiles$datapath,
          to = dataFiles,
          overwrite = TRUE
        )
        report(
          x = metadata,
          path = dataPath,
          open = FALSE,
          report = reportFormat,
          file = file
        )
      }
    )

    # Export to xml -----------------------------------------------------------

    output$downloadData <- downloadHandler(
      filename = function(){
        ifelse(
          is.null(input$spreadsheet$name),
          "export_xml.tar.gz",
          gsub(".xlsx", "_xml.tar.gz", input$spreadsheet$name)
        )
      },
      content = function(file) {
        xmlPath <- file.path(dirname(file), "xml")
        dir.create(xmlPath)
        x <- write_xml(
          x = read_excel(input$spreadsheet$datapath),
          file = file.path(xmlPath, "dummy.xml"),
          output = "complete"
        )
        oldwd <- setwd(xmlPath)
        try(
          utils::tar(
            tarfile = file,
            files = ".",
            compression = "gzip"
          )
        )
        setwd(oldwd)

      }
    )

# End ---------------------------------------------------------------------


  }
)
