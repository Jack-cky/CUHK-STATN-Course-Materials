## read price data
readPrice = function(path){
  setwd(path)
  
  data = as.data.frame(matrix(NA, nr = 1, nc = 3))
  names(data) = c("Types", "Average", "Date")
  data = data[-1,]
  
  files = list.files(pattern = "*.csv")
  for(i in 1:length(files)) {
    # read data
    date = substr(files[i], 1, 8)
    fileName = paste0(date, "-Wholesale_Prices.csv")
    file.rename(files[i], fileName)
    data_input = read.csv(fileName, header = T, stringsAsFactors = F, fileEncoding = "latin1")
    
    # keep only necessary rows
    flag = data_input[, "FRESH.FOOD.CATEGORY"] == "Livestock / Poultry" | data_input[, "FRESH.FOOD.CATEGORY"] == "Marine fish" | data_input[, "FRESH.FOOD.CATEGORY"] == "Freshwater fish" | data_input[, "FRESH.FOOD.CATEGORY"] == "Vegetables" | data_input[, "FRESH.FOOD.CATEGORY"] == "Eggs"
    data_input = data_input[flag,]
    
    # data cleansing
    data_input$PRICE..THIS.MORNING. = as.character(data_input$PRICE..THIS.MORNING.)
    data_input$PRICE..THIS.MORNING. = gsub("^\\s+|\\s+$", "", data_input$PRICE..THIS.MORNING.)
    data_input$PRICE..THIS.MORNING. = gsub("-", NA, data_input$PRICE..THIS.MORNING.)
    data_input$PRICE..THIS.MORNING. = as.numeric(data_input$PRICE..THIS.MORNING.)
    
    # modify data by unit
    data_input[which(data_input$FRESH.FOOD.CATEGORY == "Livestock / Poultry" & data_input$UNIT == "($ / Picul)"), "PRICE..THIS.MORNING."] = data_input[which(data_input$FRESH.FOOD.CATEGORY == "Livestock / Poultry" & data_input$UNIT == "($ / Picul)"), "PRICE..THIS.MORNING."] / 100
    data_input[which(data_input$FRESH.FOOD.CATEGORY == "Eggs"), "PRICE..THIS.MORNING."] = data_input[which(data_input$FRESH.FOOD.CATEGORY == "Eggs"), "PRICE..THIS.MORNING."] * 10
    
    # keep only necessary columns
    usefulVar = data_input[, c("FRESH.FOOD.CATEGORY", "PRICE..THIS.MORNING.")]
    
    # find menas by types
    usefulVar = aggregate(usefulVar$PRICE..THIS.MORNING., by = list(usefulVar$FRESH.FOOD.CATEGORY), FUN = mean, na.rm = TRUE)
    names(usefulVar) = c("Types", "Average")
    usefulVar$Average = round(usefulVar$Average, 2)
    usefulVar$Date = as.numeric(date)
    
    # output data
    data = rbind(data, usefulVar)
    rm(date, fileName, data_input, usefulVar, flag)
  }
  return(data)
}

data_2019 = readPrice("/Users/jackchan/Downloads/price 2019")
data = readPrice("/Users/jackchan/Downloads/price 2020")


## read covid 19 data
setwd("/Users/jackchan/Downloads")
data_covid = read.csv("time_series_covid19_confirmed_global.csv", header = T)
data_covid_deaths = read.csv("time_series_covid19_deaths_global.csv", header = T)
data_covid_recovered = read.csv("time_series_covid19_recovered_global.csv", header = T)

# data cleansing
Date = gsub("X", "", names(data_covid))
Date = as.character(as.Date(Date[5:length(Date)], "%m.%d.%y"))

# subtract data
data_confirm_cumulative = as.numeric(data_covid[which(data_covid$Province.State == "Hong Kong"), 5:length(names(data_covid))])
data_deaths_cumulative = as.numeric(data_covid_deaths[which(data_covid_deaths$Province.State == "Hong Kong"), 5:length(names(data_covid_deaths))])
data_recovered_cumulative = as.numeric(data_covid_recovered[which(data_covid_recovered$Province.State == "Hong Kong"), 5:length(names(data_covid_recovered))])
Confirmed = data_confirm_cumulative[1]
Deaths = data_deaths_cumulative[1]
Recovered = data_recovered_cumulative[1]
for(i in 2:length(data_confirm_cumulative)) {
  Confirmed[i] = data_confirm_cumulative[i] - data_confirm_cumulative[i - 1]
  Deaths[i] = data_deaths_cumulative[i] - data_deaths_cumulative[i - 1]
  Recovered[i] = data_recovered_cumulative[i] - data_recovered_cumulative[i - 1]
}

# negative value in Recovered
Recovered = abs(Recovered)

