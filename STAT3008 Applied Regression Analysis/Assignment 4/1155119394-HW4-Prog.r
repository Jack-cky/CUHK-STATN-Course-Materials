# Question 2
library(car)
library(alr3)
x <- baeskel$Sulfur
y <- baeskel$Tension

# (a)
plot(x, y)

# (b)
reg <- lm(y ~ x)
summary <- summary(reg)
summary$coefficients
summary$r.squared

# (c)
par(mfrow = c(2, 2))
plot(reg)

# (d)
influence.measures(reg)

# Question 3
library(alr3)
x <- stopping$Speed
y <- stopping$Distance
plot(x,y)

# (a)
xsq <- x ^ 2
reg <- lm(y ~ x + xsq)
summary <- summary(reg)
summary$coefficients
sum(summary$residuals ^ 2)

# (b)
library(MASS)
nullModel <- lm(y ~ 1)
fullModel <- reg
n <- length(y)
stepAIC(nullModel, scope = list(lower = nullModel, upper = fullModel), direction = "forward", trace = 1)

reg2 <- lm(y ~ xsq)
summary2 <- summary(reg2)
summary2$coefficients
sum(summary2$residuals ^ 2)

# (c)
par(mfrow = c(2, 2))
plot(reg2)

# (d)
x_lambda1 <- x
x_lambda2 <- x
x_lambda2.5 <- x

for(i in 1:n) {
  if(x[i] == 0)
    log(x)
  else {
    x_lambda1[i] = (x_lambda1[i] ^ 1 - 1) / 1
    x_lambda2[i] = (x_lambda2[i] ^ 2 - 1) / 2
    x_lambda2.5[i] = (x_lambda2.5[i] ^ 2.5 - 1) / 2.5
  }
}

reg3 <- lm(y ~ x_lambda1)
reg4 <- lm(y ~ x_lambda2)
reg5 <- lm(y ~ x_lambda2.5)

plot(x, y)
lines(x, reg3$fitted.values, lty=2)
lines(x, reg4$fitted.values, lty=3)
lines(x, reg5$fitted.values, lty=4)

# (e)
sum(reg3$residuals^2)
sum(reg4$residuals^2)
sum(reg5$residuals^2)

# (f)
y_lambda0.2 <- y ^ 0.2
x_lambda0.2 <- x ^ 0.2
reg6 <- lm(y_lambda0.2 ~ x_lambda0.2)
plot(x_lambda0.2, y_lambda0.2)
abline(reg6)
sum(reg6$residuals^2)

y_lambda0.4 <- y ^ 0.4
x_lambda0.4 <- x ^ 0.4
reg7 <- lm(y_lambda0.4 ~ x_lambda0.4)
plot(x_lambda0.4, y_lambda0.4)
abline(reg7)
sum(reg7$residuals^2)

y_lambda0.67 <- y ^ 0.67
x_lambda0.67 <- x ^ 0.67
reg8 <- lm(y_lambda0.67 ~ x_lambda0.67)
plot(x_lambda0.67, y_lambda0.67)
abline(reg8)
sum(reg8$residuals^2)

y_lambda1 <- y ^ 1
x_lambda1 <- x ^ 1
reg9 <- lm(y_lambda1 ~ x_lambda1)
plot(x_lambda1, y_lambda1)
abline(reg9)
sum(reg9$residuals^2)