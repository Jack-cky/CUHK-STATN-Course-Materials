# import library 'alr3'
library(alr3)

# create 'x' and 'y' in storing log data of 'BodyWt' and 'BrainWt' respectively
y <- log(brains$BrainWt)
x <- log(brains$BodyWt)

# create 'reg' as the linear regression
reg <- lm(y~x)

# create 'summary' as the summary table of the regression
summary <- summary(reg)

# (a)
# output the beta_0_hat, beta_1_hat, and sigma^2_hat
c(reg$coef, summary$sigma^2)

# (b)
# plot the scatterplot along with the regression line
plot(x, y)
abline(reg)

# (c)
# check if all residuals are small than 2 standard error of regression
all(abs(reg$residuals) < 2 * summary$sigma)