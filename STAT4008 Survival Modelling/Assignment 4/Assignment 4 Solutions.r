###
#Q1
###
time = c(18,9,28,31,39,19,45,6,8,15,23,28,7,12,9,8,2,26,10,4,3,4,18,8,3,14,3,13,13,35)
status = c(1,1,0,1,0,0,0,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0)
x1 = c(0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
x2 = c(0,1,0,1,1,1,1,1,1,1,0,0,1,0,0,0,1,0,1,0,0,0,1,1,1,1,0,1,1,0)
survival_data = Surv(time, event = status)

#Non-parametric approach
survdiff(formula = survival_data ~ x1+x2)

#Semi-parametric approach
coxph(formula = survival_data ~ x1+x2)





###
#2a
###
set.seed(123457)
s<-sample(1:1601, size=1000)
Q4 = read.csv("ass4.csv")[s,]
colnames(Q4) = c("lstay", "age", "trt", "gender", "marstat", "hlstat", "cens")
t = Surv(Q4$lstay, 1-Q4$cens)
  age = Q4$age
  trt = Q4$trt
  gender = Q4$gender
  marstat = Q4$marstat
  hlstat2 = (Q4$hlstat==2)+0
  hlstat3 = (Q4$hlstat==3)+0
  hlstat4 = (Q4$hlstat==4)+0
  
 ### Step 1: Full Model
   m0 = coxph( t~age + trt + gender + marstat + hlstat2 + hlstat3 + hlstat4 )
   summary(m0)
 
 ### Step 2: Reduced Model
   m1 = coxph( t~            gender + marstat + hlstat2 + hlstat3)
   summary(m1)
   
 
   
   

###
#2b 
###

#Wald test
   x<-c(1,2,7)
   subpar<-m0$coefficient[x]
   subvar<-m0$var[x,x]
   subvarin<-solve(subvar)
   subwaldtest<-t(subpar)%*%subvarin%*%subpar
   subdf<-length(m0$coefficient)-length(m1$coefficient)
   rbind(c("sub-wald","df","pval"),c(subwaldtest,subdf,1-pchisq(subwaldtest,subdf)))

#Likelihood Ratio test
   LRtest<-2*(m0$loglik[2]-m1$loglik[2])
   df=length(m0$coefficient)-length(m1$coefficient)
   rbind(c("LR","df","pval"),c(LRtest,df,1-pchisq(LRtest,df)))
   
#Score test
   initial<-rep(0,7)
   xx<-c(3,4,5,6)
   initial[xx]<-m1$coefficient
   scoretest<-coxph( t~age + trt + gender + marstat + hlstat2 + hlstat3 + hlstat4,init=initial )
   df<-length(m0$coefficient)-length(m1$coefficient)
   rbind(c("score","df","pval"),c(scoretest$score,df,1-pchisq(scoretest$score,df)))
   
   
   
   
   
###
#2c
###
#The answer depends on the simplified model... 
   
#in the case simplified model do not include hlstat4 and hlstat5 and hazard ratio = 1 and No CI available, reduced model m1 is in this case.
#estimate of hazard ratio equals exp(coefficient of hlstat4 - coefficient of hlstat5) if the simplified model include both hlstat4 and hlstat5
#estimate of hazard ratio equals exp(                       - coefficient of hlstat5) if the simplified model include both just hlstat5
#estimate of hazard ratio equals exp(coefficient of hlstat4                         ) if the simplified model include both just hlstat4 
   
#for the CI, I give an example for the case where the simplified model include both hlstat4 and hlstat5
#further assume that 1) simp is the coxph() object containing the simplified model and 2) simp$coefficients[2] and simp$coefficients[3] equal to beta coefficient for hlstat4 and hlstat5 respectively
#Then the following code can output the confidence interval for the hazard ratio (Thank you a student in STAT4008 --- Su Di for providing the confidence interval solution for this particular case)
   alpha = 0.05
   status4 = simp$coefficients[2]
   status5 = simp$coefficients[3]
   var.status4 = simp$var[2,2]
   var.status5 = simp$var[3,3]
   cov.status45 = simp$var[2,3]
   diff = status4-status5
   var.diff = var.status4 + var.status5 - 2*cov.status45
   z = qnorm(1-alpha/2)
   diff.left = diff - z*sqrt(var.diff)
   diff.right = diff + z*sqrt(var.diff)
   left = exp(diff.left)
   right = exp(diff.right)
   cat('(',left,',',right,')')
   
