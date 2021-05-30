# Question 2
library(car)
library(alr3)
S <- salary$Sex
R <- salary$Rank
X <- salary$Year
Y <- salary$Salary

reg <- lm(Y ~ factor(S) + X + factor(R) + factor(S):factor(R))

summary <- summary(reg)

# (a)
summary$coefficients
summary$sigma^2

# (b)
y_hat <- 15952.1026+244.5008+409.8953

# (c)
sum(reg$residuals^2)

# (d)
reg2 <- lm(Y ~ factor(S) + X)
anova(reg2, reg)

# (h)
reg3 <- lm(Y ~ + X + factor(R))
anova(reg3, reg)


# Question 4

library(alr3)
library(MASS)
y<-BGSgirls$HT18
x1<-BGSgirls$WT2
x2<-BGSgirls$HT2
x3<-BGSgirls$WT9
x4<-BGSgirls$HT9
x5<-BGSgirls$LG9
x6<-BGSgirls$ST9

nullModel <- lm(y ~ 1)
fullModel <- lm(y ~ x1 + x2 + x3 + x4 + x5 + x6)
n <- length(y)

# (a)
stepAIC(nullModel, scope = list(lower = nullModel, upper = fullModel), direction = "forward", trace = 1)
stepAIC(fullModel, scope = list(lower = nullModel, upper = fullModel), direction = "backward", trace = 1)

# (b)
stepAIC(nullModel, scope = list(lower = nullModel, upper = fullModel), direction = "forward", trace = 1, k = log(n))
stepAIC(fullModel, scope = list(lower = nullModel, upper = fullModel), direction = "backward", trace = 1, k = log(n))

# (c)
reg <- lm(x5 ~ x1 + x2 + x3 + x4 + x6)
summary <- summary(reg)
(VIF <- 1 / (1 - summary$r.squared))