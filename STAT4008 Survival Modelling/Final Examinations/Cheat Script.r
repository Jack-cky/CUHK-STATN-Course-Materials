####################################################################################################
library(survival)
####################################################################################################
# 0 right-censored
# 1 failure
# 2 left-censored
# 3 interval
####################################################################################################
## right-censored
ti = c(1,1,1,2,2,3,3,3,4,4,4,5,5,6,6,6,6,6,7,8,8,9,9,9,9)
ci = as.integer(unlist(strsplit('0110001100011000111000001', "")))

# ti = c(1,2,3,4,5,6,7,8,9)
# ri = as.integer(unlist(strsplit('121303023', "")))
# di = as.integer(unlist(strsplit('202022101', "")))
# ti = rep(ti, ri + di)
# ci = c()
# if(length(ri) == length(di)) {
#   for(i in 1:length(ri)) {
#     ci = c(ci, rep(0, ri[i]), rep(1, di[i]))
#   }
# }

# set.seed(2)
# setwd('/Users/jackchan/Downloads')
# data = read.csv("mtest.csv")
# data = data[sample(1:nrow(data), 200), ]
# ti = data$x
# ci = 1 - data$ind

sur = survfit(Surv(ti, ci) ~ 1)

# temp = summary(sur)
# result = data.frame(temp$time, temp$n.event, temp$n.risk, round(lambda <- temp$n.event / temp$n.risk, 4), round(temp$surv, 4), round(temp$std.err, 4), round(exp(-cumsum(lambda)), 4), round(sqrt(cumsum(temp$n.event / temp$n.risk ^ 2)) * exp(-cumsum(lambda)), 4))
# colnames(result) = c('ti', 'di', 'ni', 'lambda', 'KM est', 'KM se', 'NA est', 'NA se')
# result = rbind(c(0, 0, temp$n, 0, 1, 0, 1, 0), result)
# tMax = tail(sur$time, 1)
# result$mean = cumsum(result$`KM est`[length(result$`KM est`):1] * (c(tMax, result$ti[length(result$ti):1][1:length(result$ti) - 1]) - result$ti[length(result$ti):1]))[length(result$`KM est`):1]
# # result
# 
# mean.se = round(sqrt(sum(result$mean ^ 2 * result$di / (result$ni * (result$ni - result$di)), na.rm = T)), 4)

print(sur, print.rmean = T)

## confidence interval
# result$linearLB = round(result$`KM est` - qnorm(0.975) * result$`KM se`, 4)
# result$linearUB = round(result$`KM est` + qnorm(0.975) * result$`KM se`, 4)
# 
# result$loglogTransLB = round(result$`KM est` ^ (1 / exp(qnorm(0.975) * result$`KM se` / (result$`KM est` * log(result$`KM est`)))), 4)
# result$loglogTransUB = round(result$`KM est` ^ exp(qnorm(0.975) * result$`KM se` / (result$`KM est` * log(result$`KM est`))), 4)
# 
# result$arcinTransLB = round(sin(asin(sqrt(result$`KM est`)) - qnorm(0.975) * 0.5 * result$`KM se` / result$`KM est` * sqrt(result$`KM est` / (1 - result$`KM est`))) ^ 2, 4)
# result$arcinTransUB = round(sin(asin(sqrt(result$`KM est`)) + qnorm(0.975) * 0.5 * result$`KM se` / result$`KM est` * sqrt(result$`KM est` / (1 - result$`KM est`))) ^ 2, 4)