# create new data frame to store all data
data_new = as.data.frame(cbind(Date, Confirmed, Deaths, Recovered))
data_new$Date = as.Date(data_new$Date)
data_new$Confirmed =  as.numeric(as.character(data_new$Confirmed))
data_new$Deaths =  as.numeric(as.character(data_new$Deaths))
data_new$Recovered =  as.numeric(as.character(data_new$Recovered))

# create data frame by type
type = as.character(unique(data$Types))
for(i in 1:length(type)) {
  assign(type[i], data[which(data$Types == type[i]),])
}

# megre data into data_new
for(i in 1:length(type)) {
  tempDF = data[which(data$Types == type[i]),]
  tempDF$Date = as.character(tempDF$Date)
  tempDF$Date = as.Date(paste0(substr(tempDF$Date,1,4), "-", substr(tempDF$Date,5,6), "-", substr(tempDF$Date,7,8)))
  tempDF = tempDF[, c("Average", "Date")]
  names(tempDF) = c(type[i], "Date")
  data_new = merge(data_new, tempDF, by = "Date", all.x = T)
  rm(tempDF)
}

# create data_2019 frame by type
type = as.character(unique(data_2019$Types))
for(i in 1:length(type)) {
  assign(type[i], data_2019[which(data_2019$Types == type[i]),])
}

# megre data_2019 into data_new
for(i in 1:length(type)) {
  tempDF = data_2019[which(data_2019$Types == type[i]),]
  tempDF$Date = as.character(tempDF$Date + 10000)
  tempDF$Date = as.Date(paste0(substr(tempDF$Date,1,4), "-", substr(tempDF$Date,5,6), "-", substr(tempDF$Date,7,8)))
  tempDF = tempDF[, c("Average", "Date")]
  names(tempDF) = c(paste0(type[i], " 2019"), "Date")
  data_new = merge(data_new, tempDF, by = "Date", all.x = T)
  rm(tempDF)
}

# dealing with missing data
data_new[, c("Eggs", "Freshwater fish", "Livestock / Poultry", "Marine fish", "Vegetables")][1,] = data_new[, c("Eggs", "Freshwater fish", "Livestock / Poultry", "Marine fish", "Vegetables")][2,]

for(i in 2:nrow(data_new)) {
  if(is.na(data_new$Eggs[i]))
    data_new$Eggs[i] = data_new$Eggs[i - 1]
  if(is.na(data_new$`Freshwater fish`[i]))
    data_new$`Freshwater fish`[i] = data_new$`Freshwater fish`[i - 1]
  if(is.na(data_new$`Livestock / Poultry`[i]))
    data_new$`Livestock / Poultry`[i] = data_new$`Livestock / Poultry`[i - 1]
  if(is.na(data_new$`Marine fish`[i]))
    data_new$`Marine fish`[i] = data_new$`Marine fish`[i - 1]
  if(is.na(data_new$Vegetables[i]))
    data_new$Vegetables[i] = data_new$Vegetables[i - 1]
  
  if(is.na(data_new$`Eggs 2019`[i]))
    data_new$`Eggs 2019`[i] = data_new$`Eggs 2019`[i - 1]
  if(is.na(data_new$`Freshwater fish 2019`[i]))
    data_new$`Freshwater fish 2019`[i] = data_new$`Freshwater fish 2019`[i - 1]
  if(is.na(data_new$`Livestock / Poultry 2019`[i]))
    data_new$`Livestock / Poultry 2019`[i] = data_new$`Livestock / Poultry 2019`[i - 1]
  if(is.na(data_new$`Marine fish 2019`[i]))
    data_new$`Marine fish 2019`[i] = data_new$`Marine fish 2019`[i - 1]
  if(is.na(data_new$`Vegetables 2019`[i]))
    data_new$`Vegetables 2019`[i] = data_new$`Vegetables 2019`[i - 1]
}

data = data_new
rm(data_covid, data_covid_deaths, data_covid_recovered, data_new, data_2019,Eggs, `Freshwater fish`, `Livestock / Poultry`, `Marine fish`, Vegetables)


## EDA
summary(data)

# boxplot for cases: skewed, suggest transfer data
boxplot(data[,2:4],
        main = "The Number of the Novel Coronavirus Cases",
        xlab = "Number of Cases",
        col = c("blue", "red", "green"),
        border = "red",
        horizontal = T,
        notch = T)

# boxplot for prices: skewed, suggest transfer data
boxplot(data[, 5:9],
        main = "Average Wholesale Prices",
        ylab = "Average Price",
        col = "orange",
        border = "red",
        horizontal = F,
        notch = T)

# normality test for wholesale prices
shapiro.test(data$Eggs)
shapiro.test(data$`Freshwater fish`)
shapiro.test(data$`Livestock / Poultry`)
shapiro.test(data$`Marine fish`)
shapiro.test(data$Vegetables)

