########################################################################
# STAT4005 Final Exam
#
# Please fill in your information
#
# Name: CHAN King Yeung
# Student ID: 1155119394
#
########################################################################

# Q3a
data = as.ts(read.csv("data.csv")[,-1])
ts.plot(data)
acf(data)

# Q3b
y = data
trend = rep(NA, length(y))
for(i in (length(w) %/% 2 + 1):(length(y) - length(w) %/% 2))
  trend[i] = sum(y[(i - length(w) %/% 2):(i + length(w) %/% 2)] * w)
ts.plot(trend)

# Q3c
s = 12
w = unlist(ifelse(s != 0, ifelse(s %% 2 == 0, list(c(1 / (2 * s), rep(1 / s, s - 1), 1/(2 * s))), list(rep(1 / s, s))), list(w)))
noise = y - trend
season = rep(0, s)
if(s != 0) {
  for(i in 1:s) {
    tempNoise = noise[seq(i, length(y), s)][!is.na(noise[seq(i, length(y), s)])]
    season[i] = sum(tempNoise - mean(noise, na.rm = T)) / length(tempNoise)
  }
}
season = rep(season, round(length(y) / s))
round(season[1:s], 4)

# Checkpoint: 
# c(
	# 2.37273170, 8.08211884, 11.98421344, 6.23199337, 4.00836367,
	# 0.04657594,-2.07930081,-8.38038791,-12.27655628,-6.09746372,
	# -4.04161408, 0.14932584
# )

# Q3d
x1 = seq(1:length(y))
x2 = seq(1:length(y)) ^ 2
reg = lm((y - season) ~ x1 + x2)
summary(reg)

plot(y - reg$residuals - unlist(ifelse(s != 0, list(season[1:length(y)]), 0)))

# Checkpoint: 
# as.ts(read.csv("res.csv")[,-1])

# Q3e
ts.plot(res)
acf(res)
pacf(res)
# res = as.ts(read.csv("res.csv")[,-1])
# season =  c(
#   2.37273170, 8.08211884, 11.98421344, 6.23199337, 4.00836367,
#   0.04657594,-2.07930081,-8.38038791,-12.27655628,-6.09746372,
#   -4.04161408, 0.14932584
# )
# season  = rep(season, round(length(y) / s))
# noise = res + unlist(ifelse(s != 0, list(season[1:length(y)]), 0))

# Q3f
library(tseries)
adf.test(res, k = 0)

# Q3g
library(forecast)
model = auto.arima(res, max.q = 10, ic = "bic")
summary(model)

# Checkpoint: 
# as.ts(read.csv("arma_res.csv")[,-1])

# Q3h
arma_res = as.ts(read.csv("arma_res.csv")[,-1])
ljungBox = function(y, order, h) {
  fit = arima(y, order = order, include.mean = F)
  n = length(y)
  r.z = as.numeric(acf(fit$res, h, plot = F)$acf)
  ts = n * (n + 2) * sum((r.z[-1] ^ 2) / (n - (1:h)))
  cv = qchisq(0.95, h - 1)
  pv = pchisq(ts, h - 1)
  out = cbind(ts, cv, pv)
  colnames(out) = c('test_value', 'critical_value', 'p-value')
  return(round(out, 4))
}
ljungBox(arma_res, c(5,0,2), 15)

# Q3i
predict(data, 12)

# Q3j
lmt = function(y) {
  n = length(y)
  ysqt = y ^ 2
  reg = lm(ysqt[2:n] ~ ysqt[1:(n - 1)])
  Rsqt = summary(reg)$r.squared
  print('p-value')
  print(round(1 - pchisq(n * Rsqt, 1), 4))
}
lmt(arma_res)