## quantile
# p = 0.5
# result$linear = (result$`KM est` - (1 - p)) / result$`KM se`
# quantileLinear = result$ti[result$linear <= 1.96 & result$linear >= -1.96]
# quantileLinearRange = c(min(quantileLinear, na.rm = T), max(quantileLinear, na.rm = T))
# 
# result$loglogTrans = ((log(-log(result$`KM est`)) - log(-log(1 - p))) * result$`KM est` * log(result$`KM est`)) / result$`KM se`
# quantileloglogTrans = result$ti[result$loglogTrans <= 1.96 & result$loglogTrans >= -1.96]
# quantileloglogTransRange = c(min(quantileloglogTrans, na.rm = T), max(quantileloglogTrans, na.rm = T))
# 
# result$arcsinTrans = 2 * (asin(sqrt(result$`KM est`)) - asin(sqrt(1 - p))) * sqrt(result$`KM est` * (1 - result$`KM est`)) / result$`KM se`
# quantilearcsinTrans = result$ti[result$arcsinTrans <= 1.96 & result$arcsinTrans >= -1.96]
# quantilearcsinTransRange = c(min(quantilearcsinTrans, na.rm = T), max(quantilearcsinTrans, na.rm = T))

## hazard function
# result$`Haz KM est` = round(-log(result$`KM est`), 4)
# result$`Haz KM se` = round(sqrt(cumsum(result$di / (result$ni * (result$ni - result$di)))), 4)
# 
# result$`Haz NA est` = round(cumsum(result$lambda), 4)
# result$`Haz NA se` = round(sqrt(cumsum(result$di / result$ni ^ 2)), 4)

## hazard function (full set, including 0 event cases)
# cum_KM = -log(sur$surv)
# cum_NA = cumsum(sur$n.event / sur$n.risk)
# plot(sur$time, cum_KM, type = 'l', col = 'red')
# lines(sur$time, cum_NA, type = 'l', col = 'blue')
####################################################################################################
## compare 2 groups of survival data
# model = survfit(Surv(ti, ci) ~ data$sex)
# plot(model, lty = 2:3)
####################################################################################################
## all types of censored
tsi = c(1, 6, 5, 3, 7, 2, 3, 4, 5)
tei = c(1, 6, 5, 3, 9, 2, 4, 4, 5)
ci = c(1, 0, 2, 1, 3, 2, 3, 1, 0)
sur = survfit(Surv(tsi, tei, ci, type = 'interval') ~ 1)
summary(sur)
print(sur, print.rmean = T)
####################################################################################################
## left-truncated
entry = c(58, 58, 59, 60, 60, 61, 61, 62 ,62, 62, 63, 63, 64, 66, 66, 67, 67, 67, 68, 69, 69, 69, 70, 70, 70, 71, 72, 72, 73, 73)
exit = c(60, 63, 69, 62, 65, 72, 69, 73, 66, 65, 68, 74, 71, 68, 69, 70, 77, 69, 72, 79, 72, 70, 76, 71, 78, 79, 76, 73, 80, 74)
ci = c(1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1)
data = data.frame(entry, exit, ci)
L = 60

sur = survfit(Surv(exit, ci) ~ 1, data[exit >= L, ])
ti = sur$time[sur$n.event != 0]
ni = rep(0, length(ti))
for(i in 1:length(ti))
  ni[i] = sum(entry <= ti[i] & ti[i]<= exit)
di = sur$n.event[sur$n.event != 0]
surv_fun = cumprod(1 - di / ni)

result = data.frame(ti, ni, round(surv_fun, 4))
colnames(result) = c('ti', 'ni', 'S(t|)')
result
####################################################################################################
## right-truncated
ti = c(2, 4, 7, 14, 20, 18, 8, 13, 17, 26, 20, 15, 23, 5, 16, 15, 11, 9, 33, 4, 8, 35, 10, 36, 25)
xi = c(30, 27, 25, 19, 18, 17, 16, 16, 15, 15, 15, 13, 13, 12, 11, 9, 8, 8, 8, 7, 6, 6, 6, 4, 4)
tau = 42
ri = tau - xi

sur = survfit(Surv(ri) ~ 1)
temp1 = outer(ti, sur$time, '<=')
temp2 = outer(ri, sur$time, '>=')
temp3 = temp1 & temp2
ni = apply(temp3, 2, sum)
surv = cumprod(1 - sur$n.event / ni)

di = rep(0, length(ri))
temp4 = outer(ri, ri, '==')
di[1] = sum(temp4[, 1])
for(i in 2:length(ri)) {
  if(all(temp4[, i] == temp4[, i - 1]))
    di[i] = 0
  else
    di[i] = sum(temp4[, i])
}

