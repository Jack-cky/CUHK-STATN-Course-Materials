Y = c(1.33, -0.56, -1.31, -0.37, 0.05, 0.46, 2.00, -0.19, -0.25, 1.07, -0.17, 1.14, 0.63, -0.75, 0.15, 0.71, 0.45, -0.14, 0.57, 1.43)

## Question 1
par(mfrow = c(1, 3))
ts.plot(Y)
acf(Y)
pacf(Y)

## Question 2
gamma0 = mean((Y - mean(Y))^2)
gamma1 = sum((Y[2:length(Y)] - mean(Y)) * (Y[1:(length(Y) - 1)] - mean(Y))) / length(Y)

## Question 3
Y0 = Y[3:length(Y)]
Y1 = Y[2:(length(Y) - 1)]
Y2 = Y[1:(length(Y) - 2)]
X = as.matrix(cbind(Y1, Y2))
sol = summary(lm(Y0 ~ -1 + X))

## Question 4
gamma2 = sum((Y[3:length(Y)] - mean(Y)) * (Y[1:(length(Y) - 2)] - mean(Y))) / length(Y)
sol = solve(matrix(c(gamma0, gamma1, gamma1, gamma0), nr = 2, byr = T)) %*% c(gamma1, gamma2)

## Question 5
funQ5 = function(para) {
	phi = para[1]
	theta = para[2]
	z = rep(0, length(Y))
	z[1] = Y[1]
	for(i in 2:length(Y)) { 
		z[i] = Y[i] - phi * Y[i - 1] - theta * z[i - 1]
	}
	return(sum(z ^ 2))
}
sol = optim(c(0.1,0.1), funQ5)
sol = funQ5(sol$par) / 19

## Question 6
sol = arima(Y, order = c(1, 0, 1), include.mean = F)

## Question 7
IC = function(y, order.input) {
	fit = arima(y, order = order.input, include.mean = F)
	n = length(y)
	p = order.input[1]
	sig = fit$sigma2
	FPE = sig * (n + p) / (n - p)
    return(FPE)
}
sol = c()
for(i in 1:5) {
    sol = c(sol, round(IC(Y, order = c(i, 0, 0)), 4))
}

## Question 8
IC = function(y, order.input) {
	fit = arima(y, order = order.input, include.mean = F)
	n = length(y)
	q = order.input[3]
	sig = fit$sigma2
	AIC = fit$aic - 2 * (q + 1) + 2 * (q + 1) * n / (n - q - 2)
  return(AIC)
}
sol = c()
for(i in 1:5) {
    sol = c(sol, round(IC(Y, order = c(0, 0, i)), 4))
}

## Question 9
fit = arima(Y, order = c(0, 0, 1), include.mean = F)
res = round(fit$res, 4)
n = length(Y)
r.z = as.numeric(acf(fit$res, 10)$acf)
Q = n * (n + 2) * sum((r.z[-1] ^ 2) / (n - (1:10)))
cv = qchisq(0.95, 10 - 1)

## Question 10
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
	return(out)
}
size = 5
sol = data.frame()
for(i in 0:size) {
    for(j in 0:size) {
        sol = rbind(sol, cbind(i, j, round(IC(Y, c(i, 0, j)), 4)))
    }
}
FPE = sol[which(sol$FPE == min(sol$FPE, na.rm = T)), ]
AIC = sol[which(sol$AIC == min(sol$AIC, na.rm = T)), ]
AICC = sol[which(sol$AICC == min(sol$AICC, na.rm = T)), ]
BIC = sol[which(sol$BIC == min(sol$BIC, na.rm = T)), ]