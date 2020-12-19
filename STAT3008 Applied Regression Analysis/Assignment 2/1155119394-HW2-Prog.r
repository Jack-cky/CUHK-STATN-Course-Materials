# basic variables for model building
Y <- c(21, 25, 21, 24, 9, 36, 36, 24, 10)
Intercept <- rep(1, length(Y))
X1 <- c(3, 9, 5, 3, -1, 7, 8, 4, 1)
X2 <- c(3, 9, 5, 3, 0, 7, 9, 4, 1)
X <- cbind(Intercept ,X1, X2)
p <- dim(X)[[2]] - 1
n <- length(X1)

# (a) (a)
# \beta\hat
(b <- solve(t(X) %*% X) %*% t(X) %*% Y)

# (a) (b)
# Y\hat
(Y_hat <- X %*% b)

# e\hat
(e_hat <- Y - Y_hat)

# SYY
(SYY <- sum((Y - mean(Y)) ^ 2))

# RSS
(RSS <- (t(Y) %*% Y - t(Y) %*% X %*% b))

#SSreg
(SSreg <- SYY - RSS)

# \sigma\hat^2
(MSE <- RSS / (n - p - 1))

# Var\hat(\beta\hat)
as.numeric(MSE) * solve(t(X) %*% X)

# R^2
(SSreg / SYY)

# (b)
x_pred <- c(1, -1, 1)

(y_pred <- x_pred %*% b)

# Margin of error
ME <- qt(0.975, n - p - 1) * sqrt(MSE * (1 + t(x_pred) %*% solve(t(X) %*% X) %*% x_pred))

# PI
c(y_pred - as.numeric(ME), y_pred + as.numeric(ME))

# (c)
# statistic already available in the above and the question from model 2

1-pf(0.0048,1,6)