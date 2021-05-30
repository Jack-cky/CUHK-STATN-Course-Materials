###------------------------------------------------------------------------------------------------------------
###------------------------------------------------------------------------------------------------------------
#I would like to thank you one student for providing the solution for STAT4008 assignment 2.
###------------------------------------------------------------------------------------------------------------

################################################ Q3
library('survival')
library('KMsurv')

time = c(2,4,4,4,5,6,7,7,8)
status = c(1,1,1,0,1,0,1,0,0)
fit = survfit(Surv(time, event = status) ~ 1)
print(fit,print.rmean = TRUE) # mean and sd

################################################ Q4
death1 = c(1, 3, 3, 4, 10, 13, 13, 16, 16, 24, 26, 27, 28, 30, 30, 32, 41, 51, 65, 67, 70, 72, 73, 77, 91, 93, 96, 100, 104, 157, 167 )
cens1 = c(61, 74, 79, 80, 81, 87, 87, 88, 89, 97, 101, 104, 108, 109, 120, 131, 150, 231, 240, 400 )
Aneuploid_time = c(death1, cens1)
Aneuploid_status = c(rep(1, length(death1)), rep(0, length(cens1)))

death2 = c(1, 3, 4, 5, 5, 8, 23, 26, 27, 30, 42, 56, 62, 69, 104, 104, 112, 129, 181 )
cens2 = c(8, 67, 76, 104, 176, 231)
Diploid_time = c(death2, cens2)
Diploid_status = c(rep(1, length(death2)), rep(0, length(cens2)))

library('survival')
library('KMsurv')

Aneuploid_data = Surv(Aneuploid_time, event = Aneuploid_status)
Diploid_data = Surv(Diploid_time, event = Diploid_status)

Aneuploid_fit = survfit(Aneuploid_data ~ 1)
Diploid_fit = survfit(Diploid_data ~ 1)

#--------------------------------- 4a: survival functions and their se for both groups

Diploid_obsfail = Diploid_fit$time[Diploid_fit$n.event!=0]
Diploid_surfun_est = Diploid_fit$surv[Diploid_fit$n.event!=0]
Diploid_surfun_se = Diploid_surfun_est*Diploid_fit$std.err[Diploid_fit$n.event!=0]

Aneuploid_obsfail = Aneuploid_fit$time[Aneuploid_fit$n.event!=0]
Aneuploid_surfun_est = Aneuploid_fit$surv[Aneuploid_fit$n.event!=0]
Aneuploid_surfun_se = Aneuploid_surfun_est*Aneuploid_fit$std.err[Aneuploid_fit$n.event!=0]

# Diploid group
cbind(tj = Diploid_obsfail, Est_survial = Diploid_surfun_est, est_SD = Diploid_surfun_se)
# Aneuploid group
cbind(tj = Aneuploid_obsfail, Est_survial = Aneuploid_surfun_est, est_SD = Aneuploid_surfun_se)


#----------------------------- 4b: cumulative hazard rates and their se for both groups

Diploid_cumHaz_est = Diploid_fit$cumhaz[Diploid_fit$n.event!=0]
Diploid_cumHaz_se = Diploid_fit$std.err[Diploid_fit$n.event!=0]

Aneuploid_cumHaz_est = Aneuploid_fit$cumhaz[Aneuploid_fit$n.event!=0]
Aneuploid_cumHaz_se = Aneuploid_fit$std.err[Aneuploid_fit$n.event!=0]

# Diploid group
cbind(tj = Diploid_obsfail, Est_cumHaz = Diploid_cumHaz_est, est_SD = Diploid_cumHaz_se)
# Aneuploid group
cbind(tj = Aneuploid_obsfail, Est_cumHaz = Aneuploid_cumHaz_est, est_SD = Aneuploid_cumHaz_se)


#----------------------------- 4c: estimate mean and its 95% CI for both groups
print(Diploid_fit,print.rmean = TRUE)
print(Aneuploid_fit,print.rmean = TRUE)


#----------------------------- 4d: estimate median and its 95% CI for both groups
Diploid_median = min(Diploid_obsfail[Diploid_surfun_est <= 0.5])
Diploid_mid <- (Diploid_surfun_est-0.5)/Diploid_surfun_se
Diploid_median_lower = min(Diploid_obsfail[Diploid_mid <= qnorm(0.975) & Diploid_mid >= qnorm(0.025)])
Diploid_median_upper = max(Diploid_obsfail[Diploid_mid <= qnorm(0.975) & Diploid_mid >= qnorm(0.025)])

Aneuploid_median = min(Aneuploid_obsfail[Aneuploid_surfun_est <= 0.5])  
Aneuploid_mid <- (Aneuploid_surfun_est-0.5)/Aneuploid_surfun_se
Aneuploid_median_lower = min(Aneuploid_obsfail[Aneuploid_mid <= qnorm(0.975) & Aneuploid_mid >= qnorm(0.025)])
Aneuploid_median_upper = max(Aneuploid_obsfail[Aneuploid_mid <= qnorm(0.975) & Aneuploid_mid >= qnorm(0.025)])

# Diploid group
c(est_median = Diploid_median, lower = Diploid_median_lower, upper = Diploid_median_upper)
# Aneuploid group
c(est_median = Aneuploid_median, lower = Aneuploid_median_lower, upper = Aneuploid_median_upper)

