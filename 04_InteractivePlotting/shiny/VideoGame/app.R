library(shiny)
library(shinydashboard)
library(dplyr)
library(lubridate)
library(plotly)

# Pre-processing
ign <- read.csv("ign.csv")
str(ign)

# we only need data from release year 1996 to 2016 for 20 years comparison
ign20 <- ign %>% 
  filter(release_year >= 1996 & release_year <= 2016)

str(ign20)
rm(ign)

############################################################################################
####                                                                                    ####
############################################################################################

nintendo <- c("Game Boy","Game Boy Advance","Game Boy Color" ,"GameCube", "NES", "New Nintendo 3DS", "Nintendo 3DS", 
                "Nintendo 64", "Nintendo 64DD","Nintendo DS", "Nintendo DSi","Super NES","Wii","Wii U")
sony <- c("PlayStation","PlayStation 2","PlayStation 3","PlayStation 4","PlayStation Portable","PlayStation Vita")
microsoft <- c("Xbox","Xbox 360","Xbox One")

# Function to create new category of platform
selectCategory <- function(x) {
  if (x %in% nintendo == TRUE){
    return("Nintendo")
  }
  
  else if(x %in% sony == TRUE){
    return("Sony")  
  }
  
  else if(x %in% microsoft == TRUE){
    return("Microsoft")
  }
  
  else{
    return("Others")
  }
  
}

ign20$categoryPlatform <- as.factor(sapply(ign20$platform, selectCategory))
table(ign20$categoryPlatform)


############################################################################################
####                                                                                    ####
############################################################################################


# Shiny Web Apps
ui <- dashboardPage(skin = "blue",
  dashboardHeader(title = "Console Games"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("By Platform", tabName = "platform", icon = icon("dashboard")),
      menuItem("Console Wars", tabName = "consoleWars", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "platform",
              selectInput(inputId = "categoryPlatform",
                          label = "Choose Your Platform",
                          choices = levels(ign20$categoryPlatform)),
              plotlyOutput("plot1")),
      tabItem(tabName = "consoleWars",
              plotlyOutput(outputId = "plot2"))
    )
  )
)

server <- function(input, output) {
  
  output$plot1 <- renderPlotly({
    ign20.platform <- ign20 %>%
      filter(categoryPlatform == input$categoryPlatform)
    
    plot1 <- 
      ggplot(ign20.platform,
                    aes(x = factor(release_year))) +
      geom_bar(aes(fill = platform)) +
      theme(axis.text.x = element_text(angle=90, hjust=1)) +
      labs(title = "Total game were released every year", x = "Release Year", y = "Total Game")
    
    ggplotly(plot1)
  })
  
  output$plot2 <- renderPlotly({
    plot2 <- 
      ggplot(ign20[ign20$categoryPlatform != "Others",],aes(x=factor(release_year))) +
      geom_bar(aes(fill=categoryPlatform)) +
      theme(axis.text.x = element_text(angle=90, hjust=1)) +
      labs(title = "Total game were released every year", x = "Release Year", y = "Total Game")
    
    ggplotly(plot2)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

