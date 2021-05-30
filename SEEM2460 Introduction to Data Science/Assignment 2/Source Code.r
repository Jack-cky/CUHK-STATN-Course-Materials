y = c()

y[1] = data[1]

for(i in 2:25) {
  y = c(y, data[i] - data[i - 1])
}

x = 1:25
reg=lm(y~x)

plot(1:25, y, type = 'l', xlab = 'date', ylab = 'newly confirmed')

abline(reg, col = 'red',lty = 2, lwd = 2)



data = scan()
332
555
653
941
2019
2794
4473
6057
7783
9776
9925
14549
17295
20588
24503
24630
30806
31532
37549
40536
42767
45117
60328
64422
64460