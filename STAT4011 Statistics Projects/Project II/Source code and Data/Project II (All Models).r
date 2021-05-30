setwd("/Users/jackchan/Documents/I go to school by bus/03 The Chinese University of Hong Kong/Year 3/Semester 1/STAT4011 Statistics Projects/Project II")

house <- read.csv("House.csv", header = TRUE)

## Summary of the Dataset
# names(house)
# head(house)
# pairs(house)
# temp = house
# temp$LotShape = as.numeric(house$LotShape)
# cor(na.omit(temp[-1]))

## Missing Data and Data Cleansing
house = house[-1]
# summary(house)
# any(is.na(house))
#qqnorm(na.omit(house$LotFrontage))
#qqline(na.omit(house$LotFrontage), col = "steelblue", lwd = 2)

#shapiro.test(na.omit(house$LotFrontage))
# From the output, the p-value > 0.05 implying that the distribution of the data are not significantly different from normal distribution. In other words, we can assume the normality.
# reject H_0, not normality
house[which(is.na(house$LotFrontage)), "LotFrontage"] = mean(na.omit(house$LotFrontage))

# it is apparently possible to have MasVnrType = 0 and have positive area, I will fill missing MasVnrType entries with none and missing MasVnrArea entries with 0.
# MasVnrType/MasVnrArea -> both have 8 values missing, I presume they are the same ones. Either set as "None"/0 or use most frequent value/median.
# from the nature of MasVnrArea, it is difficult to fill in with estimate (replace with mode/median)
# mode = median
#unique(na.omit(house$MasVnrArea))[which.max(tabulate(match(na.omit(house$MasVnrArea), unique(na.omit(house$MasVnrArea)))))]
#median(na.omit(house$MasVnrArea))
house[which(is.na(house$MasVnrArea)), "MasVnrArea"] = 0

shapiro.test(house$SalePrice)
qqnorm(house$SalePrice)
qqline(house$SalePrice, col = "steelblue", lwd = 2)

errorEval = function(model, data, train, test) {
  
  
  
  
}

temp = house

dim(temp)

-1/2*log(1/2, 2)-1/2*log(1/2, 2)

1-(5/10 * I(1/5,4/5))
1-(2/10 * I(1/2,1/2)+4/10*I(3/4,1/4) +4/10*I(1/4,3/4))
1-(4/10 * I(3/4,1/4)+4/10*I(1/2,1/2))
1-(5/10 * I(2/5,3/5)+5/10*I(3/5,2/5))
1-(4/10 * I(1/4,3/4)+5/10*I(3/5,2/5))
I(1/2,0)
I = function(x,y)
  return(-x*log(x,2)-y*log(y,2))


errorEval(lin_reg, house, train, test)


# cross-validation error
cv = list(rep(0, 8), rep(0, 8))
pe = list(rep(0, 8), rep(0, 8))

reg_pro = data.frame(cv = seq(0, 4), pe = rep(0, 4))
cla_pro = data.frame(cv = rep(0, 4), pe = rep(0, 4))
result = list(reg_pro = data.frame(cv = seq(1, 4), pe = seq(1, 4)), cla_pro = data.frame(cv = seq(1, 4), pe = seq(1, 4)))
result$reg_pro[1, 2]
sqrt(result$reg_pro)

## train data and test data
set.seed(4011)
index = sample(1:nrow(house), nrow(house) * 0.1)
train = rep(T, nrow(house))
train[index] = F
test = !train

## Linear Regression Model ######################################################################
# library(MASS)
# lin_reg = lm(SalePrice ~ ., data = house, subset = train)
# # summary(lin_reg)
# temp = summary(lin_reg)
# 
# any(temp$coefficients[,4] > 0.05)
# 
# AIC = stepAIC(lin_reg, direction = "both", trace = 1)
# BIC = stepAIC(lin_reg, direction = "both", trace = log(nrow(house)))

