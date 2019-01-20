# Algoritma Learn by Building
# R Programming for Data Science

# Project 1
# R Script and transform the data:
#   Write a R script containing a function (name the function however way you want)
#   This function is for getting information/insight from your data.
#   This function can contain several things as the base requirement but free to customize your script to add any extra functionalities,
#   Reads retail.csv file
#   Perform transform/pre-processing data (as.factor, as.Date, subsetting, append row/column, etc.)
#   Perform data manipulation (xtabs or aggregate)
#   Export cross-tabulation or plot as output (data frame, plot)

# Setting working directory as a project starter
setwd("Week 1 - Programming For Data Science")
getwd()

# I try to define my own question
# QUESTION: How was our Profit performance in 2017 based on Category and Segment variable?

# Load lubridate library as needed for "DATE" data manipulation
library(lubridate)

# Read data using common function read.csv()
retail <- read.csv("data_input/retail.csv")

# Try to understand the structure of our data frame
str(retail)
summary(retail)

# pre-processing variables which supposed to be used and have wrong class
retail$Order.Date <- as.Date(retail$Order.Date, "%m/%d/%y")
retail$Ship.Date <- as.Date(retail$Ship.Date, "%m/%d/%y")

# "Feature Engineering", create new column based on current column
retail$Order.Year <- year(retail$Order.Date)

# Subset data for year 2017 and remove unused column
r2017 <- retail[retail$Order.Year == 2017, -c(1, 2, 6, 8)]
summary(r2017)

# Remove unused dataframe in order to save memory
rm(retail)

# Use xtabs for data manipulation
# xtabs() can be used for numeric depending on categorical variables
# by default, it uses the sum() as the breakdown
xt1 <- xtabs(formula = Profit ~ Category + Segment, data = r2017)
xt1
plot(xt1, main = "2017 Profit on Category and Segment")

# Use aggregate for data manipulation
# very similar to xtabs except it takes an additional parameter
aggr1 <- aggregate(formula = Profit ~ Category + Segment, data = r2017, FUN = sum)
profit2017 <- as.data.frame(aggr1)
print(profit2017)

# Save our processed data into .csv file
write.csv(profit2017, file = "profit2017.csv")