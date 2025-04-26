#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2) 
library(dplyr)
library(broom)
library(rmarkdown)
library(shinydashboard)

evs <- readRDS("data/dataset.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("European Values Survey Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Country:", choices = c("Overall", unique(evs$country))),
      selectInput("outcome", "Outcome:", choices = c("child_suffers_mom", "job_scarcity")),
      checkboxGroupInput("controls", "Controls:", choices = c("sex", "education")),
      numericInput("poly", "Age polynomial:", value = 1, min = 1, max = 5),
      downloadButton("report", "Generate Report")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Overview",
                 h3("EVS Data Explorer"),
                 p("This app explores the European Values Study data."),
                 p("Use the inputs on the left to filter and model the data."),
                 p("Navigate to the Exploration tab for graphs, and Regression for statistical modeling.")
        ),
        
        tabPanel("Exploration",
                 plotOutput("outcomePlot"),
                 plotOutput("agePlot"),
                 plotOutput("educationPlot"),
                 plotOutput("sexPlot")
        ),
        
        tabPanel("Regression",
                 tableOutput("regressionTable"),
                 plotOutput("residPlot")
        )
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
