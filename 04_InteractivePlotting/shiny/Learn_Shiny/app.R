library(shiny)
library(ggplot2)
library(dplyr)

vids <- read.csv("youtubetrends.csv")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "sliderID", 
                  label = "Number of Likes", 
                  min = 0, 
                  max = 50, 
                  value = 25)
    ),
    mainPanel(
      plotOutput(outputId = "plothist")
      )
  )
)

server <- function(input, output, session) {
  output$plothist <- renderPlot({
    ggplot(data = vids, aes(x = likes)) +
      geom_histogram(bins = input$sliderID)
  })
}

shinyApp(ui, server)