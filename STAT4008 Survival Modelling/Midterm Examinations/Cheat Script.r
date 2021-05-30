####################################################################################################
library(survival)
####################################################################################################
# 0 right-censored
# 1 failure
# 2 left-censored
# 3 interval
####################################################################################################
## right-censored
ti = c(1,1,1,2,2,3,3,3,4,4,4,5,5,6,6,6,6,6,7,8,8,9,9,9,9)
ci = as.integer(unlist(strsplit('0110001100011000111000001', "")))

# ti = c(1,2,3,4,5,6,7,8,9)
# ri = as.integer(unlist(strsplit('121303023', "")))
# di = as.integer(unlist(strsplit('202022101', "")))
# ti = rep(ti, ri + di)
# ci = c()
# if(length(ri) == length(di)) {
#   for(i in 1:length(ri)) {
#     ci = c(ci, rep(0, ri[i]), rep(1, di[i]))
#   }
# }

# set.seed(2)
# setwd('/Users/jackchan/Downloads')
# data = read.csv("mtest.csv")
# data = data[sample(1:nrow(data), 200), ]
# ti = data$x
# ci = 1 - data$ind

sur = survfit(Surv(ti, ci) ~ 1)

# temp = summary(sur)
# result = data.frame(temp$time, temp$n.event, temp$n.risk, round(lambda <- temp$n.event / temp$n.risk, 4), round(temp$surv, 4), round(temp$std.err, 4), round(exp(-cumsum(lambda)), 4), round(sqrt(cumsum(temp$n.event / temp$n.risk ^ 2)) * exp(-cumsum(lambda)), 4))
# colnames(result) = c('ti', 'di', 'ni', 'lambda', 'KM est', 'KM se', 'NA est', 'NA se')
# result = rbind(c(0, 0, temp$n, 0, 1, 0, 1, 0), result)
# tMax = tail(sur$time, 1)
# result$mean = cumsum(result$`KM est`[length(result$`KM est`):1] * (c(tMax, result$ti[length(result$ti):1][1:length(result$ti) - 1]) - result$ti[length(result$ti):1]))[length(result$`KM est`):1]
# # result
# 
# mean.se = round(sqrt(sum(result$mean ^ 2 * result$di / (result$ni * (result$ni - result$di)), na.rm = T)), 4)

print(sur, print.rmean = T)

## confidence interval
# result$linearLB = round(result$`KM est` - qnorm(0.975) * result$`KM se`, 4)
# result$linearUB = round(result$`KM est` + qnorm(0.975) * result$`KM se`, 4)
# 
# result$loglogTransLB = round(result$`KM est` ^ (1 / exp(qnorm(0.975) * result$`KM se` / (result$`KM est` * log(result$`KM est`)))), 4)
# result$loglogTransUB = round(result$`KM est` ^ exp(qnorm(0.975) * result$`KM se` / (result$`KM est` * log(result$`KM est`))), 4)
# 
# result$arcinTransLB = round(sin(asin(sqrt(result$`KM est`)) - qnorm(0.975) * 0.5 * result$`KM se` / result$`KM est` * sqrt(result$`KM est` / (1 - result$`KM est`))) ^ 2, 4)
# result$arcinTransUB = round(sin(asin(sqrt(result$`KM est`)) + qnorm(0.975) * 0.5 * result$`KM se` / result$`KM est` * sqrt(result$`KM est` / (1 - result$`KM est`))) ^ 2, 4)

## quantile
# p = 0.5
# result$linear = (result$`KM est` - (1 - p)) / result$`KM se`
# quantileLinear = result$ti[result$linear <= 1.96 & result$linear >= -1.96]
# quantileLinearRange = c(min(quantileLinear, na.rm = T), max(quantileLinear, na.rm = T))
# 
# result$loglogTrans = ((log(-log(result$`KM est`)) - log(-log(1 - p))) * result$`KM est` * log(result$`KM est`)) / result$`KM se`
# quantileloglogTrans = result$ti[result$loglogTrans <= 1.96 & result$loglogTrans >= -1.96]
# quantileloglogTransRange = c(min(quantileloglogTrans, na.rm = T), max(quantileloglogTrans, na.rm = T))
# 
# result$arcsinTrans = 2 * (asin(sqrt(result$`KM est`)) - asin(sqrt(1 - p))) * sqrt(result$`KM est` * (1 - result$`KM est`)) / result$`KM se`
# quantilearcsinTrans = result$ti[result$arcsinTrans <= 1.96 & result$arcsinTrans >= -1.96]
# quantilearcsinTransRange = c(min(quantilearcsinTrans, na.rm = T), max(quantilearcsinTrans, na.rm = T))