# names(house)
# 
# model_terms = strsplit(as.character(AIC$call$formula), " ")
# model_terms = model_terms[[3]][model_terms[[3]] != "1" & model_terms[[3]] != "+"]
# model_terms
# # paste0("SalePrice ~ ", as.character(AIC$call$formula)[3])
# # paste0("SalePrice ~ ", as.character(BIC$call$formula)[3])
# 
# # model_terms = strsplit(as.character(AIC$call$formula)[3], " ")
# # model_terms = model_terms[[1]][model_terms[[1]] != "1" & model_terms[[1]] != "+"]
# 
library(boot)

lin_reg = glm(paste0("SalePrice ~ ", as.character(AIC$call$formula)[3]), data = house, subset = train)
# summary(lin_reg)

# set.seed(4011)
cv[[1]][1] = cv.glm(house[train, ], lin_reg, K = 10)$delta[1]

pe[[1]][1] = mean((predict(lin_reg, house[test, ]) - house$SalePrice[test]) ^ 2)

## Ridge Regression Model ######################################################################
# x = model.matrix(SalePrice ~ ., data = house)[, -1]
# y = house$SalePrice
# 
# library(glmnet)
# rid_reg = glmnet(x[train, ], y[train], alpha = 0)
# #plot(rid_reg)
# 
# #set.seed(4011)
# lambda = cv.glmnet(x[train,], y[train], alpha = 0, number = 10)
# #plot(lambda)
# rid_reg = glmnet(x[train, ], y[train], alpha = 0, lambda = lambda$lambda.min)
# #coefficients(rid_reg)
# 
# cv[[1]][2] = min(lambda$cvm)
# 
# pe[[1]][2] = mean((predict(rid_reg, s = lambda$lambda.min, newx = x[test, ]) - y[test]) ^ 2)

## Lasso Regression Model ######################################################################
# x = model.matrix(SalePrice ~ ., data = house)[,-1]
# y = house$SalePrice
# 
# x = model.matrix(SalePrice ~ ., data = house)[, -1]
# x = scale(x)
# y = house$SalePrice
# 
# library(glmnet)
# las_reg = glmnet(x[train, ], y[train], alpha = 1)
# # plot(las_reg)
# 
# plot(las_reg, xvar = "lambda", label = TRUE)
# 
# #set.seed(4011)
# lambda = cv.glmnet(x[train,], y[train], alpha = 1)
# plot(lambda)
# las_reg = glmnet(x[train, ], y[train], alpha = 1, lambda = lambda$lambda.min)
# #coefficients(las_reg)
# 
# cv[[1]][3] = min(lambda$cvm)
# 
# pe[[1]][3] = mean((predict(las_reg, s = lambda$lambda.min, newx = x[test, ]) - y[test]) ^ 2)

## Principal Components Regression Model ######################################################################
# x = model.matrix(SalePrice ~ ., data = house)[,-1]
# y = house$SalePrice
# library(pls)
# #set.seed(4011)
# pcr_reg = pcr(SalePrice ~ ., data = house, subset = train, scale = T, validation = "CV")
# 
# summary(pcr_reg)
# validationplot(pcr_reg, val.type = "MSEP")
# 
# cv[[1]][4] = 37653 ^ 2
# pe[[1]][4] = mean((predict(pcr_reg, x[test, ], ncomp = 13) - y[test]) ^ 2)

## Partial Least Squares Regression Model ######################################################################
# x = model.matrix(SalePrice ~ ., data = house)[,-1]
# y = house$SalePrice
# library(pls)
# #set.seed(4011)
# pls_reg = plsr(SalePrice ~ ., data = house, subset = train, scale = T, validation = "CV", number = 10)
# summary(pls_reg)
# validationplot(pls_reg, val.type = "MSEP")
# 
# #mean((pls_pred - y_test)^2)
# 
# cv[[1]][5] = 37061 ^ 2
# pe[[1]][5] = mean((predict(pls_reg, x[test, ], ncomp = 5) - y[test]) ^ 2)

