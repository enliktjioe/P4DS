library(dplyr)
library(leaps)
library(MASS)

copiers <- read.csv("copiers.csv")
hist(copiers$Sales, breaks=20)
boxplot(copiers$Sales)

hist(copiers$Sales)

library(manipulate)
expr1 <- function(mn){
  mse <- mean((copiers$Sales - mn)^2)
  hist(copiers$Sales, breaks=20, main=paste("mean = ", mn, "MSE=", round(mse, 2), sep=""))
  abline(v=mn, lwd=2, col="darkred")
}
manipulate(expr1(mn), mn=slider(1260, 1360, step=10))


############################################################
##                                                        ##
############################################################

#Hands-on
library(dplyr)
retail <- read.csv("data_input/retail.csv")
str(retail)
retail.accessories <- retail %>% 
  filter(Sub.Category == "Accessories") %>% 
  dplyr::select("Ship.Mode", "Segment", "Quantity", "Sales", "Discount", "Profit")

summary(retail.accessories)

model1 <- lm(formula = Profit ~ ., data = retail.accessories)


summary(step(model1, direction = "backward"))

############################################################
##                                                        ##
############################################################

data("mtcars")
cars <- lm(mpg ~ ., mtcars)
cars.none <- lm(mpg ~ 1, mtcars)
summary(step(cars, direction = "backward"))
summary(step(cars.none, scope = list(lower = cars.none, upper = cars), direction = "forward"))
summary(step(cars.none, scope = list(upper = cars), direction = "both"))