ni = rep(0, length(ri))
for(i in 1:length(ri))
  ni[i] = sum(ri[i] <= ri & ri[i] >= ti)
ni[which(di == 0)] = 0

surv_fun = rep(0, length(ri))
surv_fun[which(di != 0)] = round(surv, 4)

surv_fun[which(di == 0)] = ''
ni[which(di == 0)] = ''
di = ifelse(di == 0, '', di)
result = data.frame(ti, xi, ri, di, ni, surv_fun)
colnames(result) = c('  T_i', '  X_i', '  R_i', '  d_i', '  n_i', paste0('Pr(X < x_i|X <= ', tau, ')'))
result
####################################################################################################
## log-rank test
logRank = function(ti, ci, fun, alpha = 0.05) {
  eventTime = unique(ti)
  var = 0
  for(i in 1:length(eventTime)) {
    var = var + length(ti[ti == eventTime[i]]) * integrate(Vectorize(fun), 0, eventTime[i])$value
  }
  ts = (sum(ci) - var) ^ 2 / var
  cv = qchisq(1 - alpha, 1)
  pv = 1 - pchisq((sum(ci) - var) ^ 2 / var, 1)
  out = ifelse(pv < alpha, 'Reject', 'Not reject')
  return(data.frame(`test stat` = round(ts, 4), `critical value` = round(cv, 4), `p-value` = round(pv, 4), `decision` = out))
}