## Regression Tree Model ######################################################################
# y = house$SalePrice
# 
# library(tree)
# RNGkind(sample.kind = "Rounding")
# set.seed(4011)
# tre_reg = tree(SalePrice ~ ., data = house, subset = train)
# summary(tre_reg)
# 
# plot(tre_reg)
# text(tre_reg, pretty = 0)
# 
# temp = cv.tree(tre_reg)
# plot(temp$size, temp$dev, type = "b")
# 
# temp2 = prune.tree(tre_reg, best = 6)
# summary(temp2)
# 
# plot(temp2)
# text(temp2, pretty = 0)
# 
# # prune may not result good thing
# # mean((predict(temp2, newdata = house[test, ]) - y[test]) ^ 2)
# pe[[1]][6] = mean((predict(tre_reg, newdata = house[test, ]) - y[test]) ^ 2)

## Radnom Forests Model ######################################################################
# y = house$SalePrice
# 
# library(randomForest)
# set.seed(4011)
# rfm_reg = randomForest(SalePrice ~ ., data = house, subset = train, mtry = round((ncol(house) - 1) / 3), importance = T)
# 
# 
# importance(rfm_reg)
# varImpPlot(rfm_reg)
# plot(rfm_reg)
# 
# 
# rfm_reg$y
# 
# tail(rfm_reg$mse, 1)
# 
# rf.crossValidation(x, xdata, ydata = NULL, p = 0.1, n = 99,
#                    seed = NULL, normalize = FALSE, bootstrap = FALSE, trace = FALSE,
#                    ...)
# 
# pe[[1]][7] = mean((predict(rfm_reg, newdata = house[test, ]) - y[test]) ^ 2)



## Boosting ######################################################################
# y = house$SalePrice
# library(gbm)
# boo_reg = gbm(SalePrice ~ ., data = house[train, ], cv.folds = 10, distribution = "gaussian", n.trees = 5000, interaction.depth = 5, shrinkage = 0.001, verbose = F)
# #summary(boo_reg)
# #mse of cv
# #min(boo_reg$cv.error)
# pe[[1]][8] = mean((predict(boo_reg, newdata = house[test, ], n.trees = 100) - y[test]) ^ 2)
# 
# sqrt(pe[[1]])

####################################################################################################

titanic <- read.csv("Titanic.csv", header = TRUE)
titanic[which(is.na(titanic$Age)), "Age"] = ifelse(titanic$Pclass == 1, round(mean(na.omit(titanic[which(titanic$Pclass == 1), "Age"]), trim = 0.1)), ifelse(titanic$Pclass == 2, round(mean(na.omit(titanic[which(titanic$Pclass == 2), "Age"]), trim = 0.1)), round(mean(na.omit(titanic[which(titanic$Pclass == 3), "Age"]), trim = 0.1))))[which(is.na(titanic$Age))]
titanic[which(titanic$Embarked == ""), "Embarked"] = "S"
titanic$Embarked = as.factor(as.character(titanic$Embarked))
titanic$Sex = as.factor(titanic$Sex)
titanic$Survived = factor(ifelse(titanic$Survived == 1, "Survived", "Died"))
titanic = titanic[-1]
set.seed(4011)
index = sample(1:nrow(titanic), nrow(titanic) * 0.1)
train = rep(T, nrow(titanic))
train[index] = F
test = !train
# dim(titanic)
# head(titanic)
# titanic = titanic[-1]
# summary(titanic)
# names(titanic)

