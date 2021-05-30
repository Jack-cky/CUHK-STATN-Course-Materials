setwd("/Users/jackchan/Documents/I go to school by bus/03 The Chinese University of Hong Kong/Year 3/Semester 1/STAT4011 Statistics Projects/Project II")

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

library(tree)
tre_cla = tree(Survived ~ ., data = titanic, subset = train)

plot(tre_cla)
text(tre_cla, pretty = 0)

tre_pro = predict(tre_cla, newdata = titanic[test, ])
tre_pre = rep("Died", nrow(tre_pro))
tre_pre[tre_pro[2] > 0.5] = "Survived"
mean(tre_pre == titanic$Survived[test])

tre_pru = cv.tree(tre_cla)
plot(tre_pru$size, tre_pru$dev, type = "b")

tre_cla = prune.tree(tre_cla, best = 4)

tre_pro = predict(tre_cla, newdata = titanic[test, ])
tre_pre = rep("Died", nrow(tre_pro))
tre_pre[tre_pro[2] > 0.5] = "Survived"
mean(tre_pre == titanic$Survived[test])