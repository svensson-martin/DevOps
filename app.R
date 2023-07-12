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
    # list(
    #   bill_length_mm = input$bill_length,
    #   species_Chinstrap = input$species == "Chinstrap",
    #   species_Gentoo = input$species == "Gentoo",
    #   sex_male = input$sex == "Male"
    # )
  )
  
  # Fetch prediction from API
  #endpoint <- vetiver_endpoint(api_url)
  
  pred <- eventReactive(
    input$predict, 
    predict(endpoint, new_data = vals()) |> pull(.pred)
    # httr2::request(api_url) |>
    #   httr2::req_body_json(vals()) |>
    #   httr2::req_perform() |>
    #   httr2::resp_body_json(),
    # ignoreInit = TRUE
  )
  
  # Render to UI
  output$pred <- renderText(pred())
  output$vals <- renderPrint(vals())
}

# Run the application
shinyApp(ui = ui, server = server)