#any(is.na(Titanic))
# dim(titanic)
#shapiro.test(na.omit(titanic$Age))
# reject H_0, not normality
# titanic[which(is.na(titanic$Age)), "Age"] = mean(na.omit(titanic$Age))
# 
# 
# titanic[which(titanic$Pclass == 1),1]
# mean(titanic[which(titanic$Pclass == 1),1])
# a= sum(titanic[which(titanic$Pclass == 1),1]) / length(titanic[which(titanic$Pclass == 1),1])
# b= sum(titanic[which(titanic$Pclass == 2),1]) / length(titanic[which(titanic$Pclass == 2),1])
# c= sum(titanic[which(titanic$Pclass == 3),1]) / length(titanic[which(titanic$Pclass == 3),1])
# temp = c(a,b,c)
# 
# library(RColorBrewer)
# col = brewer.pal(3, "Set2")
# barplot(temp, names = c("Upper Class", "Middle Class", "Lower Class"), ylim = c(0, 0.6), col = col)
# 
# titanic[which(titanic$Pclass == 1), "Age"]
# hist(titanic[which(titanic$Pclass == 1), "Age"])
# hist(titanic[which(titanic$Pclass == 2), "Age"])
# hist(titanic[which(titanic$Pclass == 3), "Age"])
# 
# hist(titanic[which(titanic$Pclass == 1), "Age"], xlab = "Upper Class", main = NULL, col = brewer.pal(3, "Set2")[1])
# hist(titanic[which(titanic$Pclass == 2), "Age"], xlab = "Middle Class", main = NULL, col = brewer.pal(3, "Set2")[2])
# hist(titanic[which(titanic$Pclass == 3), "Age"], xlab = "Lower Class", main = NULL, col = brewer.pal(3, "Set2")[3])
# 
# 
# titanic[which(titanic$Survived == 1), ]
# sum(titanic$Survived == 1)
# titanic[which(titanic$Sex == "male"), "Survived"] / nrow(titanic)
# 
# d=sum(titanic[which(titanic$Sex == "female"), "Survived"])/ sum(titanic$Survived == 1)
# e=sum(titanic[which(titanic$Sex == "male"), "Survived"])/ sum(titanic$Survived == 1)
# temp2=c(d,e)
# barplot(temp2, names = c("Male", "Female"), ylim = c(0, 0.8), col = brewer.pal(3, "Set1"))
# sum(titanic[which(titanic$Sex == "male"), "Survived"])/ sum(titanic$Survived == 1)
# 
# mean(titanic[which(titanic$Sex == "male"), "Survived"])
# 
# plot(titanic$Fare, titanic$Age)
# 
# barplot(H,names.arg=M,xlab="Month",ylab="Revenue",col="blue",
#         main="Revenue chart",border="red")
# 
# titanic$Survived = factor(ifelse(titanic$Survived == 1, "Survived", "Died"))


# 
# #hist(titanic$Age)
# 
# titanic[which(is.na(titanic$Age)),]
# 
# hist(titanic$Age)
# titanic$Age = ifelse(titanic$Age <= 10, "Group 1", ifelse(titanic$Age <= 30, "Group 2", ifelse(titanic$Age <= 50, "Group 3", "Group4")))
# 
# y = titanic[which(!is.na(titanic$Age)), "Age"]
# x = titanic[which(!is.na(titanic$Age)), -4]
# head(x)
# 
# titanic[which(titanic$Pclass == 1)]
# titanic[which(is.na(titanic$Age)), "Age"]
# 
# titanic[which(is.na(titanic$Age)), "Age"] = 1
# 
# titanic[which(titanic$Pclass == 1), "Age"]
# mean(na.omit(titanic[which(titanic$Pclass == 1), "Age"]), trim = 0.1)
# mean(na.omit(titanic[which(titanic$Pclass == 2), "Age"]), trim = 0.1)
# mean(na.omit(titanic[which(titanic$Pclass == 3), "Age"]), trim = 0.1)
# 
# round(mean(na.omit(titanic[which(titanic$Pclass == 1), "Age"]), trim = 0.1))
# round(mean(na.omit(titanic[which(titanic$Pclass == 2), "Age"]), trim = 0.1))
# round(mean(na.omit(titanic[which(titanic$Pclass == 3), "Age"]), trim = 0.1))
# 
# temp = ifelse(titanic$Pclass == 1, round(mean(na.omit(titanic[which(titanic$Pclass == 1), "Age"]), trim = 0.1)), ifelse(titanic$Pclass == 2, round(mean(na.omit(titanic[which(titanic$Pclass == 2), "Age"]), trim = 0.1)), round(mean(na.omit(titanic[which(titanic$Pclass == 3), "Age"]), trim = 0.1))))[which(is.na(titanic$Age))]
# titanic[which(is.na(titanic$Age)), "Age"] = ifelse(titanic$Pclass == 1, round(mean(na.omit(titanic[which(titanic$Pclass == 1), "Age"]), trim = 0.1)), ifelse(titanic$Pclass == 2, round(mean(na.omit(titanic[which(titanic$Pclass == 2), "Age"]), trim = 0.1)), round(mean(na.omit(titanic[which(titanic$Pclass == 3), "Age"]), trim = 0.1))))[which(is.na(titanic$Age))]
# titanic[which(titanic$Embarked == ""), "Embarked"] = "S"
# temp[which(is.na(titanic$Age))]
# 
# 
# 
# library(lattice)
# 
# temp = titanic[,-4]
# splom(temp,pscales=0)
# 
# sse=rep(0,50)
# result = list()
# head(temp)
# temp$Survived = ifelse(temp$Survived == "Died", 0, 1)
# temp$Sex = ifelse(temp$Sex == "male", 1, 0)
# temp$Embarked = ifelse(temp$Embarked == "C", 0, ifelse(temp$Embarked == "Q", 1, 2))
# 
# for (k in 1:50) {
#   result[[k]] = kmeans(temp,k)
#   sse[k]=result[[k]]$tot.withinss
# }
# 
# plot(seq(1,50),sse,xlab="no. of clusters",ylab="SSE",pch=20,type="o")
# 
# print(result[[5]])
# 
# temp2 = sse - sse[-1]

