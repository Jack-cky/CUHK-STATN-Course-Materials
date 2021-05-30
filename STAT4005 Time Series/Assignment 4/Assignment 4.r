## Question 1
Y = c(1.33, -0.56, -1.31, -0.37, 0.05, 0.46, 2.00, -0.19, -0.25, 1.07, -0.17, 1.14, 0.63, -0.75, 0.15, 0.71, 0.45, -0.14, 0.57, 1.43)

# (a)
a = arima(Y, order = c(0, 0, 2), include.mean = F)
n = rep(0, length(Y))
for(i in 1:length(Y)) {
  if(i == 1)
    n[i] = Y[i]
  else if(i == 2)
    n[i] = Y[i] - a$coef[1] * n[i - 1]
  else
    n[i] = Y[i] - a$coef[1] * n[i - 1] - a$coef[2] * n[i - 2]
}

# (c)
c = arima(Y, order = c(1, 0, 0), include.mean = F)

# (e)
e = arima(Y, order = c(1, 0, 1), include.mean = F)
n = rep(0, length(Y))
for(i in 2:length(Y)) {
  n[i] = Y[i] - e$coef[1] * Y[i - 1] - e$coef[2] * n[i - 1]
}

# (f)
f = arima(Y, order = c(1, 1, 0), include.mean = F)