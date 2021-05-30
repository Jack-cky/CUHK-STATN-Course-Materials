# least squares estimate (Chapter 01 Page 22)
Y = c(1.2, 2.1, 2.9, 3.8)
X = matrix(c(rep(1, length(Y)), seq(1, length(Y))), nr = length(Y), byr = F)
solve(t(X) %*% X) %*% t(X) %*% Y