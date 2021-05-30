library(survival)

## Question 1
time = c(18, 9, 28, 31, 39, 19, 45, 6, 8, 15, 23, 28, 7, 12, 9, 8, 2, 26, 10, 4, 3, 4, 18, 8, 3, 14, 3, 13, 13, 35)
censor = c(1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)
group = c(1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 1, 3, 2, 2, 2, 4, 2, 4, 2, 2, 2, 4, 4, 4, 4, 2, 4, 4, 2)

coxModel = coxph(Surv(time, censor) ~ factor(group), ties = 'exact')
summary(coxModel)

survdiff(Surv(time, censor) ~ group)


## Question 2
data = read.csv('ass4.csv')
set.seed(123457)
data = data[sample(nrow(data), 1000), ]
data$cens = 1 - data$cens
data$hlstat3 = ifelse(data$hlstat == 3, 1, 0)
data$hlstat4 = ifelse(data$hlstat == 4, 1, 0)
data$hlstat5 = ifelse(data$hlstat == 5, 1, 0)

# (a)
coxModel = coxph(Surv(lstay, cens) ~ age + trt + gender + marstat + hlstat3 + hlstat4 + hlstat5, data = data)
summary(coxModel)

# (b)
sub = !coxModel$coefficients / sqrt(diag(coxModel$var)) >= qnorm(0.975)
subPar = coxModel$coefficient[sub]
subVar = coxModel$var[sub, sub]
WT = t(subPar) %*% solve(subVar) %*% subPar
pv_WT = 1 - pchisq(WT, length(subPar))

coxModelSub = coxph(Surv(lstay, cens) ~ gender + hlstat4 + hlstat5, data = data)
LRT = 2 * (coxModel$loglik[2] - coxModelSub$loglik[2])
pv_LRT = 1 - pchisq(LRT, length(coxModel$coefficients) - length(coxModelSub$coefficients))

initial = rep(0, length(coxModel$coefficients))
initial[!sub] = coxModelSub$coefficients
coxModelSco = coxph(Surv(lstay, cens) ~ age + trt + gender + marstat + hlstat3 + hlstat4 + hlstat5, data = data, init = initial)
ST = coxModelSco$score
pv_ST = 1 - pchisq(coxModelSco$score, length(coxModel$coefficients) - length(coxModelSub$coefficients))

data.frame(testValue = c(WT, LRT, ST), pv = c(pv_WT, pv_LRT, pv_ST), row.names = c('Wald', 'Likelihood', 'Score'))

# (c)
n = 2
m = 3
me = qnorm(0.975) * sqrt(coxModelSub$var[n, n] + coxModelSub$var[m, m] - 2 * coxModelSub$var[n, m])
c(exp(coxModelSub$coefficients[n] - coxModelSub$coefficients[m] - me), exp(coxModelSub$coefficients[n] - coxModelSub$coefficients[m] + me))