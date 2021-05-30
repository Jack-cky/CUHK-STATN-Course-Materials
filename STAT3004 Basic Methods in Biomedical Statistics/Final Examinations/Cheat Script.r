# One-Sample t test (Chapter 1 Page 28)
t.test(x, mu = 45, alternative = "two.sided", conf.level = 0.95)

# One sample proportion test (Chapter 1 Page 61)
prop.test(10, 40, p = 0.2, alternative = "two.sided", correct = T)

# Sum of Binomial probabilities (Chapter 1 Page 65)
2 * (1 - pbinom(4, 13, 0.2))

# Sum of Poison probabilities (Chapter 1 Page 73)
2 * (1 - ppois(3, 3.3))

# Paried t test (Chapter 2 Page 10)
t.test(x1, x2, paired = T)

# F test for equal of 2 variances
var.test(x1, x2)

# Two sample test for equal variances
t.test(x1, x2, var.equal = T)

# Two sample test for unequal variances
t.test(x1, x2, var.equal = F)

# Sign test (Chapter 3 Page 16)
prop.test(18, 40, p = 0.5, alternative = "two.sided", correct = T)

# Wilcoxon signed-rank test (Chapter 3 Page 31)
d = rep(-10:10, c(0, 0, 1, 3, 2, 2, 1, 5, 4, 4, 5, 10, 6, 2, 0, 0, 0, 0, 0, 0, 0))
wilcox.test(d,
            y = NULL,
            alternative = "two.sided",
            mu = 0,
            paried = F,
            exact = NULL,
            correct = T,
            conf.int = F)

# Wilcoxon signed-rank test (n < 16)
qsignrank(0.025, 14)
qsignrank(0.975, 14)

# Wilcoxon rank-sum test (Chapter 3 Page 45)
fn = c(data$fn1, data$fn2)
label = c(rep("LST", length(data$fn1)), rep("HST", length(data$fn2)))
wilcox.test(fn ~ label,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = F,
            correct = T,
            conf.int = F)

# Yates-corrected chi square test (Chapter 4 Page 18)
table = matrix(c(683, 1498, 2537, 8747), nr = 2)
chisq.test(table)
chisq.test(table)$expected

# Fisher's exact test (Chapter 4 Page 31)
table = matrix(c(2, 5, 23, 30), nr = 2)
fisher.test(table)

# Chi square goodness-of-fit test (Chapter 4 Page 61)
O = c(57, 330, 2132, 4584, 4604, 2119, 659, 251)
mu = 80.68
sd = 12
k = 2
n = sum(O)
a = c(-Inf, seq(50, 110, by = 10), Inf)
g = length(a) - 1
E = numeric(g)
for(i in 1:g)
  E[i] = n * (pnorm((a[i + 1] - mu) / sd) - pnorm((a[i] - mu) / sd))
X2 = sum((O - E) ^ 2 / E)
p = 1- pchisq(X2, g - k - 1)

# simple regression (Chapter 5 Page 23 and 27)
model=lm(Y~X)
summary(model)
anova(model)
newdata=data.frame(newX = c(10,15,20))
predict(model, newdata, interval = "prediction")
predict(model, newdata, interval = "confidence")

# multiple regression (Chapter 5 Page 39)
model=lm(Y~X1+X2)
summary(model)
anova(model)

# correlation test (Chapter 5 Page 44)
cor.test(X1,X2)

# ANOVA (Chapter 6 Page 16)
x = c(20.8,4.1,30,24.7,13.8,7.5,7.5,11.9,4.5,3.1,8,4.7,28.1,10.3,10,5.1,2.2,9.2,2,2.5,6.1,7.5)
group = as.factor(c(rep(1,5), rep(2,12), rep(3,5)))
model=aov(x ~ group)
anova(model)

# multiple comparisons (Chapter 6 Page 36)
library(lsmeans)
lsm = lsmeans(model, ~group)

# Individual CI of group mean (Chapter 6 Page 37)
confint(lsm, level=0.95)

# Bonferroni's method (Chapter 6 Page 37)
summary(
  contrast(
    lsm, 
    method="pairwise", 
    adjust="bonferroni"
  ),
  infer=c(T,T), 
  level=0.99, 
  side="two-sided"
)

# Scheffe's method (Chapter 6 Page 42)
summary(
  contrast(
    lsm, 
    method="pairwise", 
    adjust="scheffe"
  ),
  infer=c(T,T), 
  level=0.99, 
  side="two-sided"
)

# 2-way ANOVA (Chapter 6 Page 52)
group2 = as.factor(c(rep(1,6), rep(2,5), rep(3,11)))
model=aov(x ~ group + group2)
anova(model)

# Kruskal-Wallis Test (Chapter 6 Page 60)
kruskal.test(score~group, data=d)
library(dunn.test)
dunn.test(d$score, d$group, method = "bonferroni")

# logistic regression (Chapter 7 Page 50)
x=c(rep(1,683),rep(0,2537),rep(1,1498),rep(0,8747))
y=c(rep(1,683+2537),rep(0,1498+8747))
d=data.frame(cbind(x,y))
model = glm(y~x, data=d ,family=binomial)
summary(model)
est=as.numeric(model$coeff)
(OR=exp(est[2]))
(pE=exp(sum(est))/(1+exp(sum(est))))
(pU=exp(est[1])/(1+exp(est[1])))