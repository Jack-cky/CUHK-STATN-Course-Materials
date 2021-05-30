qt(.975,15)
2*(1-pt(1.6982,77))
qnorm(.975)
1-pf(4.9895,2,19)
qt(.975,19)
qt(.9917,19)

setwd("/Users/jackchan/Downloads")
data = read.csv("LEAD.csv")

kruskal.test(maxfwt ~ lead_grp, data = data)