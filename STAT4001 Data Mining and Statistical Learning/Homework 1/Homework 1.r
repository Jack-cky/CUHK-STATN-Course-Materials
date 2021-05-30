## Question 2
library(boot)
x = c(0.4, 0.8, 1.2)
y = c(1.2, 1.8, 3.2)
data = data.frame(x, y)
reg = glm(y ~ x)
loocv = cv.glm(data, reg)
loocv$delta[1]


## Question 3
set.seed(4001)
x = c(4.3, 2.1, 5.3)
y = c(2.4, 1.1, 2.8)
data = data.frame(x, y)
B = nrow(data)
bt = list(data, data, data)
alpha = rep(0, B)

alphaValue = function(data) {
  X = bt[[i]]$x
  Y = bt[[i]]$y
  alpha = (var(Y) - cov(X, Y)) / (var(X) + var(Y) - 2 * cov(X, Y))
  return(alpha)
}

for(i in 1:B) {
  # AS QUESTION REQUIRED: remove possible of getting same index
  repeat{
    index = sample(B, replace = T)
    if(length(unique(index)) != 1)
      break
  }
  bt[[i]] = data[index, ]
  alpha[i] = alphaValue(bt[[i]])
  rm(index)
}

alphaSE = sd(alpha)
alphaSE


## Question 4
# Part b
likelihood = function(x, y, beta0, beta1) {
  prod(exp((beta0 + beta1 * x) * y) / (1 + exp(beta0 + beta1 * x)))
}

logLikeli = function(x, y, beta0, beta1) {
  sum((beta0 + beta1 * x) * y - log(1 + exp(beta0 + beta1 * x)))
}

logLikeli_prime = function(x, y, beta0, beta1) {
  sum(x * (y - 1 / (1 + exp(-(beta0 + beta1 * x)))))
}

logLikeli_pprime = function(x, y, beta0, beta1) {
  -sum(x ^ 2 * 1 / (1 + exp(beta0 + beta1 * x)) * 1 / (1 + exp(-(beta0 + beta1 * x))))
}

logReg = function(x, y, beta0, beta1 = runif(1), f) {
  repeat {
    beta1_new = beta1 - logLikeli_prime(x, y, beta0, beta1) / logLikeli_pprime(x, y, beta0, beta1)
    if(abs(likelihood(x, y, beta0, beta1_new) - likelihood(x, y, beta0, beta1)) <= f) {
      beta1 = beta1_new
      break
    }
    beta1 = beta1_new
  }
  return(c(beta1, logLikeli(x, y, beta0, beta1)))
}

# Part c
set.seed(4001)
logReg(data1$x, data1$y, beta0 = -0.66, f = 1e-14)

# Part d
set.seed(4001)
logReg(data2$x2, data2$y2, beta0 = 0, f = 1e-4)

# Part e
set.seed(4001)
logReg(data2$x2 + 0.5, data2$y2, beta0 = 0, f = 1e-8)


## Quesiton 5
knn = function(x, y, new, K) {
  distance = rep(0, length(y))
  for(i in 1:length(y)) {
    distance[i] = sqrt(sum((new - x[i, ]) ^ 2))
  }
  rank = rank(distance)
  data = data.frame(rank, y)
  data = data[order(rank),][1:K,]
  if(mean(data[, 2]) > 0.5)
    return(1)
  else
    return(0)
}

knn(data4$x, data4$y, data4$x_new, K = 8)


## Question 6
library(ISLR)
library(boot)
library(MASS)
library(class)

train = (Weekly$Year < 2009)
Direction = Weekly$Direction[!train]
test = Weekly[!train, ]

# all possible models
modelBoolean = expand.grid(c(TRUE,FALSE), c(TRUE,FALSE), c(TRUE,FALSE), c(TRUE,FALSE), c(TRUE,FALSE), c(TRUE,FALSE))
names(modelBoolean) = c(paste("Log", 1:5, sep = ""), "Volume")
terms = names(Weekly)[2:7]
model = apply(modelBoolean, 1, function(x) as.formula(paste(c("Direction ~ 1", terms[x]), collapse = " + ")) )

# select model
cv = rep(1, 2 ^ length(terms))
for(i in 1:(2 ^ length(terms))) {
  set.seed(4001)
  logReg = glm(model[[i]], data = Weekly, family = binomial)
  cv[i] = cv.glm(Weekly, logReg, K = 10)$delta[1]
  if(cv[i] == min(cv))
    flag = i
}
model_terms = strsplit(as.character(model[[flag]])[3], " ")
model_terms = model_terms[[1]][model_terms[[1]] != "1" & model_terms[[1]] != "+"]
model_terms

# Part a
logReg = glm(model[[flag]], data = Weekly, family = binomial, subset = train)
logReg_prob = predict(logReg, test, type = "response")
logReg_pred = rep("Down", length(logReg_prob))
logReg_pred[logReg_prob > 0.5] = "Up"

logReg
mean(logReg_pred == Direction)

# Part b
lda = lda(model[[flag]], data = Weekly, subset = train)
lda_prod = predict(lda, test)

lda
mean(lda_prod$class == Direction)

# Part c
qda = qda(model[[flag]], data = Weekly, subset = train)
qda_prod = predict(qda, test)

qda
mean(qda_prod$class == Direction)

# Part d
accuracy = rep(0, 20)
for(i in 1:10) {
  set.seed(4001)
  knn = knn(as.matrix(Weekly[, model_terms][train]), as.matrix(Weekly[, model_terms][!train]), Weekly$Direction[train], k = i)
  accuracy[i] = mean(knn==Direction)
  if(accuracy[i] == max(accuracy))
    flag = i
}
accuracy[flag]

accuracy = rep(0, 20)
X = scale(Weekly[, model_terms])
for(i in 1:10) {
  set.seed(4001)
  knn = knn(as.matrix(X[train]), as.matrix(X[!train]), Weekly$Direction[train], k = i)
  accuracy[i] = mean(knn==Direction)
  if(accuracy[i] == max(accuracy))
    flag = i
}
accuracy[flag]