ti = c(8,8,8,8,4,4,4,4,4,4,2)
ci = as.integer(unlist(strsplit('01110101101', "")))
fun = function(t) {0.02 * t ^ 2}
logRank(ti, ci, fun)
####################################################################################################
## r-sample log-rank test
rSampleTest = function(data,R,method="logRank",alpha=0.05,print=1){
  G = length(data); out = as.list(rep(NA,G))
  names(R)=names(data)=names(out)=paste("group",1:G,sep=""); T=c()
  for(g in 1:G){
    data0=data[[g]]; R0=R[[g]]
    I=order(data0); data0=data0[I]; R0=R0[I]; t=data0[(1-R0)==1];
    t=t[!duplicated(t)]; N=length(t); n=d=c()
    for(i in 1:N){
      I=(data0==t[i]); R0[I]=c(rep(1,sum(I)-sum(R0[I])),rep(0,sum(R0[I])))
      n=c(n,sum(data0>=t[i])); d=c(d,sum(R0[I]))
    }
    temp=list(t,n,d); names(temp)=c("t","n","d"); out[[g]]=temp; T=c(T,t)
  }
  
  T=T[!duplicated(T)]
  for(g in 1:G){
    out0=out[[g]]; d0=n0=rep(NA,length(T))
    for(i in 1:length(T)){
      if(sum(T[i]==out0$t)==1){
        I=which(T[i]==out0$t); d0[i]=(out0$d)[I]; n0[i]=(out0$n)[I];
      }else{
        d0[i]=0; n0[i]=sum(data[[g]]>=T[i])
      }
    }
    out[[g]]$n=n0; out[[g]]$d=d0; out[[g]]$t=T; 
  }
  orderT=order(T)
  
  outALL = as.list(rep(NA,3)); names(outALL)=c("t","n","d")
  outALL$t=T ; outALL$n=outALL$d=rep(0,length(T))
  for(g in 1:G){ outALL$d=outALL$d+out[[g]]$d; outALL$n=outALL$n+out[[g]]$n }
  
  for(g in 1:G){
    w=outALL$d*out[[g]]$n/outALL$n; out[[g]]$w=w; 
    dmw=out[[g]]$d-out[[g]]$w; out[[g]]$dmw=dmw
  }
  
  table1 = cbind(outALL$t, outALL$n, outALL$d); 
  for(g in 1:G){ table1 = cbind(table1,out[[g]]$n,out[[g]]$d) }
  temp=c(matrix(c(paste("n",1:G,sep=""),paste("d",1:G,sep="")),nr=2,byrow=1))
  colnames(table1)=c("t","n","d",temp); rownames(table1)=rep("",length(T))
  
  for(g in 1:G){table1=cbind(table1,out[[g]]$w)}; 
  for(g in 1:G){table1=cbind(table1,out[[g]]$dmw)}
  colnames(table1)[(ncol(table1)-2*G+1):ncol(table1)]=c(paste("w",1:G,sep=""),paste("d",1:G,"-w",1:G,sep=""))
  table1=table1[orderT,]
  
  v_logRank=matrix(apply(as.matrix(table1[,(ncol(table1)-G+1):(ncol(table1)-1)]),2,sum),nc=1)
  v_wilcoxon=matrix(apply(matrix(table1[,2],nr=nrow(table1),nc=G-1,byrow=0)*table1[,(ncol(table1)-G+1):(ncol(table1)-1)],2,sum),nc=1)
  
  count=1; temp0Name=I=L=c()
  temp0=matrix(NA,nr=length(T),nc=G*(G+1)/2)
  for(i in 1:G){
    for(l in i:G){
      if(i==l){ 
        temp0[,count]=out[[i]]$n*(outALL$n-out[[i]]$n)*outALL$d*(outALL$n-outALL$d)/(outALL$n^2*(outALL$n-1))
      }else{
        temp0[,count]=-out[[i]]$n*out[[l]]$n*outALL$d*(outALL$n-outALL$d)/(outALL$n^2*(outALL$n-1))
      }
      count=count+1; temp0Name=c(temp0Name,paste("V",i,l,sep="")); I=c(I,i); L=c(L,l)
    }
  }
  temp0[is.na(temp0)]=0
  colnames(temp0)=temp0Name; rownames(temp0)=rep("",length(T)); table2=temp0; table2=table2[orderT,]
  V_logRank=V_wilcoxon=matrix(NA,nr=G,nc=G)
  temp_logRank =apply(table2,2,sum)
  temp_wilcoxon=apply(matrix(table1[,2],nr=nrow(table1),nc=G*(G+1)/2,byrow=0)^2*table2,2,sum)
  
  for(j in 1:length(I)){
    V_logRank[I[j],L[j]]=V_logRank[L[j],I[j]]=temp_logRank[j]
    V_wilcoxon[I[j],L[j]]=V_wilcoxon[L[j],I[j]]=temp_wilcoxon[j]
  }
  V_wilcoxon=V_wilcoxon[1:(nrow(V_wilcoxon)-1),1:(ncol(V_wilcoxon)-1)]
  V_logRank=V_logRank[1:(nrow(V_logRank)-1),1:(ncol(V_logRank)-1)]
  
  TS_logRank=t(v_logRank)%*%solve(V_logRank)%*%v_logRank
  TS_wilcoxon=t(v_wilcoxon)%*%solve(V_wilcoxon)%*%v_wilcoxon
  
  if(print==1){
    cat("*** Part I ***\n")
    print(table1)
    cat("*** Part II ***\n")
    print(table2)
  }
  
  if(method=="logRank"){
    TS=TS_logRank; pVal=1-pchisq(TS_logRank,G-1)
    out=list(method, v_logRank, V_logRank, TS_logRank, pVal,table1, table2)
    cat("\n******* Log-Rank Test *******\n"); 
  }else{
    TS=TS_wilcoxon; pVal=1-pchisq(TS_wilcoxon,G-1)
    out=list(method, v_wilcoxon, V_wilcoxon, TS_wilcoxon, pVal,table1, table2)
    cat("\n******* Wilcoxon Test *******\n");
  }
  names(out)=c("method", "v", "V", "TS", "pVal","table1", "table2")
  cat("Testing H0: h_i(t)=h_j(t) for all i,j,t\n")
  if(TS>qchisq(1-alpha,G-1)){
    cat(" * H0 is rejected at",100*alpha,"% -level.\n")
  }else{
    cat(" * H0 is not rejected at",100*alpha,"% -level.\n")
  }
  cat(" * p-value =",pVal,"\n*****************************\n")
  out
}

time1 = c(3,3,4,5)
time2 = c(3,4,4,5)
time3 = c(3,4,5,5,5)
cen1 = c(1,0,1,0)
cen2 = c(1,1,0,1)
cen3 = c(0,0,1,1,0)