# Since the scale of the variables are quite different,
# we will standardize the variables first.
# i.e. calculating the standard score
# cust.std = cust
# cust.std[,3:8] = scale(cust[,3:8])
# splom(cust.std[,3:8],pscales=0)
# 
# # Find the number of clusters "k"
# set.seed(533309101)
# sse=rep(0,50)
# result = list()
# for (k in 1:50) {
#   result[[k]] = kmeans(cust.std[,3:8],k)
#   sse[k]=result[[k]]$tot.withinss
# }

## k-Nearest Neighbors Model ######################################################################
# library(caret)
# library(e1071)
# set.seed(4011)
# #scale x????
# ctrl = trainControl(method = "cv", number = 10)
# 
# names(titanic)
# 
# 
# 
# x = model.matrix(Survived ~ Pclass + Age + Sex, data = titanic)[, -1]
# x = scale(x)
# 
# knn_mod = train(Survived ~ Pclass + Age + Sex, data = titanic, subset = train, method = "knn", trControl = ctrl, tuneGrid   = expand.grid(k = 2:50))
# plot(knn_mod)
# 
# knn_mod$bestTune
# 
# 
# 
# 
# 
# cv[[2]][1] = 1 - knn_mod$results[knn_mod$bestTune[1, 1], "Accuracy"]
# 
# knn_pro = predict(knn_mod, newdata = titanic[test, ], type = "prob")
# knn_pre = rep("Died", nrow(knn_pro))
# knn_pre[knn_pro[2] > 0.5] = "Survived"
# 
# pe[[2]][1] = 1 - mean(knn_pre == titanic$Survived[test])




## Logistic Regression Model ######################################################################

# log_reg = glm(Survived ~ ., data = titanic, subset = train, family = binomial)
# summary(log_reg)
# log_reg$deviance
# 
# log_reg2 = glm(Survived ~ 1, data = titanic, subset = train, family = binomial)
# 
# library(MASS)
# library(dplyr)
# 
# # smallest deviance
# AIC = log_reg %>% stepAIC(trace = T)
# BIC = log_reg %>% stepAIC(trace = log(nrow(titanic)))
# 
# AIC$call == BIC$call
# model_terms = strsplit(as.character(AIC$call$formula), " ")
# model_terms = model_terms[[3]][model_terms[[3]] != "1" & model_terms[[3]] != "+"]
# model_terms
# 
# log_reg = AIC
# summary(log_reg)
# 
# paste0("SalePrice ~ ", as.character(AIC$call$formula)[3])
# 
# paste0("SalePrice ~ ", as.character(AIC$call$formula)[3])
# 
# log_pro = predict(log_reg, newdata = titanic[test, ], type = "response")
# log_pre = rep("Died", length(log_pro))
# log_pre[log_pro > 0.5] = "Survived"
# 
# table(log_pre, titanic$Survived[test])
# 
# 
# library(MLmetrics)
# 
# F1_Score(log_pre, titanic$Survived[test], NULL)
# 
# f_meas()
# F.measure.single(log_pre, labels)
# 
# 
# pe[[2]][2] = 1 - mean(log_pre == titanic$Survived[test])
# 
# log_reg2 = glm(paste0("Survived ~ ", as.character(AIC$call$formula)[3]), data = titanic, subset = train, family = binomial)
# summary(log_reg2)
# cv.glm(titanic[train, ], log_reg2, K = 10)$delta[1]
# 
# 
# paste0("Survived ~ ", as.character(AIC$call$formula)[3])
# 
# library(caret)
# paste0("Survived ~ ", as.character(AIC$call$formula)[3])
# get(paste0("Survived ~ ", as.character(AIC$call$formula)[3]))
# 
# ctrl = trainControl(method = "CV", number = 10)
# model <- train(get(paste0("Survived ~ ", as.character(AIC$call$formula)[3])),
#                data = titanic[train,],
#                trControl = ctrl,
#                method = "glm",
#                family=binomial())
# model$results[model$bestTune[1, 1], "Accuracy"]
# 
# # print cv scores
# names(model)
# summary(model)
# 
# 
# model$results
# 
# library(boot)
# cv.glm(titanic[train, ], log_reg, K = 10)$delta[1]

