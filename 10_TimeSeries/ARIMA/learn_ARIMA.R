# Reference:
# https://www.datascience.com/blog/introduction-to-forecasting-with-arima-in-r-learn-data-science-tutorials

# Step 1: Load R Packages 
library("ggplot2") ; library("tseries") ; library(forecast)

daily_data <- read.csv("Bike-Sharing-Dataset/day.csv", header = TRUE, stringsAsFactors = FALSE)
str(daily_data)
summary(daily_data)

# Step 2: Examine Your Data
daily_data$Date <- as.Date(daily_data$dteday)

ggplot(daily_data, aes(Date, cnt)) +
  geom_line() +
  scale_x_date("month") +
  ylab("Daily Bike Checkouts") +
  xlab("")

count_ts <- ts(daily_data[, c('cnt')])

daily_data$clean_cnt <- tsclean(count_ts)

ggplot() +
  geom_line(data =  daily_data, aes(x = Date, y = clean_cnt)) + ylab("Cleaned Bicylcle Count")

daily_data$cnt_ma = ma(daily_data$clean_cnt, order = 7) # using the clean count with no outliers
daily_data$cnt_ma30 = ma(daily_data$clean_cnt, order = 30)

ggplot() +
  geom_line(data = daily_data, aes(Date, clean_cnt, colour = "Counts")) +
  geom_line(data = daily_data, aes(Date, cnt_ma, colour = "Weekly Moving Average")) +
  geom_line(data = daily_data, aes(Date, cnt_ma30, colour = "Monthly Moving Average")) + 
  ylab("Bicycle Count")


# Step 3: Decompose Your Data
# The building blocks of a time series analysis are seasonality, trend, and cycle
# STL is a flexible function for decomposing and forecasting the series
count_ma <- ts(na.omit(daily_data$cnt_ma), frequency = 30)
decomp <- stl(count_ma, s.window="periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)


# Step 4: Stationarity
adf.test(count_ma, alternative = "stationary")


# Step 5: Autocorrelations and Choosing Model Order
Acf(count_ma, main = '')
Pacf(count_ma, main = '')

count_d1 = diff(deseasonal_cnt, differences = 1)
plot(count_d1)
adf.test(count_d1, alternative = "stationary")

Acf(count_d1, main = 'ACF for Differenced Series')
Pacf(count_d1, main = 'PACF for Differenced Series')

# Step 6: Fitting an ARIMA model
auto.arima(deseasonal_cnt, seasonal = F)

# Step 7: Evaluate and Iterate
fit <- auto.arima(deseasonal_cnt, seasonal = F)
tsdisplay(residuals(fit), lag.max = 45, main = "(1,1,1) Model Residuals")

fit2 <- arima(deseasonal_cnt, order = c(1,1,7))
fit2

tsdisplay(residuals(fit2), lag.max = 15, main = 'Seasonal Model Residuals')

fcast <- forecast(fit2, h = 30)
plot(fcast)

hold <- window(ts(deseasonal_cnt), start = 700)

fit_no_holdout <- arima(ts(deseasonal_cnt[-c(700:725)]), order = c(1,1,7))

fcast_no_holdout <- forecast(fit_no_holdout, h = 25)
plot(fcast_no_holdout, main = '')
lines(ts(deseasonal_cnt))

fit_w_seasonality <- auto.arima(deseasonal_cnt, seasonal = T)
fit_w_seasonality

seas_fcast <- forecast(fit_w_seasonality, h = 30)
plot(seas_fcast)