ti = list(time1, time2, time3)
ci = list(1 - cen1, 1 - cen2, 1 - cen3)
grp = c()
for(i in 1:length(ti)) {
  for(j in 1:length(ti[[i]]))
    grp = c(grp, i)
  
}

data = data.frame(time = unlist(ti), censor = 1 - unlist(ci), group = grp)

# time = c(18, 9, 28, 31, 39, 19, 45, 6, 8, 15, 23, 28, 7, 12, 9, 8, 2, 26, 10, 4, 3, 4, 18, 8, 3, 14, 3, 13, 13, 35)
# censor = c(1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)
# group = c(1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 1, 3, 2, 2, 2, 4, 2, 4, 2, 2, 2, 4, 4, 4, 4, 2, 4, 4, 2)
# data = data.frame(time, censor, group)

survGroup = survdiff(Surv(data$time, data$censor) ~ data$group)
ts = round(survGroup$chisq, 4)
cv = round(qchisq(0.95, length(unique(data$group)) - 1), 4)
pv = 1 - round(pchisq(survGroup$chisq, length(unique(data$group)) - 1), 4)

## be aware the censor indicator is opposed
# out = rSampleTest(ti, ci, method = 'logRank', print = 1) # method = 'wilcoxon'
# out$TS
####################################################################################################
## cox-regression model
ti = c(5,7,9,5,6,7,8,4,5,7)
ci = as.integer(unlist(strsplit('1010101001', "")))
z = as.integer(unlist(strsplit('1112222333', "")))

phm = coxph(Surv(ti, ci) ~ factor(z), ties = 'efron') # ties = 'breslow' or 'exact'
summary(phm)

## test for partial parameters
#library(GlobalDeviance);data(Rossi);data = as.data.frame(Rossi[,1:10])
phm = coxph(Surv(week, 1 - arrest) ~ fin + age + race + wexp + mar + paro + prio + factor(educ), data = data, ties = 'efron') # ties = 'breslow' or 'exact'
summary(phm)

# remove manually, parameters that appear in reduced model
sub = !c(TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE)
# remove insignificant covariates where individual p-values greater than 0.05
# sub = !phm$coefficients / sqrt(diag(phm$var)) >= qnorm(0.975)

subPar = phm$coefficient[sub]
subVar = phm$var[sub, sub]
WT = t(subPar) %*% solve(subVar) %*% subPar
pv_WT = 1 - pchisq(WT, length(subPar))

phmSub = coxph(Surv(week, 1 - arrest) ~ fin + age + race + wexp + mar + paro + prio, data = data)
LRT = 2 * (phm$loglik[2] - phmSub$loglik[2])
pv_LRT = 1 - pchisq(LRT, length(phm$coefficients) - length(phmSub$coefficients))

initial = rep(0, length(phm$coefficients))
initial[!sub] = phmSub$coefficients
phmSco = coxph(Surv(week, 1 - arrest) ~ fin + age + race + wexp + mar + paro + prio + factor(educ), data = data, init = initial)
ST = phmSco$score
pv_ST = 1 - pchisq(phmSco$score, length(phm$coefficients) - length(phmSub$coefficients))

data.frame(testValue = round(c(WT, LRT, ST), 4), pv = round(c(pv_WT, pv_LRT, pv_ST), 4), row.names = c('Wald', 'Likelihood', 'Score'))

## confidence interval for relative risk
## be aware which model to use!
n = 1
m = 5
lRR = phmSub$coefficients[n] - phmSub$coefficients[m]
se = sqrt(phmSub$var[n, n] + phmSub$var[m, m] - 2 * phmSub$var[n, m])
me = qnorm(0.975) * se
c(exp(lRR - me), exp(lRR + me))

## hypothesis test for relative risk == 1
data.frame(testValue = lRR / se, cv = qnorm(0.975), pv = pnorm(lRR / se), decision = ifelse(pnorm(lRR / se) < 0.05, 'Reject', 'Not reject'))
####################################################################################################