## Linear Discriminant Analysis ######################################################################
library(MASS)

lda_mod = lda(Survived ~ ., data = titanic, subset = train, cv = T, number = 10)

lda_mod$terms
summary(lda_mod)

lda_pro = predict(lda_mod, newdata = titanic[test, ])
pe[[2]][3] = 1 - mean(lda_pro$class == titanic$Survived[test])


cv.glm(titanic[train, ], lda_mod, K = 10)$delta[1]


boolean = train

lda_mod = lda(Survived ~ ., data = titanic, subset = train)
par(mfrow = c(1, 2))
plot(lda_mod)

lda_cv(titanic, train, 10)

lda_cv = function(titanic, train, K) {
  data = titanic[boolean, ]
  rownames(data) = NULL
  n = nrow(data)
  fold = K
  foldIndex = sample(fold, n, replace = T)
  error = rep(0, fold)
  for(i in 1:fold) {
    train = foldIndex != i
    test = foldIndex == i
    lda_cvm = lda(Survived ~ ., data = data, subset = train)
    lda_cvp = predict(lda_cvm, newdata = data[test, ])
    error[i] = 1 - mean(lda_cvp$class == data$Survived[test])
  }
  return(mean(error))
}

lda_pro$class






## Classification Tree Model ######################################################################
# library(tree)
# tre_cla = tree(Survived ~ ., data = titanic, subset = train)
# summary(tre_cla)
# 
# # plot(tre_cla)
# # text(tre_cla, pretty = 0)
# 
# RNGkind(sample.kind = "Rounding")
# set.seed(4011)
# tre_pru = cv.tree(tre_cla)
# plot(tre_pru$size, tre_pru$dev, type = "b")
# 
# tre_cla = prune.tree(tre_cla, best = 4)
# summary(tre_cla)
# 
# # plot(tre_cla)
# # text(tre_cla, pretty = 0)
# 
# tre_pro = predict(tre_cla, newdata = titanic[test, ])
# tre_pre = rep("Died", nrow(tre_pro))
# tre_pre[tre_pro[2] > 0.5] = "Survived"
# 
# pe[[2]][4] = 1 - mean(tre_pre == titanic$Survived[test])

## Radom Forests Model ######################################################################
# library(randomForest)
# set.seed(4011)
# rfm_cla = randomForest(Survived ~ ., data = titanic, subset = train, mtry = round(sqrt((ncol(titanic) - 1))), importance = T)
# 
# pe[[2]][5] = 1 - mean(predict(rfm_cla, newdata = titanic[test, ]) == titanic$Survived[test])
# 
# # importance(rfm_cla)
# # varImpPlot(rfm_cla)

## Boosting ######################################################################
library(adabag)
library(caret)

model = boosting(Survived ~ ., data = titanic[train,], boos = T, mfinal = 100)

summary(model)


pred = predict(model, titanic[test, -1])
mean(pred$class == titanic$Survived[test])


