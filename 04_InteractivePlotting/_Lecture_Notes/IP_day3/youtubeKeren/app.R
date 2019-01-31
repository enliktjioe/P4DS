library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)

vids <- read.csv("youtubetrends.csv")

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "YouTube Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Category",
               tabName ="menu1",
               icon = icon("dashboard")),
      menuItem(text = "Publish Hour",
               tabName ="menu2",
               icon = icon("apple"))
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "menu1",
              selectInput(inputId = "categoryinput",
                          label = "Category",
                          choices = levels(vids$category_id)),
              plotlyOutput("plotcategory")
              ),
      tabItem(tabName = "menu2",
              sliderInput(inputId = "hourinput",
                          label = "choice publish hour",
                          min = 0,
                          max = 23,
                          value = 12,
                          step = 1),
              plotlyOutput("plothour"))
      
    )
  )
  
  
)

server <- function(input, output) {
  
  
  output$plotcategory <- renderPlotly({
    
    vids.category <- vids %>% 
      filter(category_id==input$categoryinput)
    plot1 <- ggplot(data =vids.category , aes(x = likes, y = dislikes))+
      geom_point()
    ggplotly(plot1)
    
  })
  
  output$plothour <- renderPlotly({
    vids.agg <- vids %>% 
      filter(publish_hour== input$hourinput) %>% 
      group_by(category_id) %>% 
      summarise(video = n())
    
    plot2 <- ggplot(data = vids.agg, aes(x = reorder(category_id, video), y = video))+
      geom_col()+
      coord_flip()+
      scale_y_continuous(limits = c(0,150))
    
    ggplotly(plot2)
    
  })
  
  
  
  
  
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

