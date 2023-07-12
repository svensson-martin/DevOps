library(shiny)
library(vetiver)

api_url <- "http://127.0.0.1:8088/predict"
endpoint <- vetiver_endpoint(api_url)

ui <- fluidPage(
  titlePanel("Penguin Mass Predictor"),
  
  # Model input values
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bill_length",
        "Bill Length (mm)",
        min = 30,
        max = 60,
        value = 45,
        step = 0.1
      ),
      selectInput(
        "sex",
        "Sex",
        c("male", "female")
      ),
      selectInput(
        "species",
        "Species",
        c("Adelie", "Chinstrap", "Gentoo")
      ),
      # Get model predictions
      actionButton(
        "predict",
        "Predict"
      )
    ),
    
    mainPanel(
      h2("Penguin Parameters"),
      verbatimTextOutput("vals"),
      h2("Predicted Penguin Mass (g)"),
      textOutput("pred")
    )
  )
)

server <- function(input, output) {
  # Input params
  vals <- reactive(
    data.frame(
      bill_length_mm = input$bill_length, 
      species = input$species, 
      sex = input$sex
    )
  )
  
  # Fetch prediction from API
  
  pred <- eventReactive(
    input$predict, 
    predict(endpoint, new_data = vals()) |> pull(.pred)
  )
  
  # Render to UI
  output$pred <- renderText(pred())
  output$vals <- renderPrint(vals())
}

# Run the application
shinyApp(ui = ui, server = server)