model.cv = boosting.cv(Survived ~ ., data = titanic[train,], boos = T, mfinal = 10, v = 10)

model.cv$error

model = boosting(Species~., data=train, boos=TRUE, mfinal=50)

model.cv = boosting.cv(Species~., data=iris, boos=TRUE, mfinal=10, v=5)


library(caret)
library(e1071)
set.seed(4011)
ctrl = trainControl(method = "cv", number = 10)
boo_cla = train(Survived ~ ., data = titanic[train, ], method = "gbm", trControl = ctrl, verbose = F)

plot(boo_cla)

boo_cla$bestTune
cv[[2]][6] = boo_cla$results[which(rownames(boo_cla$results) == rownames(boo_cla$bestTune)), "Accuracy"]

boo_pro = predict(boo_cla, newdata = titanic[test, ], type = "prob")
boo_pre = rep("Died", nrow(boo_pro))
boo_pre[boo_pro[2] > 0.5] = "Survived"
pe[[2]][6] = 1 - mean(boo_pre == titanic$Survived[test])

library(rpart)
library(rpart.plot)
fit <- rpart(Survived~., data = titanic[train,], method = 'class')
rpart.plot(fit, extra = 106)

install.packages("ada")
library(ada)

control = rpart.control(cp = -1, maxdepth = 14,maxcompete = 1,xval = 0)
temp2 = ada(Survived ~ ., data = titanic[train, ], test.x = titanic[test, -1], test.y = titanic$Survived[test], nu = 0.01, type = "gentle", control = control, iter = 500)
temp2 = ada(Survived ~ ., data = titanic[train, ], test.x = titanic[test, -1], test.y = titanic$Survived[test], type = "gentle", control = control, iter = 500)

plot(temp2)
summary(temp2)
varplot(temp2)

boo_pro = predict(temp2, newdata = titanic[test, ])
mean(boo_pro == titanic$Survived[test])



temp2 = ada(Survived ~ ., data = titanic[train, ], test.x = titanic[test, -1], test.y = titanic$Survived[test], type = "gentle", control = ctrl, iter = 100)
summary(temp2)

temp2 = ada(Survived ~ ., data = titanic[train, ], test.x = titanic[test, -1], test.y = titanic$Survived[test], type = "gentle", control = ctrl, iter = 500)
summary(temp2)


ctrl = rpart.control(cp = -1, maxdepth = 14, maxcompete = 1, xval = 0)

ada_cv = function(titanic, train, K) {
  data = titanic[train, ]
  rownames(data) = NULL
  n = nrow(data)
  fold = K
  foldIndex = sample(fold, n, replace = T)
  B = seq(100, 500, 100)
  len = length(B)
  BE = rep(0, len)
  for(j in 1:len) {
    error = rep(0, fold)
    for(i in 1:fold) {
      train = foldIndex != i
      test = foldIndex == i
      ada_cvm = ada(Survived ~ ., data = data[train, ], type = "gentle", control = ctrl, iter = B[j])
      ada_cvp = predict(ada_cvm, newdata = data[test, ])
      error[i] = 1 - mean(ada_cvp == data$Survived[test])
    }
    BE[j] = mean(error)
    print(paste0("Cross-Validation error for B = ", B[j], " is ", BE[j]))
  }
  return(list(BE, B[which(BE == min(BE))], min(BE)))
}

cve = ada_cv(titanic, train, 10)
plot(seq(100, 500, 100), cve[[1]], type = "o", xlab = "#. of B", ylab = "10-folds Cross-Validation Error")



ada_mod = ada(Survived ~ ., data = titanic[train, ], type = "gentle", control = ctrl, iter = cve[[2]])
summary(ada_mod)

par(mfrow = c(1, 2))
varplot(ada_mod)
plot(ada_mod)



ada_pre = predict(ada_mod, newdata = titanic[test, ])
mean(ada_pre == titanic$Survived[test])
cve[[3]]

set.seed(4011)
index = sample(1:nrow(titanic), nrow(titanic) * 0.1)
train = rep(T, nrow(titanic))
train[index] = F
test = !train

## Support Vector Machine Model ######################################################################


