setwd('/Users/jackchan/Downloads')

data = read.csv('monthly_milk.csv')
data = data[1:168, 2]
data = ts(data, frequency = 4)

n = length(data)
T1 = rep(NA,n)
filter = c(0.125, 0.25, 0.25, 0.25, 0.125)
radius = 2
start = 3
end = n - 2
for(k in start:end)
  T1[k] = filter %*% x[(k - radius):(k + radius)]
T1

d = 4
D = data - T1
D.bar = mean(D, na.rm = T)
S.mat = matrix(D - D.bar, ncol = d, byrow = T)
S = apply(S.mat, 2, mean, na.rm = T)
(S = rep(S, n / d))

(N = data - T1 - S)