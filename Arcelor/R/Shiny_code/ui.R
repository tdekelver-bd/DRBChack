#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
setwd('C:/Users/rbelhocine/Desktop/BD/Arcelor/R/')
library(reticulate)
source_python("Search_engine_and_topic_prediction.py")



sidebar <- dashboardSidebar(width = 300,
  sidebarMenu(
    menuItem(span("Safety Assistant",style="font-size:18px;"), tabName = "safety", icon = icon("search"))
  )
)

body <- dashboardBody(
   tabItems(
    tabItem(tabName = "safety",
            hr()
            ,h1("Hello Safe.ly User ! I'm your Safety Assistant of the Future.", align="center")
            ,br()
            , HTML('<center><img src="photo.png" width="400"></center>')
            ,br()
            ,hr()
            ,br()
            ,fluidRow(column(12,tabBox(
              title=tagList(shiny::icon("search"), "Ask me a Question !"), width=12,
              fluidRow(column(12,align="center",textInput("quest", "", value = "You can write your question here.", placeholder = NULL))),
              fluidRow(column(12,align="center",actionButton("go", "Search")))))),
            fluidRow(column(12,tabBox(width=12,
                                      tabPanel("TopDoc",DT::dataTableOutput("top_documents")),
                                      tabPanel("TopAnswer", DT::dataTableOutput("top_answer")))))
    )))
           

# Put them together into a dashboardPage
dashboardPage(skin = "yellow",
  dashboardHeader(title = "Safe.Ly", titleWidth = 300),
  sidebar,
  body
)