## hazard function
# result$`Haz KM est` = round(-log(result$`KM est`), 4)
# result$`Haz KM se` = round(sqrt(cumsum(result$di / (result$ni * (result$ni - result$di)))), 4)
# 
# result$`Haz NA est` = round(cumsum(result$lambda), 4)
# result$`Haz NA se` = round(sqrt(cumsum(result$di / result$ni ^ 2)), 4)

## hazard function (full set, including 0 event cases)
# cum_KM = -log(sur$surv)
# cum_NA = cumsum(sur$n.event / sur$n.risk)
# plot(sur$time, cum_KM, type = 'l', col = 'red')
# lines(sur$time, cum_NA, type = 'l', col = 'blue')
####################################################################################################
## compare 2 groups of survival data
# model = survfit(Surv(ti, ci) ~ data$sex)
# plot(model, lty = 2:3)
####################################################################################################
## all types of censored
tsi = c(1, 6, 5, 3, 7, 2, 3, 4, 5)
tei = c(1, 6, 5, 3, 9, 2, 4, 4, 5)
ci = c(1, 0, 2, 1, 3, 2, 3, 1, 0)
sur = survfit(Surv(tsi, tei, ci, type = 'interval') ~ 1)
summary(sur)
print(sur, print.rmean = T)
####################################################################################################
## left-truncated
entry = c(58, 58, 59, 60, 60, 61, 61, 62 ,62, 62, 63, 63, 64, 66, 66, 67, 67, 67, 68, 69, 69, 69, 70, 70, 70, 71, 72, 72, 73, 73)
exit = c(60, 63, 69, 62, 65, 72, 69, 73, 66, 65, 68, 74, 71, 68, 69, 70, 77, 69, 72, 79, 72, 70, 76, 71, 78, 79, 76, 73, 80, 74)
ci = c(1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1)
data = data.frame(entry, exit, ci)
L = 60

sur = survfit(Surv(exit, ci) ~ 1, data[exit >= L, ])
ti = sur$time[sur$n.event != 0]
ni = rep(0, length(ti))
for(i in 1:length(ti))
  ni[i] = sum(entry <= ti[i] & ti[i]<= exit)
di = sur$n.event[sur$n.event != 0]
surv_fun = cumprod(1 - di / ni)

result = data.frame(ti, ni, round(surv_fun, 4))
colnames(result) = c('ti', 'ni', 'S(t|)')
result
####################################################################################################
## right-truncated
ti = c(2, 4, 7, 14, 20, 18, 8, 13, 17, 26, 20, 15, 23, 5, 16, 15, 11, 9, 33, 4, 8, 35, 10, 36, 25)
xi = c(30, 27, 25, 19, 18, 17, 16, 16, 15, 15, 15, 13, 13, 12, 11, 9, 8, 8, 8, 7, 6, 6, 6, 4, 4)
tau = 42
ri = tau - xi

sur = survfit(Surv(ri) ~ 1)
temp1 = outer(ti, sur$time, '<=')
temp2 = outer(ri, sur$time, '>=')
temp3 = temp1 & temp2
ni = apply(temp3, 2, sum)
surv = cumprod(1 - sur$n.event / ni)

di = rep(0, length(ri))
temp4 = outer(ri, ri, '==')
di[1] = sum(temp4[, 1])
for(i in 2:length(ri)) {
  if(all(temp4[, i] == temp4[, i - 1]))
    di[i] = 0
  else
    di[i] = sum(temp4[, i])
}

ni = rep(0, length(ri))
for(i in 1:length(ri))
  ni[i] = sum(ri[i] <= ri & ri[i] >= ti)
ni[which(di == 0)] = 0

surv_fun = rep(0, length(ri))
surv_fun[which(di != 0)] = round(surv, 4)

surv_fun[which(di == 0)] = ''
ni[which(di == 0)] = ''
di = ifelse(di == 0, '', di)
result = data.frame(ti, xi, ri, di, ni, surv_fun)
colnames(result) = c('  T_i', '  X_i', '  R_i', '  d_i', '  n_i', paste0('Pr(X < x_i|X <= ', tau, ')'))
result
####################################################################################################