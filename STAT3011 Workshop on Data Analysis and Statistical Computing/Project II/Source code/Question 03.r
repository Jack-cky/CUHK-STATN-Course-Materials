#########################################################################################################
## Quadrature method

start_time<-Sys.time()
f<-function(x){return(abs(cos(x))/x*exp(-(log(x)-3)^2))}
trapezoidalRule<-function(f,range,n){
  h<-diff(range)/n
  i<-range[1]+h*(0:n)
  return(h/2*(f(range[1]+f(range[2]))+2*sum(f(i[-1][-(n+1)]))))}
trapezoidalRule(f,range=c(0,1000),n=1e6)
end_time<-Sys.time()
end_time-start_time

#########################################################################################################
## Monte Carlo method

set.seed(0)
start_time<-Sys.time()
f<-function(x){abs(cos(x))*sqrt(pi)}
p<-function(x){1/(sqrt(pi)*x)*exp(-(log(x)-3)^2)}#pdf
x<-rlnorm(100000,3,sqrt(1/2))
result<-mean(f(x))
result
end_time<-Sys.time()
end_time-start_time
#########################################################################################################