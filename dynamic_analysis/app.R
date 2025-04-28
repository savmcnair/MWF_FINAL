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
      selectInput("country", "Country:", choices = c("Overall", levels(evs$country))),
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
  
  #data filter by country
  filtered_data <- reactive({
    if (input$country == "Overall") {
      evs
    } else {
      evs[evs$country == input$country, ]
    }
  })
  
  #outcome plots
  output$outcomePlot <- renderPlot({
    ggplot(filtered_data(), aes_string(x = input$outcome)) +
      geom_bar(fill = "steelblue") +
      labs(title = "Distribution of Selected Outcome", x = NULL, y = "Count")
  })
  
  #age distribution
  output$agePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = age)) +
      geom_histogram(binwidth = 5, fill = "darkorange") +
      labs(title = "Age Distribution", x = "Age", y = "Count")
  })
  
  #education distribution
  output$educationPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = education)) +
      geom_bar(fill = "darkgreen") +
      labs(title = "Education Distribution", x = "Education", y = "Count")
  })
  
  #sex distribution
  output$sexPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = sex)) +
      geom_bar(fill = "purple") +
      labs(title = "Sex Distribution", x = "Sex", y = "Count")
  })
  
  #regression model
  reg_model <- reactive({
    data <- filtered_data()
    
    predictors <- c()  
    
    if ("sex" %in% input$controls) {
      predictors <- c(predictors, "sex")
    }
    if ("education" %in% input$controls) {
      predictors <- c(predictors, "education")
    }
    
    #age polynomials
    age_terms <- paste0("I(age^", 1:input$poly, ")")
    predictors <- c(predictors, age_terms)
    
    #regression model
    formula <- as.formula(paste(input$outcome, "~", paste(predictors, collapse = " + ")))
    
    lm(formula, data = data)
  })
  
  #output table
  output$regressionTable <- renderTable({
    broom::tidy(reg_model())
  })
  
  #resids plot
  output$residPlot <- renderPlot({
    model <- reg_model()
    preds <- predict(model)
    resids <- resid(model)
    
    ggplot(data.frame(preds, resids), aes(x = preds, y = resids)) +
      geom_point(color = "red") +
      geom_hline(yintercept = 0, linetype = "dashed") +
      labs(title = "Predicted vs Residuals", x = "Predicted", y = "Residuals")
  })
  
  #create report for download
  output$report <- downloadHandler(
    filename = function() {
      paste0("evs_report_", Sys.Date(), ".html")
    },
    content = function(file) {
      rmarkdown::render("report.Rmd",
                        output_file = file,
                        params = list(
                          country = input$country,
                          outcome = input$outcome,
                          controls = input$controls,
                          poly = input$poly
                        ),
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
}


# Run the application 
shinyApp(ui = ui, server = server)
