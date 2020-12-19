setwd("/Users/jackchan/Downloads")
data <- read.csv("Novel Coronavirus Dataset for Visualization.csv", header = TRUE)

Date <- as.Date(data$ObservationDate, format = "%m/%d/%Y")
data <- cbind(data, Date)
data <- data[, c(9, 3:4, 6:8)]

tempCum <- data.frame(as.character(data$Date), data$Confirmed, data$Deaths, data$Recovered)
names(tempCum) <- c("Date", "Confirmed", "Deaths", "Recovered")

cumulativeConfirmed <- aggregate(tempCum$Confirmed, by = list(tempCum$Date), sum)
names(cumulativeConfirmed) <- c("Date", "Confirmed")
cumulativeDeaths <- aggregate(tempCum$Deaths, by = list(tempCum$Date), sum)
names(cumulativeDeaths) <- c("Date", "Deaths")
cumulativeRecovered <- aggregate(tempCum$Recovered, by = list(tempCum$Date), sum)
names(cumulativeRecovered) <- c("Date", "Recovered")
cumulativeCases <- cbind(cumulativeConfirmed, cumulativeDeaths$Deaths, cumulativeRecovered$Recovered)
names(cumulativeCases) <- c("Date", "Confirmed", "Deaths", "Recovered")

confirmedPerDay <- c()
deathsPerDay <- c()
recoveredPerDay <- c()
confirmedPerDay[1] <- cumulativeConfirmed$Confirmed[1]
deathsPerDay[1] <- cumulativeDeaths$Deaths[1]
recoveredPerDay[1] <- cumulativeRecovered$Recovered[1]
perDayData <- data.frame(confirmedPerDay, deathsPerDay, recoveredPerDay)

for(i in 2:length(cumulativeConfirmed$Date)) {
  perDayData[i, 1] <- cumulativeConfirmed$Confirmed[i] - cumulativeConfirmed$Confirmed[i - 1]
  perDayData[i, 2] <- cumulativeDeaths$Deaths[i] - cumulativeDeaths$Deaths[i - 1]
  perDayData[i, 3] <- cumulativeRecovered$Recovered[i] - cumulativeRecovered$Recovered[i - 1]
}

# graph 1
matplot(as.Date(cumulativeConfirmed$Date), cumulativeCases[,-1], xlab = "Date Since 22/01/2020", ylab = "Cases", type = "l", col = c("blue", "red", "green"), lty = 1, main = "Overall Trends of Cases (WorldWide)")
legend("topleft", legend = c("Confirmed", "Deaths", "Recovered"), col = c("blue", "red", "green"), lty = 1, cex = 0.8)

# graph 2
y_lambda0.2 <- perDayData[, 2]
x_lambda0.2 <- perDayData[, 1]

for(i in 1:length(perDayData[, 2])) {
  if(perDayData[i, 2] == 0){
    y_lambda0.2[i] <- log(perDayData[i, 2])
    x_lambda0.2[i] <- log(perDayData[i, 1])
  }
  else{
    y_lambda0.2[i] <- (y_lambda0.2[i] ^ 0.2 - 1) / 0.2
    x_lambda0.2[i] <- (x_lambda0.2[i] ^ 0.2 - 1) / 0.2
  }
}

plot(x_lambda0.2, y_lambda0.2, xlab = "Number of Confirmed Cases", ylab = "Number of Death Cases", main = "Correlation between Confirmed and Death")
reg <- lm(y_lambda0.2 ~ x_lambda0.2)
abline(reg, col = "red")