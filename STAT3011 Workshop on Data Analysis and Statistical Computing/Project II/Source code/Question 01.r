#########################################################################################################
## Bisection
f.dev <- function(x){
  (1+2*x)/((x+x^2)*(1+x^3))- log(x+x^2)*(3*x^2)/(1+x^3)^2
}
curve(f.dev, xlim=c(0.5,2), col='red', lwd=1.5, lty=2)
abline(h=0)

bisection <- function(f.dev, a, b, z=0.001) {
  if(f(a)*f(b)>0)
    list(fail="fail to find root")
  else{
    repeat{
      if(abs(b-a)<z) break
      x<-(a+b)/2
      if(f(a)*f(x)<0) b<-x else a<-x
    }
    list(root=(a+b)/2,func=f(x))
  }
}
f <- function(x){
  (1+2*x)/((x+x^2)*(1+x^3))- log(x+x^2)*(3*x^2)/(1+x^3)^2
}
bisection(f,0.5,2)
x<-1.123657
log(x+x^2)/(1+x^3)

#########################################################################################################
## Newton Raphson
func <- function(x) {
  (log(x+x^2))/(1+x^3)
}

curve(func, xlim=c(-10,10), col='black', lwd=2, lty=2, ylab='f(x)')
abline(h=0)
abline(v=0)

f <- function(x){
  (2 * x + 1 ) / ((x^2 + x) * (x^3 + 1)) - ((3 * x^2 * log(x^2 + x)) / (x^3 + 1)^2)
}

#first derivative f'(x)
fdev <- function(x){
  (2 / (x + x^2) - (1 + 2*x) * (1 + 2 * x) / ( x + x^2)^2) / (1 + x^3) - (1 + 2 * x) / (x + x^2) * (3 * x^2) / (1 + x^3)^2 - (((1 + 2 * x) / (x + x^2) * (3 * x^2) + log(x + x^2) * (3 * (2 * x))) / (1 + x^3)^2 - log(x + x^2) * (3 * x^2) * (2 * (3 * x^2 * (1 + x^3))) / ((1 + x^3)^2)^2)
}
x<-0.5
tol<-1e-5
root<- function(f, f.dev, x, tol){
  y=x
  while(abs(f(y)) > tol){
    y = y - f(y)/f.dev(y)
  }
  return(y)
}
root(f, fdev, x, tol)
x<-1.123312
log(x + x^2) / (1 + x^3)
#########################################################################################################