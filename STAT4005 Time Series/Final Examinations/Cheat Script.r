####################################################################################################
# Chapter 01
####################################################################################################
## difference a series with p-order
# arr: series; p: number of differencing; s: number of season
pTimeDifferencing = function(arr, p, s = 1) {
  if(p == 1)
    return(diff(arr, s))
  else
    pTimeDifferencing(diff(arr, s), p - 1)
}
# example: difference a series 3 time with 1 season
pTimeDifferencing(c(3,4,6,7,5,3,2), 3)
####################################################################################################
## filter pass through p-order trend
# arr: series; p: p-polynomial
pDistortion = function(arr, p) {
  sum = 0
  r = -(length(arr) %/% 2):(length(arr) %/% 2)
  for(i in 1:length(arr))
    sum = sum + r[i] ^ p * arr[i]
  return(sum)
}
# example: check if a series pass through 3-order trend
pDistortion(c(-0.1, 0.4, 0.4, 0.4, -0.1), 3)
####################################################################################################
## decompose a series with trend, season and noise
# y: series; w: weight (input c() if weight is unknown); s: number of season
decomposition = function(y, w = c(), s = 0) {
  w = unlist(ifelse(s != 0, ifelse(s %% 2 == 0, list(c(1 / (2 * s), rep(1 / s, s - 1), 1/(2 * s))), list(rep(1 / s, s))), list(w)))
  trend = rep(NA, length(y))
  for(i in (length(w) %/% 2 + 1):(length(y) - length(w) %/% 2))
    trend[i] = sum(y[(i - length(w) %/% 2):(i + length(w) %/% 2)] * w)
  noise = y - trend
  season = rep(0, s)
  if(s != 0) {
    for(i in 1:s) {
      tempNoise = noise[seq(i, length(y), s)][!is.na(noise[seq(i, length(y), s)])]
      season[i] = sum(tempNoise - mean(noise, na.rm = T)) / length(tempNoise)
    }
  }
  season = rep(season, round(length(y) / s))
  noise = y - trend - unlist(ifelse(s != 0, list(season[1:length(y)]), 0))
  print('trend')
  print(round(trend, 4))
  print('season')
  print(round(season[1:s], 4))
  print('noise')
  print(round(noise, 4))
}
# example: decompose a series with a given weight without considering seasonality
decomposition(c(32, 28, 33, 31, 28, 30, 26), c(-0.1, 0.4, 0.4, 0.4, -0.1))
# example: decompose a series by 3 season
decomposition(c(3,5,4,9,5,7,6,8), s = 3)
####################################################################################################
## estimate trend and noise
# y: series
regTrend = function(y) {
  reg = lm(y~seq(1:length(y)))
  trend = rep(0, length(y))
  for(i in 1:length(y))
    trend[i] = reg$coefficients[1] + reg$coefficients[2] * i
  noise = y - trend
  return(t(data.frame(trend = round(trend, 4), noise = round(noise, 4))))
}
# example: estimate the trend and noise of a series
regTrend(c(3.1,5.4,2.9,7.6,10.5,9.6))
## alternative method
# Y = c(1.2, 2.1, 2.9, 3.8)
# X = matrix(c(rep(1, length(Y)), seq(1, length(Y))), nr = length(Y), byr = F)
# solve(t(X) %*% X) %*% t(X) %*% Y
####################################################################################################
# Chapter 02
####################################################################################################
## sample ACVF
# y; series; h: time lag; round: boolean for rounding
sampleACVF = function(y, h, round = F) {
  acvf = sum((y[(h + 1):length(y)] - mean(y)) * (y[1:(length(y) - h)] - mean(y))) / length(y)
  if(round)
    return(round(acvf, 4))
  else
    return(acvf)
}
# example: find the sample ACVF of a series
sampleACVF(c(1.2,2.3,2.1,1.5,0.8,1.2), 1, T)
####################################################################################################
## sample ACF
# y; series; h: time lag; round: boolean for rounding
sampleACF = function(y, h, round = F) {
  acf = sampleACVF(y, h) / sampleACVF(y, 0)
  if(round)
    return(round(acf, 4))
  else
    return(acf)
}
# example: find the sample ACF of a series
sampleACF(c(1.2,2.3,2.1,1.5,0.8,1.2), 1, T)
## alternative method
# acf(c(1.2,2.3,2.1,1.5,0.8,1.2), plot = F)$acf
####################################################################################################
# Chapter 04
####################################################################################################
## yule walker estimate
# y: series; p: number of AR order
YWE = function(y, p) {
  if(p < 2) {
    return('ERROR: \'p\' MUST BE GREATER THAN 1')
  }
  gamma = rep(0, p)
  for(i in 1:p)
    gamma[i] = sampleACF(y, i - 1)
  toeplitz(gamma)
  return(round(solve(toeplitz(gamma)) %*% c(gamma[2:p], sampleACF(y, p)), 4))
}
# example: estimate AR parameters from a series
YWE(c(-1.4,.39,.97,1.5,.59,-2.4,-2.2,-1.5,-.42,.1), 2)
####################################################################################################
## yule walker estimate, given acf ver. 
# acf: acf
YWE.alpha = function(acf) {
  p = length(acf)
  if(p == 1)
    return('ERROR: INVALID INPUT WHERE LENGTH OF ACF MUST BE GREATER THAN 1')
  if(p == 2)
    return(acf[p])
  lag = acf[p]
  acf = acf[1:(p - 1)]
  return(round(solve(toeplitz(acf)) %*% c(acf[2:(p - 1)], lag), 4))
}
# example: estimate AR parameters from ACF
YWE.alpha(c(1,0.89,.74,.6))
####################################################################################################
## least squares estimate
# y: series; p: number of AR order; c: initialise assumption on H0
LSE = function(y, p, c = 0) {
  Y = y[(p + 1):length(y)]
  mat = c()
  for(i in 1:p)
    mat = cbind(mat, y[(p + 1 - i):(length(y) - i)])
  X = as.matrix(mat)
  reg = lm(Y ~ -1 + X)
  fit = rep(NA, length(y) - p)
  for(i in 1:length(fit))
    fit[i] = sum(y[i:(i + p - 1)] * reg$coefficients[p:1])
  fit = c(rep(NA, p), fit)
  sigma2 = sum((y - fit) ^ 2, na.rm = T) / (length(y) - p)
  # hypothesis test; CI
  gamma = rep(NA, p)
  for(i in 1:p)
    gamma[i] = sampleACVF(y, i - 1)
  semat = diag(solve(toeplitz(gamma)))
  z = rep(NA, p)
  lb = rep(NA, p)
  ub = rep(NA, p)
  for(i in 1:p) {
    z[i] = (c - reg$coefficients[i]) / sqrt(sigma2 * semat[i] / length(y))
    lb[i] = reg$coefficients[i] - qnorm(0.975) * sqrt(sigma2 * semat[i] / length(y))
    ub[i] = reg$coefficients[i] + qnorm(0.975) * sqrt(sigma2 * semat[i] / length(y))
  }
  print('phi')
  print(round(reg$coefficients, 4))
  print('sigma ^ 2')
  print(round(sigma2, 4))
  print('hypothesis test')
  print(round(z, 4))
  print('CI lower')
  print(round(lb, 4))
  print('CI upper')
  print(round(ub, 4))
}
# example: estimate AR parameters, sigma^2, H0: phi=0, and CI of a series
LSE(c(-1,1,0,4,-1,3), 2)
####################################################################################################
## conditional  least  squares  estimates
y = c(-1,1,0,4,-1,3)
# para: parameters in 'p' and 'q'
CLS = function(para) {
  phi = para[1]
  theta = para[2]
  z = rep(0, length(y))
  z[1] = y[1]
  for(i in 2:length(y)) {
    # formula
    z[i] = y[i] - phi * y[i - 1] - theta * z[i - 1]
  }
  return(sum(z ^ 2))
}
sol = optim(c(0.1, 0.1), CLS)
sol$par[1] # phi
sol$par[2] # theta
CLS(sol$par) / (length(y) - 1) # sigma ^ 2; '-1' for 'p = 1'
####################################################################################################
## maximum likelihood estimate
y = c(-1,1,0,4,-1,3)
# y: series; order: order of ARIMA
arima(y, order = c(1, 0, 1), include.mean = F)
####################################################################################################
## sample PACF
# y; series; h: time lag; round: boolean for rounding
samplePACF = function(y, h, round = F) {
  pacf = solve(toeplitz(acf(y, plot = F)$acf[1:h]), acf(y, plot = F)$acf[2:(1 + h)])[h]
  if(round)
    return(round(pacf, 4))
  else
    return(pacf)
}
# example: find phi_11 AR parameter from a series
samplePACF(c(1.2,2.3,2.1,1.5,0.8,1.2), 1, T)
## alternative method
# pacf(c(1.2,2.3,2.1,1.5,0.8,1.2),plot=F)$acf[1]
####################################################################################################
## sample PACF, given acf ver.
# acf: acf
samplePACF.alpha = function(acf) {
  h = length(acf)
  if(h == 1)
    return('ERROR: INVALID INPUT WHERE LENGTH OF ACF MUST BE GREATER THAN 1')
  if(h == 2)
    return(acf[h])
  lag = acf[h]
  acf = acf[1:(h - 1)]
  mat = toeplitz(acf)
  acf = c(acf[1:(h - 1)], lag)
  dem = det(mat)
  mat[, (h - 1)] = acf[2:h]
  num = det(mat)
  return(round(num / dem, 4))
}
# example: find phi_33 AR parameter from ACF
samplePACF.alpha(c(1,0.89,.74,.6))
####################################################################################################
## order selection
# y: series; order.input: order of ARIMA
IC = function(y, order.input) {
  fit = arima(y, order = order.input, include.mean = F)
  n = length(y)
  p = order.input[1]
  q = order.input[3]
  sig = fit$sigma2
  FPE = sig * (n + p) / (n - p)
  AIC = fit$aic
  AICC = fit$aic - 2 * (q + 1) + 2 * (q + 1) * n / (n - q - 2)
  BIC = (n - p - q) * log(n * sig / (n - p - 1)) + n * (1 + log(sqrt(2 * pi))) + (p + q) * log((sum(y ^ 2) - n * sig) / (p + q))
  out = cbind(FPE, AIC, AICC, BIC)
  colnames(out) = c("FPE", "AIC", "AICC", "BIC")
  return(round(out, 4))
}
# example: find criteria of ARIMA(1,0,1)
IC(c(-.63,-1.8,-.98,-.67,-1.14,-1.67,-2.35,-1.7), order = c(1, 0, 1))
####################################################################################################
## ljung-box test
# y: series; order: order of ARIMA; h: between 10 to 30
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
# example: find Q(10) for the test on H0: rho = 0
ljungBox(c(-1,1,0,4,-1,3), c(1,0,0), 10)
## alternative method
# tsdiag(arima(y, order = c(0,0,1), include.mean = F))
####################################################################################################
# Chapter 06
####################################################################################################
## reversed noise calculation for MA
# y: series; theta: parameters of MA
noiseCalMA = function(y, theta) {
  n = rep(0, length(y))
  for(i in 1:length(y)) {
    # formula
    n[i] = sum(y[i],
               - theta[ifelse(i - 1 < 1, NA, 1)] * n[ifelse(i - 1 < 1, NA, i - 1)],
               - theta[ifelse(i - 2 < 1, NA, 2)] * n[ifelse(i - 2 < 1, NA, i - 2)],
               na.rm = T)
  }
  return(round(n, 4))
}
# example
noiseCalMA(c(5,3.5,-.4,-1.5), c(.3,-.4))
####################################################################################################
## reversed noise calculation for ARMA
# y: series; theta: parameters of ARMA
noiseCalARMA = function(y, phi, theta) {
  n = rep(0, length(y))
  for(i in 2:length(y)) {
    # formula
    n[i] = y[i] - phi * y[i - 1] - theta * n[i - 1]
  }
  return(round(n, 4))
}
# example
noiseCalARMA(c(5,3.5,-.4,-1.5),.3,-.4)
####################################################################################################
## n-step forecast for MA
# y: series; theta: parameters of MA; step: number of forecast
forecastMA = function(y, theta, step) {
  y_hat = rep(0, step)
  noise = noiseCalMA(y, theta)
  t = length(y)
  # formula
  for(i in 1:step) {
    y_hat[i] = sum(noise[ifelse(t - 1 + i > t, NA, t - 1 + i)] * theta[1],
                   noise[ifelse(t - 2 + i > t, NA, t - 2 + i)] * theta[2],
                   na.rm = T)
  }
  return(round(y_hat, 4))
}
# example
forecastMA(c(5,3.5,-.4,-1.5), c(.3,-.4), 3)
## alternative method
# library(forecast)
# forecast(arima(c(5,3.5,-.4,-1.5), order = c(0, 0, 2), include.mean = F))
####################################################################################################
## n-step forecast for AR
# y: series; phi: parameters of AR; step: number of forecast
forecastAR = function(y, phi, step) {
  y_hat = rep(0, step)
  t = length(y)
  # formula
  for(i in 1:step) {
    y_hat[i] = sum(ifelse(t - 1 + i > t, y_hat[i - 1], y[t - 1 + i]) * phi[1],
                   ifelse(t - 2 + i > t, y_hat[i - 2], y[t - 2 + i]) * phi[2],
                   na.rm = T)
  }
  return(round(y_hat, 4))
}
# example
forecastAR(c(50,80,70), c(.9,-.2), 3)
####################################################################################################
# Chapter 07
####################################################################################################
## unit root test
library(tseries)
# y: series; k: step
adf.test(y, k = 0)
####################################################################################################
## lagrange multiplier test
library(tseries)
# y:series
lmt = function(y) {
  n = length(y)
  ysqt = y ^ 2
  reg = lm(ysqt[2:n] ~ ysqt[1:(n - 1)])
  Rsqt = summary(reg)$r.squared
  print('p-value')
  print(round(1 - pchisq(n * Rsqt, 1), 4))
}
# example
lmt(c(-1.4,.39,.97,1.5,.59,-2.4,-2.2,-1.5,-.42,.1))
####################################################################################################
## MLE for GARCH
library(tseries)
# y: series, order: order of GARCH
model = garch(c(-1.4,.39,.97,1.5,.59,-2.4,-2.2,-1.5,-.42,.1), order=c(1,1), trace = F)
model$coef
####################################################################################################
## ljung-box test
library(tseries)
# y: series, order: order of GARCH
model = garch(c(-1.4,.39,.97,1.5,.59,-2.4,-2.2,-1.5,-.42,.1), order=c(1,1), trace = F)
summary(model)$l.b.test
####################################################################################################