setwd("/Users/jackchan/Downloads")
data = read.csv("BONEDEN.csv")

var.test(data$fn1, data$fn2)
t.test(data$fn1, data$fn2, var.equal = T)

fn = c(data$fn1, data$fn2)
label = c(rep("LST", length(data$fn1)), rep("HST", length(data$fn2)))
wilcox.test(fn~label,
            alternative = "two.sided",
            mu = 0,
            paired = F,
            exact = F,
            correct = T,
            conf.int = F)

1-pchisq(1.5652,1)
2*(1-pnorm(1.4357))
2*(1-pnorm(2.5129))
1-pchisq(41.7103,1)

table=matrix(c(4,5,1,19),nr=2)
table=matrix(c(1,19,4,5),nr=2)
fisher.test(table)

table=matrix(c(19,5,14,10,9,6,45,39),nr=2)
chisq.test(table,correct = F)