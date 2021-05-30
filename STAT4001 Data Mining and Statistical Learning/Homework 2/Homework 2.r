## Question 5
# Part a
set.seed(4001)
x = rnorm(100, 0, 1)
e = rnorm(100, 0, 0.1)

# Part b
y = 1 + x + x ^ 2 + x ^ 3 + e

# Part c
library(glmnet)

X = data.frame(x)
names(X) = "X"
for(i in 2:10) {
  X = cbind(X, x ^ i)
  names(X)[i] = paste0("X ^ ", i)
}
X = as.matrix(X)

cv = cv.glmnet(X, y, alpha = 1)
plot(cv)
cv$lambda.min

lasso = glmnet(X, y, alpha = 1)
predict(lasso, type = "coefficient", s = cv$lambda.min)

# Part d
y = 1 + x ^ 7 + e

cv = cv.glmnet(X, y, alpha = 1)
plot(cv)
cv$lambda.min

lasso = glmnet(X, y, alpha = 1)
predict(lasso, type = "coefficient", s = cv$lambda.min)