# test of seasonality: not reject H_0, no seasonality
library("seastests")
kw(ts(data$Confirmed), freq = 3, diff = T, residuals = F, autoarima = T)


## visualisation
# line plot for cases in Hong Kong
matplot(data$Date, cbind(cumsum(data$Confirm), cumsum(data$Deaths), cumsum(data$Recover)),
        main = "Overall Trends of Cases in Hong Kong",
        xlab = "Date Since 22/01/2020",
        ylab = "Cases",
        type = "l",
        col = c("blue", "red", "green"),
        lty = 1,
        lwd = 5)

legend("topleft",
       legend = c("Confirmed Cases", "Deaths", "Recovered cases"), 
       col = c("blue", "re d", "green"),
       lty = 1,
       cex = 0.8,
       lwd = 5)

# time series for visualisation
data_training_forecasts = HoltWinters(diff(window(ts(data$Confirmed))), beta = F, gamma = F)
plot(data_training_forecasts)
data_training_forecasts$SSE

# time series for forecasting
library(tidyverse)
library(fpp2)
data_training = diff(window(ts(data$Confirmed), end = nrow(data) - 30))
data_testing = diff(window(ts(data$Confirmed), start = nrow(data) - 30))
autoplot(data_training)

# minimum alpha
alpha = seq(.01, .99, by = .01)
RMSE = NA
for(i in seq_along(alpha)) {
  fit = ses(data_training, alpha = alpha[i], h = 30)
  RMSE[i] = accuracy(fit, data_testing)[2,2]
}
alpha.fit = data_frame(alpha, RMSE)
alpha.min = filter(alpha.fit, RMSE == min(RMSE))
ggplot(alpha.fit, aes(alpha, RMSE)) + geom_line() + geom_point(data = alpha.min, aes(alpha, RMSE), size = 2, color = "blue")  

# forecast validation
data_training_ses = ses(data_training, alpha = 0.2, h = 30)
autoplot(data_training_ses)
accuracy(data_training_ses, data_testing)
p1 = autoplot(data_training_ses) + theme(legend.position = "bottom")
p2 = autoplot(data_testing) + autolayer(data_training_ses, alpha = .5) + ggtitle("Predicted vs. actuals for the test data set")
gridExtra::grid.arrange(p1, p2, nrow = 1)

# model assumption validation
plotForecastErrors <- function(forecasterrors) {
  mybinsize = IQR(forecasterrors)/4
  mysd = sd(forecasterrors)
  mymin = min(forecasterrors) - mysd*5
  mymax = max(forecasterrors) + mysd*3
  mynorm = rnorm(10000, mean = 0, sd = mysd)
  mymin2 = min(mynorm)
  mymax2 = max(mynorm)
  if(mymin2 < mymin) {
    mymin <- mymin2
  }
  if(mymax2 > mymax) {
    mymax <- mymax2
  }
  mybins = seq(mymin, mymax, mybinsize)
  hist(forecasterrors, col = "red", freq = F, breaks = mybins)
  myhist = hist(mynorm, plot = F, breaks = mybins)
  points(myhist$mids, myhist$density, type = "l", col = "blue", lwd = 2)
}

plotForecastErrors(data_training_ses$residuals)

# whole data set as training dataset to forecast next 60 days: still possilbe to inrcrease number of confirmed cases
data_ses = ses(diff(window(ts(data$Confirmed))), alpha = 0.2, h = 30)
autoplot(data_ses)
plotForecastErrors(data_ses$residuals)


## assoication
# wilcoxon signed-rank test
wilcox.test(data$Eggs - data$`Eggs 2019`,
            y = NULL,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = NULL,
            correct = T,
            conf.int = F)

wilcox.test(data$`Freshwater fish` - data$`Freshwater fish 2019`,
            y = NULL,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = NULL,
            correct = T,
            conf.int = F)

wilcox.test(data$`Livestock / Poultry` - data$`Livestock / Poultry 2019`,
            y = NULL,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = NULL,
            correct = T,
            conf.int = F)

wilcox.test(data$`Marine fish` - data$`Marine fish 2019`,
            y = NULL,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = NULL,
            correct = T,
            conf.int = F)

wilcox.test(data$Vegetables - data$`Vegetables 2019`,
            y = NULL,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = NULL,
            correct = T,
            conf.int = F)

# power transform on confirmed cases
cases = ifelse(data$Confirmed == 0, 0, log(data$Confirmed))

# R^2 of prices and confirmed cases: the variation explained by confirmed cases is not significant
par(mfrow = c(1, 5))
rsq = NA
for(i in 5:9) {
  plot(cases, data[, i],
       ylab = "",
       xlab = names(data)[i])
  reg = lm(data[, i]~cases)
  abline(reg, col = "red")
  rsq[i - 4] = summary(reg)$r.squared
}
rsq