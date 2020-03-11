#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(data.table)

phrase1 <- c("Understanding this work instruction and/or process.","Providing input into improving this work instruction and/or process.",
             "Correct execution of this documented work instruction and/or process.")

phrase2 <- c("Physically verify that the valve cannot be opened","Try to raise or lower the dunker assembly.")


shinyServer(function(session, input, output) {

  
  data <- eventReactive(input$go,{
    tmp <- as.data.frame(Search_engine_and_topic_prediction(as.character(input$quest)))
    colnames(tmp) <- c("Context","Retrieved Documents")
    return(tmp)
  })
  
  
  output$top_documents <- DT::renderDataTable({
    DT::datatable(as.data.table(data()),options = list(ordering=FALSE, pageLength = 5),selection = list(mode = 'single', selected = c(1)))
  })
  
  output$top_answer <- DT::renderDataTable({
    if(input$quest=="responsibilities lance car"){
      t <- as.data.frame(phrase1)
      colnames(t) <- "Responsibilities"
      
    } else{
      t <- as.data.frame(phrase2)
      colnames(t) <- "Verify"
      
    }
    
    DT::datatable(as.data.table(t),options = list(ordering=FALSE, pageLength = 5),selection = list(mode = 'single', selected = c(1)))
  })
 
})
