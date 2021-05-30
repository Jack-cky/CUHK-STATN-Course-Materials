library(survival)

## Question 1
d = sum(c(1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1))
H = 0.2 * sum(c(12, 15, 17, 17, 18, 19, 20, 20, 20, 21, 24, 27))
(ts = (d - H) ^ 2 / H)
(cv = round(qchisq(0.95, 1), 4))


## Question 2
time1 = c(2, 2, 3, 3, 4, 4, 5, 5, 6)
time2 = c(2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 7)
cen1 = c(1, 1, 0, 1, 1, 0, 1, 1, 0)
cen2 = c(1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1)
data = data.frame(time = c(time1, time2), censor = c(cen1, cen2), group = c(rep(1, length(time1)), rep(2, length(time2))))

survGroup = survdiff(Surv(data$time, data$censor) ~ data$group)
(ts = round(survGroup$chisq, 4))
(cv = round(qchisq(0.95, 1), 4))


## Question 3
time = c(18, 9, 28, 31, 39, 19, 45, 6, 8, 15, 23, 28, 7, 12, 9, 8, 2, 26, 10, 4, 3, 4, 18, 8, 3, 14, 3, 13, 13, 35)
censor = c(1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)
group = c(1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 1, 3, 2, 2, 2, 4, 2, 4, 2, 2, 2, 4, 4, 4, 4, 2, 4, 4, 2)
data = data.frame(time, censor, group)

survGroup = survdiff(Surv(data$time, data$censor) ~ data$group)
(ts = round(survGroup$chisq, 4))
(cv = round(qchisq(0.95, 3), 4))


## Question 4
library("readxl")
data = as.data.frame(read_excel('ass3data.xls'))

survGroup = survdiff(Surv(data$Time) ~ data$Group)
(ts = round(survGroup$chisq, 4))
(cv = round(qchisq(0.95, length(unique(data$Group)) - 1), 4))

survTreat = survdiff(Surv(data$Time) ~ data$Treatment)
(ts = round(survTreat$chisq, 4))
(cv = round(qchisq(0.95, length(unique(data$Treatment)) - 1), 4))


## Question 5
data = read.csv('ass3q5.csv')
set.seed(123457)
data = data[sample(nrow(data), 100), ]

survStatus = survdiff(Surv(data$Time, data$Status) ~ data$Smoking.Status)
(ts = round(survStatus$chisq, 4))
(cv = round(qchisq(0.95, length(unique(data$Smoking.Status)) - 1), 4))