################################################ Q5
setwd("C:/Users/User/OneDrive - The Chinese University of Hong Kong/Year3sem2/STAT4008 - Survival Modeling")
getwd()

data = read.csv("ass2q5.csv")

library('survival')
library('KMsurv')

time = data$Time
status = 1 - data$Censor  # 1 = obs fail, 0 = censored

survival_data = Surv(time, event = status)
fit = survfit(survival_data ~ 1)

#--------------------------------- 5a: survival functions and their se
obsfail0 = fit$time[fit$n.event!=0]
obsfail = obsfail0[-length(obsfail0)]  # since last one is obs fail

surfun_est0 = fit$surv[fit$n.event!=0]
surfun_est = surfun_est0[-length(surfun_est0)] 

surfun_se0 = fit$std.err[fit$n.event!=0]
surfun_se = surfun_se0[-length(surfun_se0)] 
surfun_se = surfun_se * surfun_est
surfun_se0 = c(surfun_se, NA)

# result
cbind(tj = obsfail0, Est_survial = surfun_est0, est_SD = surfun_se0)

#----------------------------- 5b: survival functions and their se at t = 5
cbind(tj = obsfail, Est_survial = surfun_est, est_SD = surfun_se)[which(obsfail == 5.0),]


#----------------------------- 5c: estimate median and its 95% CI for both groups
median = min(obsfail[surfun_est <= 0.5])
mid <- (surfun_est-0.5)/surfun_se
median_lower = min(obsfail[mid <= qnorm(0.975) & mid >= qnorm(0.025)])
median_upper = max(obsfail[mid <= qnorm(0.975) & mid >= qnorm(0.025)])

# result
c(est_median = median, lower = median_lower, upper = median_upper)



################################################ Q6
library('survival')
library('KMsurv')

time = c(1, 6, 5, 3, 7, 2, 3, 4, 5)
time2 = c(1, 6, 5, 3, 9, 2, 4, 4, 5)
status = c(1, 0, 2, 1, 3, 2, 3, 1, 0)

survival_data = Surv(time, time2, event = status, type = 'interval')
survival_data
fit = survfit(survival_data ~ 1)
summary(fit)



################################################ Q7
#-------------------------------- 7a: make a table of n.risk Y to age
library('survival')
library('KMsurv')

entry = c(58, 58, 59, 60, 60, 61, 61, 62, 62, 62, 63, 63, 64, 66, 66, 67, 67, 67, 68, 69, 69, 69, 70, 70, 70, 71, 72, 72, 73, 73)
exit = c(60, 63, 69, 62, 65, 72, 69, 73, 66, 65, 68, 74, 71, 68, 69, 70, 77, 69, 72, 79, 72, 70, 76, 71, 78, 79, 76, 73, 80, 74)
status = c(1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1)

model = survfit( Surv(exit, event = status)~1)
obsfail = model$time[model$n.event!=0]

Y = rep(0,length(obsfail))
for ( i in 1:length(Y)) 
  Y[i]<-sum(entry <= obsfail[i] & obsfail[i]<= exit)

# result for 7a
cbind(tj = obsfail, n.risk = Y)

#-------------------------------- 7b: estimate condition survival given age 60
index60 = which(entry >= 60)
entry60 = entry[index60]
exit60 = exit[index60]
status60 = status[index60]
model60 = survfit( Surv(exit60, event = status60)~1)
obsfail60 = model60$time[model60$n.event!=0]
Y60 = rep(0,length(obsfail60))
for ( i in 1:length(Y60)) 
  Y60[i]<-sum(entry60 <= obsfail60[i] & obsfail60[i]<= exit60)
dj60 = model60$n.event[model60$n.event!=0]
surfun_est60 = cumprod(1-dj60/Y60)
cbind(obsfail60, surfun_est60)

#-------------------------------- 7c: estimate condition survival given age 65
index65 = which(entry >= 65)
entry65 = entry[index65]
exit65 = exit[index65]
status65 = status[index65]
model65 = survfit( Surv(exit65, event = status65)~1)
obsfail65 = model65$time[model65$n.event!=0]
Y65 = rep(0,length(obsfail65))
for ( i in 1:length(Y65)) 
  Y65[i]<-sum(entry65 <= obsfail65[i] & obsfail65[i]<= exit65)
dj65 = model65$n.event[model65$n.event!=0]
surfun_est65 = cumprod(1-dj65/Y65)
cbind(obsfail65, surfun_est65)

################################################ Q8
library('survival')
library('KMsurv')

infection = c(2,4,7,14,20,18,8,13,17,26,20,15,23,5,16,15,11,9,33,4,8,35,10,36,25)
induction = c(30,27,25,19,18,17,16,16,15,15,15,13,13,12,11,9,8,8,8,7,6,6,6,4,4)
Ri = 42 - induction

model = survfit(Surv(Ri)~1)
ni1 = outer(infection, model$time, '<=')
ni2 = outer(Ri, model$time, '>=')
ni = apply(ni1&ni2, 2, sum)

surfun_est = cumprod(1-model$n.event/ni)
xi = 42 - model$time

#result
cbind(xi, 'P(X<xi|X<42)' = surfun_est)

