library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(plotly)

# Pre-processing
ign <- read.csv("ign.csv")
str(ign)


# Shiny Web Apps
ui <- dashboardPage(skin = "blue",
  dashboardHeader(title = "Video Games"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Nintendo", tabName = "nintendo", icon = icon("dashboard")),
      menuItem("Sony", tabName = "sony", icon = icon("dashboard")),
      menuItem("Microsoft", tabName = "microsoft", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "nintendo"),
      tabItem(tabName = "sony"),
      tabItem(tabName = "microsoft")
    )
  )
)

server <- function(input, output) {
  # output$plotNintendo <- renderPlotly({
  #   
  # })
}

# Run the application 
shinyApp(ui = ui, server = server)

