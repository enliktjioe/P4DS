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

# Function to create new console platform
selectConsole <- function(x) {
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

ign20$consolePlatform <- sapply(ign20$platform, selectConsole)
table(ign20$consolePlatform)


ign20.Nintendo <- ign20 %>% 
  filter(consolePlatform == "Nintendo") %>% 
  mutate(platform = droplevels(platform))

ign20.Sony <- ign20 %>% 
  filter(consolePlatform == "Sony")

ign20.Microsoft <- ign20 %>% 
  filter(consolePlatform == "Microsoft")



############################################################################################
####                                                                                    ####
############################################################################################


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
      tabItem(tabName = "nintendo",
              selectInput(inputId = "platformInput",
                          label = "Platform Type",
                          choices = levels(ign20.Nintendo$platform)),
              plotlyOutput("plotNintendo")),
      tabItem(tabName = "sony"),
      tabItem(tabName = "microsoft")
    )
  )
)

server <- function(input, output) {
  # ign20.Nintendo.plot <- ign20.Nintendo %>% 
  #   filter(platform == input$platformInput)
  
  output$plotNintendo <- renderPlotly({
    plot1 <- 
      ggplot(ign20.Nintendo,
                    aes(x=factor(release_year),
                        text = sprintf(paste("Release Year : %s\n Platform Type : %s\n"),
                                              release_year, 
                                              platform))) +
      geom_bar(aes(fill=platform)) +
      theme(axis.text.x = element_text(angle=90, hjust=1)) +
      labs(title = "Total game were released every year in Nintendo console", x = "Release Year", y = "Total Game")
    
    ggplotly(plot1, tooltip = "text")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

