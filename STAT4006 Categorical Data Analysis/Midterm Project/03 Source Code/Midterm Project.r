# Part I
library(AER)
data("CPS1985")
summary(CPS1985)

CPS1985$experience = cut(CPS1985$experience, 6, labels = c("[0, 10]", "[11, 20]", "[21, 30]", "[31, 40]", "[41, 50]", "[51, ∞)"), ordered_result = T)

table(CPS1985$sector, CPS1985$experience, CPS1985$gender)

chisq.test(table(CPS1985$sector, CPS1985$experience, CPS1985$gender)[,,1])$expected
chisq.test(table(CPS1985$sector, CPS1985$experience, CPS1985$gender)[,,2])$expected

fisher.test(table(CPS1985$sector, CPS1985$experience, CPS1985$gender)[,,1], simulate.p.value = T)
fisher.test(table(CPS1985$sector, CPS1985$experience, CPS1985$gender)[,,2], simulate.p.value = T)

table(CPS1985$sector, CPS1985$experience)
fisher.test(table(CPS1985$sector, CPS1985$experience), simulate.p.value = T)

# Part II
library(AER)
data("CPS1985")

hist(CPS1985$wage, main = "Wage Distribution", xlab = "Wage")

shapiro.test(CPS1985$wage)

plot(CPS1985$age, CPS1985$wage)
reg = lm(wage ~ age, data = CPS1985)
abline(reg, col = "red", lwd = 6)

CPS1985$wage = ifelse(CPS1985$wage <= 5 , "[1, 5]", ifelse(CPS1985$wage <= 10, "[6, 10]", ifelse(CPS1985$wage <= 15, "[11, 15]", ifelse(CPS1985$wage <= 20, "[16, 20]", "[21, ∞)"))))
CPS1985$wage = factor(CPS1985$wage, levels = c("[1, 5]", "[6, 10]", "[11, 15]", "[16, 20]", "[21, ∞)"))

CPS1985$education = ifelse(CPS1985$education <= 6, "Primary School", ifelse(CPS1985$education <= 13, "High School", ifelse(CPS1985$education <= 16, "Graduate", "PhD")))
CPS1985$education = factor(CPS1985$education, levels = c("Primary School", "High School", "Graduate", "PhD"))

library(MASS)
fit0 = polr(wage ~ 1, data = CPS1985)
fit1 = polr(wage ~ education + age + ethnicity + region + occupation + union + married, data = CPS1985)
stepAIC(fit0, scope = list(lower = fit0, upper = fit1), trace = T, direct = "forward")
stepAIC(fit0, scope = list(lower = fit0, upper = fit1), trace = T, k = log(nrow(CPS1985)), direct = "forward")

fit = polr(wage ~ education + age + occupation + union, data = CPS1985)
summary(fit)
coef(fit)

anova(fit, fit0)