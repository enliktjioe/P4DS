setwd("/Users/enlik/GitRepo/algoritma_ds_academy/Week 2 - Data Visualization/")
getwd()

library(ggplot2)
library(GGally)
library(ggthemes)
library(ggpubr)
library(leaflet)
library(lubridate)

vids <- read.csv("USvideos.csv")
names(vids)

vids$trending_date <- ydm(vids$trending_date)

vids$title <- as.character(vids$title)
vids$category_id <- sapply(as.character(vids$category_id), switch, 
                           "1" = "Film and Animation",
                           "2" = "Autos and Vehicles", 
                           "10" = "Music", 
                           "15" = "Pets and Animals", 
                           "17" = "Sports",
                           "19" = "Travel and Events", 
                           "20" = "Gaming", 
                           "22" = "People and Blogs", 
                           "23" = "Comedy",
                           "24" = "Entertainment", 
                           "25" = "News and Politics",
                           "26" = "Howto and Style", 
                           "27" = "Education",
                           "28" = "Science and Technology", 
                           "29" = "Nonprofit and Activism",
                           "43" = "Shows")
vids$category_id <- as.factor(vids$category_id)

head(vids$publish_time)
vids$publish_time <- ymd_hms(vids$publish_time,tz="America/New_York")

most <- vids[vids$views == max(vids$views),]
year(most$trending_date)
## [1] 2017

month(most$trending_date)
## [1] 12

day(most$trending_date)
## [1] 14

vids$publish_hour <- hour(vids$publish_time)
pw <- function(x){
  if(x < 8){
    x <- "12am to 8am"
  }else if(x >= 8 & x < 16){
    x <- "8am to 3pm"
  }else{
    x <- "3pm to 12am"
  }  
}

vids$publish_when <- as.factor(sapply(vids$publish_hour, pw))
vids$publish_wday <- as.factor(weekdays(vids$publish_time))

vids$publish_wday <- ordered(vids$publish_wday, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

vids[,c("views", "likes", "dislikes", "comment_count")] <- lapply(vids[,c("views", "likes", "dislikes", "comment_count")], as.numeric)

vids.u <- vids[match(unique(vids$title), vids$title),]
vids.u$timetotrend <- vids.u$trending_date - as.Date(vids.u$publish_time)
vids.u$timetotrend <- as.factor(ifelse(vids.u$timetotrend <= 7, vids.u$timetotrend, "8+"))


plot(as.factor(vids.u$publish_hour), vids.u$likes/vids.u$views)

vids.agt <- vids.u[vids.u$category_id == "Autos and Vehicles" | vids.u$category_id == "Gaming" | vids.u$category_id == "Travel and Events", ]
plot(vids.agt$likes, vids.agt$dislikes)
