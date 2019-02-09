library(tidyverse)
library(knitr)
library(lubridate)

library(plotly)
library(shiny)
library(shinydashboard)
options(scipen = 9999)

# Remove before publish
setwd("~/GitRepo/algoritma_ds_academy/05_DVCapstone/Kickstarter/")

# Pre-processing Data
ksdata <- read.csv("ks-projects-201801.csv")
ksdata <- ksdata[, -13]
colnames(ksdata)[13] <- "usd_pledged"
colnames(ksdata)[14] <- "usd_goal"

ui <- dashboardPage(skin = "green",
                    dashboardHeader(title = "Kickstarter Explorer"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem(text = "Most Popular Category",
                                 tabName ="menu1",
                                 icon = icon("kickstarter")),
                        menuItem(text = "Most Funded Category",
                                 tabName ="menu2",
                                 icon = icon("dollar-sign")),
                        menuItem(text = "Top 10 Most Funded Project (1)",
                                 tabName ="menu3",
                                 icon = icon("dollar-sign")),
                        menuItem(text = "Top 10 Most Funded Project (2)",
                                 tabName ="menu4",
                                 icon = icon("dollar-sign")),
                        menuItem(text = "Project Result",
                                 tabName ="menu5",
                                 icon = icon("check-circle")),
                        menuItem(text = "Total Projects per Year",
                                 tabName ="menu7",
                                 icon = icon("kickstarter")),
                        menuItem(text = "Success vs Failure by Category",
                                 tabName ="menu6",
                                 icon = icon("kickstarter")),
                        menuItem(text = "Success vs Failure by Year",
                                 tabName ="menu8",
                                 icon = icon("kickstarter"))
                      )
                    ),
                    
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "menu1",
                                selectInput(inputId = "input1",
                                            label = "Choose Category",
                                            choices = c("main_category", "sub_category")),
                                sliderInput(inputId = "categoryCount",
                                            label = "How many Sub-Category to show?",
                                            min = 5,
                                            max = 25,
                                            value = 10,
                                            step = 1),
                                plotOutput("plot1")
                        ),
                        tabItem(tabName = "menu2",
                                radioButtons(inputId = "input2",
                                            label = "Select type",
                                            choices = c("main_category", "sub_category")),
                                plotOutput("plot2")
                        ),
                        tabItem(tabName = "menu3",
                                selectInput(inputId = "input3",
                                            label = "Choose Main Category",
                                            choices = c("Games", 
                                                        "Design", "Technology", 
                                                        "Film & Video","Music",
                                                        "All Category")),
                                plotOutput("plot3")
                        ),
                        tabItem(tabName = "menu4",
                                selectInput(inputId = "input4",
                                            label = "Choose Sub Category",
                                            choices = c("Product Design", 
                                                        "Tabletop Games", "Video Games", 
                                                        "Hardware","Technology",
                                                        "All Category")),
                                plotOutput("plot4")
                        ),
                        tabItem(tabName = "menu5",
                                radioButtons(inputId = "input5",
                                             label = "Select type",
                                             choices = c("all_results", "percentage_completion")),
                                plotlyOutput("plot5")
                        ),
                        tabItem(tabName = "menu6",
                                plotOutput("plot6")
                        ),
                        tabItem(tabName = "menu7",
                                plotOutput("plot7")
                        ),
                        tabItem(tabName = "menu8",
                                plotOutput("plot8")
                        )
                      )
                    )
)

