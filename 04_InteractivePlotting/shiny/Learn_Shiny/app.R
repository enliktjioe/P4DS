library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)