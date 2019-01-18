# Create function for getting information/insight from your data
getInsight <- function(dataSource = "") {
  data_retail <- read.csv(dataSource)
  str(data1)
}

getInsight(dataSource = "data_input/retail.csv")


dataRetail <- read.csv("data_input/retail.csv")
str(dataRetail)
dataRetail$Order.Date <- as.Date(dataRetail$Order.Date, "%m/%d/%y")
head(dataRetail$Order.Date)
dataRetail$Ship.Date <- as.Date(dataRetail$Ship.Date, "%m/%d/%y")
head(dataRetail$Ship.Date)