server <- function(input, output) {
  
  # Output 1
  output$plot1 <- renderPlot({
    
    if(input$input1 == "main_category"){
      project.category <- ksdata %>% 
        group_by(main_category) %>% 
        summarize(count = n()) %>% 
        arrange(desc(count))
      
      project.category$main_category <- factor(project.category$main_category, levels = project.category$main_category)
      
      plot1a <- ggplot(project.category, aes(x = main_category, y = count)) +
        geom_bar(stat = "identity", aes(fill = main_category)) +
        labs(title = "Total Projects by Main-Category", x = "Main-Category Name", y = "Total") +
        theme(axis.text.x = element_text(angle=90, hjust=1),
              plot.title=element_text(hjust=0.5),
              legend.position = "bottom") +
        geom_text(aes(label = paste0(round(count/1000, 1), "K")), vjust = -0.5) +
        scale_y_continuous(limits = c(0,70000))
    
      plot1a
    }
    
    else if (input$input1 == "sub_category") {
      project.subcategory <- ksdata %>% 
        group_by(category) %>% 
        summarize(count = n()) %>% 
        arrange(desc(count))
      
      project.subcategory$category <- factor(project.subcategory$category, levels = project.subcategory$category)
      
      plot1b <- ggplot(head(project.subcategory, input$categoryCount), aes(x = category, y = count)) +
        geom_bar(stat = "identity", aes(fill = category)) +
        labs(title = "Top 10 Projects by Sub-Category", x = "Sub-Category Name", y = "Total") +
        theme(axis.text.x = element_text(angle=90, hjust=1),
              plot.title=element_text(hjust=0.5),
              legend.position = "bottom") +
        geom_text(aes(label = paste0(round(count/1000, 1), "K")), vjust = -0.5) +
        scale_y_continuous(limits = c(0,25000))
    
      plot1b
      
    }
    
    
  })
  
  # Output 2
  output$plot2 <- renderPlot({
    
    if(input$input2 == "main_category"){
      
      category.pledged <- ksdata %>% 
        group_by(main_category) %>% 
        summarize(total = sum(usd_pledged)) %>% 
        arrange(desc(total))
      
      category.pledged$main_category <- factor(category.pledged$main_category, levels = category.pledged$main_category)
      
      plot2a <- ggplot(category.pledged, aes(x = main_category, y = total / 1000000)) +
        geom_bar(stat = "identity", aes(fill = main_category)) +
        labs(title = "Total Amount Pledged by Main Category", x = "Main Category", y = "Amount Pledged in USD") +
        theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 90, hjust = 1), legend.position="null") +
        geom_text(aes(label = paste0(round(total/1000000, 1), "M")), vjust = -0.5)
    
      plot2a
    }
    
    else if(input$input2 == "sub_category") {
      category.pledged <- ksdata %>% 
        group_by(category) %>% 
        summarize(total = sum(usd_pledged)) %>% 
        arrange(desc(total))
      
      category.pledged$category <- factor(category.pledged$category, levels = category.pledged$category)
      
      plot2b <- ggplot(head(category.pledged, 10), aes(x = category, y = total / 1000000)) +
        geom_bar(stat = "identity", aes(fill = category)) +
        labs(title = "Top 10 - Total Amount Pledged by Sub Category", x = "Sub Category", y = "Amount Pledged in USD") +
        theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 90, hjust = 1), legend.position="null") +
        geom_text(aes(label = paste0(round(total/1000000, 1), "M")), vjust = -0.5)
      
      plot2b
    }
  })
  
  # Output 3
  output$plot3 <- renderPlot({
    
    if(input$input3 == "All Category"){
      name.pledged <- ksdata %>%
        group_by(name) %>%
        summarize(total = sum(usd_pledged)) %>%
        arrange(desc(total))
    }

    else {
      name.pledged <- ksdata %>%
        filter(main_category == input$input3) %>%
        group_by(name) %>%
        summarize(total = sum(usd_pledged)) %>%
        arrange(desc(total))
    }

    name.pledged$name <- factor(name.pledged$name, levels = name.pledged$name)

    plot3 <- ggplot(head(name.pledged, 10), aes(x = reorder(name, total), y = total / 1000000)) +
      geom_bar(stat = "identity", aes(fill = name)) +
      labs(title = "Top 10 Most Funded Project by Main Category", x = "Project Name", y = "Amount Pledged in USD") +
      theme(plot.title = element_text(hjust = 0.5), legend.position="null") +
      geom_text(aes(label = paste0(round(total/1000000, 1), "M"), hjust = -0.15)) +
      coord_flip() +
      scale_y_continuous(limits = c(0, max(name.pledged$total)/1000000 + 0.85))

    plot3
  })
  
  # Output 4
  output$plot4 <- renderPlot({
    
    if(input$input4 == "All Category"){
      name.pledged <- ksdata %>%
        group_by(name) %>%
        summarize(total = sum(usd_pledged)) %>%
        arrange(desc(total))
    }
    
    else {
      name.pledged <- ksdata %>%
        filter(category == input$input4) %>%
        group_by(name) %>%
        summarize(total = sum(usd_pledged)) %>%
        arrange(desc(total))
    }
    
    name.pledged$name <- factor(name.pledged$name, levels = name.pledged$name)
    
    plot4 <- ggplot(head(name.pledged, 10), aes(x = reorder(name, total), y = total / 1000000)) +
      geom_bar(stat = "identity", aes(fill = name)) +
      labs(title = "Top 10 Most Funded Project by Sub Category", x = "Project Name", y = "Amount Pledged in USD") +
      theme(plot.title = element_text(hjust = 0.5), legend.position="null") +
      geom_text(aes(label = paste0(round(total/1000000, 1), "M"), hjust = -0.15)) +
      coord_flip() +
      scale_y_continuous(limits = c(0, max(name.pledged$total)/1000000 + 0.85))
    
    plot4
  })
  
  
  # Output 5
  output$plot5 <- renderPlotly({

    if(input$input5 == "all_results"){
      state.freq <- ksdata %>%
        group_by(state) %>%
        summarize(count = n()) %>%
        arrange(desc(count))

      state.freq$state <- factor(state.freq$state, levels = state.freq$state)

      plot5a <- ggplot(state.freq, aes(x = state, y = count,
                                       text = sprintf(paste("Count : %s\nStatus : %s\n"),
                                                      state.freq$count, state.freq$state))) +
        geom_bar(stat = "identity", aes(fill = state), show.legend = F) +
        ggtitle("Project by Status") + xlab("Status") + ylab("Total") +
        theme(plot.title = element_text(hjust = 0.5)) +
        scale_y_continuous(limits = c(0,210000))
      
      ggplotly(plot5a, tooltip = "text")
    }

    else if(input$input5 == "percentage_completion"){
      state.grp <- ksdata %>%
        filter(state!="undefined") %>%
        mutate(grp=ifelse(state %in% c("successful", "failed"), "complete", "incomplete")) %>%
        group_by(grp, state) %>%
        summarize(count=n()) %>%
        mutate(pct=count/sum(count)) %>%
        arrange(grp, desc(-state))

      state.grp$state <- factor(state.grp$state, levels=state.grp$state)

      plot5b <- ggplot(state.grp, aes(grp, pct, fill=state,
                                      text = sprintf(paste("Count : %s\nStatus : %s\n"),
                                                     state.grp$count, state.grp$state))) +
        geom_bar(stat="identity") +
        ggtitle("Project Status by Completion") + xlab("Project Completion") + ylab("Percentage") +
        geom_text(aes(label=paste0(round(pct*100,1),"%")),
                  position=position_stack(vjust=0.5),
                  colour="white", size=5) +
        theme(plot.title=element_text(hjust=0.5),
              axis.title=element_text(size=12, face="bold"),
              axis.text.x=element_text(size=12), legend.position="bottom",
              legend.title=element_text(size=12, face="bold")) +
        scale_y_continuous(labels=scales::percent)
      
      ggplotly(plot5b, tooltip = "text")
    }
  })
  
  # Output 6
  output$plot6 <- renderPlot({
    state.pct <- ksdata %>%
      filter(state %in% c("successful", "failed")) %>%
      group_by(main_category, state) %>%
      summarize(count=n()) %>%
      mutate(pct=count/sum(count)) %>%
      arrange(desc(state), pct)

    state.pct$main_category <- factor(state.pct$main_category,
                                      levels=state.pct$main_category[1:(nrow(state.pct)/2)])

    ggplot(state.pct, aes(main_category, pct, fill=state)) + geom_bar(stat="identity") +
      ggtitle("Success vs. Failure Rate by Project Category") +
      xlab("Project Category") + ylab("Percentage") +
      scale_y_continuous(labels=scales::percent) +
      scale_fill_discrete(name="Project Status", breaks=c("successful", "failed"),
                          labels=c("Success", "Failure")) +
      geom_text(aes(label=paste0(round(pct*100,1),"%")), position=position_stack(vjust=0.5),
                colour="white", size=5) +
      theme(plot.title=element_text(hjust=0.5), axis.title=element_text(size=12, face="bold"),
            axis.text.x=element_text(size=12), legend.position="bottom",
            legend.title=element_text(size=12, face="bold")) +
      coord_flip()


  })

  # Output 7
  output$plot7 <- renderPlot({

    year.freq <- ksdata %>%
      filter(year(launched)!="1970") %>%
      group_by(year=year(launched)) %>%
      summarize(count=n())

    ggplot(year.freq, aes(year, count, fill=count)) + geom_bar(stat="identity") +
      ggtitle("Number of Projects by Launch Year") + xlab("Year") + ylab("Frequency") +
      scale_x_discrete(limits=c(2009:2018)) +
      geom_text(aes(label=paste0(count)), vjust=-0.5) +
      theme(plot.title=element_text(hjust=0.5), axis.title=element_text(size=12, face="bold"),
            axis.text.x=element_text(size=12), legend.position="null")


  })

  # Output 8
  output$plot8 <- renderPlot({

    state.pct2 <- ksdata %>%
      filter(year(launched)!="1970", state %in% c("successful", "failed")) %>%
      group_by(year=year(launched), state) %>%
      summarize(count=n()) %>%
      mutate(pct=count/sum(count)) %>%
      arrange(desc(state))

    ggplot(state.pct2, aes(year, pct, fill=state)) + geom_bar(stat="identity") +
      ggtitle("Success vs. Failure Rate by Year Launched") +
      xlab("Year") + ylab("Percentage") + scale_x_discrete(limits=c(2009:2017)) +
      scale_y_continuous(labels=scales::percent) +
      scale_fill_discrete(name="Project Status", breaks=c("successful", "failed"),
                          labels=c("Success", "Failure")) +
      geom_text(aes(label=paste0(round(pct*100,1),"%")), position=position_stack(vjust=0.5),
                colour="white", size=5) +
      theme(plot.title=element_text(hjust=0.5), axis.title=element_text(size=12, face="bold"),
            axis.text.x=element_text(size=12), legend.position="bottom",
            legend.title=element_text(size=12, face="bold"))
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

