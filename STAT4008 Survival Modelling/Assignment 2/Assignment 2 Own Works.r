library(survival)

## Question 3
time = c(2, 4, 4, 4, 5, 6, 7, 7, 8)
censor = c(1, 1, 1, 0, 1, 0, 1, 0, 0)
suv = survfit(Surv(time, censor) ~ 1)
summary(suv)
print(suv, print.rmean = T)

## Question 4
timeDT = c(1, 3, 4, 5, 5, 8, 23, 26, 27, 30, 42, 56, 62, 69, 104, 104, 112, 129, 181, 8, 67, 76, 104, 176, 231)
censorDT = c(rep(1, 19), rep(0, 6))
suvDT = survfit(Surv(timeDT, censorDT) ~ 1)
summary(suvDT)

hazardDT = cbind(suvDT$time, suvDT$n.risk, suvDT$n.event, -log(suvDT$surv), sqrt(cumsum(suvDT$n.event / (suvDT$n.risk * (suvDT$n.risk - suvDT$n.event)))), suvDT$cumhaz, suvDT$std.chaz)
colnames(hazardDT) = c('time', 'n.risk', 'n.event', 'KM estimate', 's.e. of KM estimate', 'NA estimate', 's.e. of NA estimate')
hazardDT[hazardDT[, 'n.event'] != 0, ]

print(suvDT, print.rmean = T)
c(80.2 - 1.96 * 15.6, 80.2 + 1.96 * 15.6)

medianDT = cbind(summary(suvDT)$time, (summary(suvDT)$surv - 0.5) / summary(suvDT)$std.err)
colnames(medianDT) = c('time', 'linear')
medianDT

timeAT = c(1, 3, 3, 4, 10, 13, 13, 16, 16, 24, 26, 27, 28, 30, 30, 32, 41, 51, 65, 67, 70, 72, 73, 77, 91, 93, 96, 100, 104, 157, 167, 61, 74, 79, 80, 81, 87, 87, 88, 89, 97, 101, 104, 108, 109, 120, 131, 150, 231, 240, 400)
censorAT = c(rep(1, 31), rep(0, 20))
suvAT = survfit(Surv(timeAT, censorAT) ~ 1)
summary(suvAT)

hazardAT = cbind(suvAT$time, suvAT$n.risk, suvAT$n.event, -log(suvAT$surv), sqrt(cumsum(suvAT$n.event / (suvAT$n.risk * (suvAT$n.risk - suvAT$n.event)))), suvAT$cumhaz, suvAT$std.chaz)
colnames(hazardAT) = c('time', 'n.risk', 'n.event', 'KM estimate', 's.e. of KM estimate', 'NA estimate', 's.e. of NA estimate')
hazardAT[hazardAT[, 'n.event'] != 0, ]

print(suvAT, print.rmean = T)
c(144.2 - 1.96 * 27.3, 144.2 + 1.96 * 27.3)

medianAT = cbind(summary(suvAT)$time, (summary(suvAT)$surv - 0.5) / summary(suvAT)$std.err)
colnames(medianAT) = c('time', 'linear')
medianAT

## Question 5
setwd('/Users/jackchan/Downloads')
data = read.csv('ass2q5.csv')
data$Censor = ifelse(data$Censor == 0, 1, 0)
suvQ5 = survfit(Surv(data$Time, data$Censor) ~ 1)
summary(suvQ5)

suv5 = summary(suvQ5)
suv5 = data.frame(suv5$time, suv5$n.risk, suv5$n.event, suv5$surv, suv5$std.err)
colnames(suv5) = c('time', 'n.risk', 'n.event', 'survival', 'std.err')
suv5[suv5$time == 5,]

print(suvQ5, print.rmean = T)
medianQ5 = cbind(summary(suvQ5)$time, (summary(suvQ5)$surv - 0.5) / summary(suvQ5)$std.err)
colnames(medianQ5) = c('time', 'linear')
medianQ5

## Question 6
timeS = c(1, 6, 5, 3, 7, 2, 3, 4, 5)
timeE = c(1, 6, 5, 3, 9, 2, 4, 4, 5)
type = c(1, 0, 2, 1, 3, 2, 3, 1, 0)
suvQ6 = survfit(Surv(timeS, timeE, type, type = 'interval') ~ 1)
summary(suvQ6)

## Question 7
entry = c(58, 58, 59, 60, 60, 61, 61, 62 ,62, 62, 63, 63, 64, 66, 66, 67, 67, 67, 68, 69, 69, 69, 70, 70, 70, 71, 72, 72, 73, 73)
exit = c(60, 63, 69, 62, 65, 72, 69, 73, 66, 65, 68, 74, 71, 68, 69, 70, 77, 69, 72, 79, 72, 70, 76, 71, 78, 79, 76, 73, 80, 74)
cens = c(1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1)
data = data.frame(entry, exit, cens)

suvQ7 = survfit(Surv(exit, cens) ~ 1, data[exit >= 60, ])
ti = suvQ7$time[suvQ7$n.event != 0]
ni = rep(0, length(ti))
for(i in 1:length(ti))
  ni[i] = sum(entry <= ti[i] & ti[i]<= exit)
di = suvQ7$n.event[suvQ7$n.event != 0]
surv_fun_b = cumprod(1 - di / ni)

suvQ7 = survfit(Surv(exit, cens) ~ 1, data[exit >= 65, ])
ti_c = suvQ7$time[suvQ7$n.event != 0]
ni_c = rep(0, length(ti_c))
for(i in 1:length(ti_c))
  ni_c[i] = sum(entry <= ti_c[i] & ti_c[i]<= exit)
di_c = suvQ7$n.event[suvQ7$n.event != 0]
surv_fun_c = cumprod(1 - di_c / ni_c)

Q7 = data.frame(ti, ni, round(surv_fun_b, 4), round(c(rep(1, length(ti) - length(ti_c)), surv_fun_c), 4))
colnames(Q7) = c('Time', '  Y', 'S(t|60)', 'S(t|65)')
Q7

## Question 8
ti = c(2, 4, 7, 14, 20, 18, 8, 13, 17, 26, 20, 15, 23, 5, 16, 15, 11, 9, 33, 4, 8, 35, 10, 36, 25)
xi = c(30, 27, 25, 19, 18, 17, 16, 16, 15, 15, 15, 13, 13, 12, 11, 9, 8, 8, 8, 7, 6, 6, 6, 4, 4)
tau = 42
ri = tau - xi
suvQ8 = survfit(Surv(ri) ~ 1)
temp1 = outer(ti, suvQ8$time, '<=')
temp2 = outer(ri, suvQ8$time, '>=')
temp3 = temp1 & temp2
ni = apply(temp3, 2, sum)
surv = cumprod(1 - suvQ8$n.event / ni)

di = rep(0, length(ri))
temp4 = outer(ri,ri,'==')
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
Q8 = data.frame(ti, xi, ri, di, ni, surv_fun)
colnames(Q8) = c('  T_i', '  X_i', '  R_i', '  d_i', '  n_i', 'Pr(X < x_i|X <= 42)')
Q8