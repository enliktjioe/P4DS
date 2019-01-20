# Setting working directory as a code starter
setwd("Week 1 - Programming For Data Science")
getwd()

# Create function for getting information/insight from your data
getInsight <- function(dataSource = "") {
  #TODO
}

getInsight(dataSource = "data_input/retail.csv")


# Read data using common function read.cs 
retail <- read.csv("data_input/retail.csv")

# Take a peak of our data using head() and tail()
head(retail)
tail(retail)

# Try to understand the structure of our data frame
str(retail)
summary(retail)

# pre-processing variables which supposed to have wrong class
retail$Row.ID <- as.character(retail$Row.ID)
retail$Order.Date <- as.Date(retail$Order.Date, "%m/%d/%y")
retail$Ship.Date <- as.Date(retail$Ship.Date, "%m/%d/%y")
retail$Customer.ID <- as.character(retail$Customer.ID)
retail$Product.ID <- as.character(retail$Product.ID)
retail$Product.Name <- as.character(retail$Product.Name)

# Formulate questions
# 1. How many our shipments were on Standard Class?
table(retail$Ship.Mode) # 1st method
summary(retail) # 2nd method
# Answer: 5968

# 2. How many Technology product did we sell to Corporate customers?
table(retail$Segment, retail$Category)
# Answer: 554

# 3. How many percentage of our sales were shipped to Consumer on Standard Class?
prop <- prop.table(table(retail$Segment, retail$Ship.Mode)) * 100
round(prop, digits = 2) # round numeric value to 2 decimal digits
# Answer: 30.87%

