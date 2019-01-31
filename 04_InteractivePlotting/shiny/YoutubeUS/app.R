library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)

vids <- read.csv("youtubetrends.csv")

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "Youtube Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Category", tabName = "category", icon = icon("dashboard")),
      menuItem("Publish Hour", tabName = "publishHour", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "category",
              selectInput(inputId = "categoryInput",
                          label = "Category",
                          choices = levels(vids$category_id)),
              plotlyOutput(outputId = "plotcategory")
              ),
      
      tabItem(tabName = "publishHour",
              sliderInput(inputId = "publishHourInput", 
                          label = "Choose Publish Hour", 
                          min = 0, 
                          max = 23, 
                          value = 12,
                          step = 1),
              plotlyOutput(outputId = "plotHour"))
    )
  )
)

server <- function(input, output) { 
  
  output$plotcategory <- renderPlotly({
    vids.category <- vids %>% 
      filter(category_id == input$categoryInput)
    
    plot1 <-  ggplot(data = vids.category, aes(x = likes, y = dislikes)) +
      geom_point()
    
    ggplotly(plot1)
  
  })
  

  output$plotHour <- renderPlotly({
    vids.hour <- vids %>%
      filter(publish_hour == input$publishHourInput) %>% 
      group_by(category_id) %>% 
      summarise(totalVideo = n())
    
    plot2 <- ggplot(data = vids.hour, aes(x = reorder(category_id, totalVideo),
                                          y = totalVideo,
                                          text = sprintf(paste("Jumlah Video : %s\n Nama Kategori : %s\n"),
                                                         vids.hour$totalVideo, vids.hour$category_id))) +
      geom_col() +
      coord_flip() +
      scale_y_continuous(limits = c(0,150))
    
    ggplotly(plot2, tooltip = "text")
  })
}

shinyApp(ui, server)