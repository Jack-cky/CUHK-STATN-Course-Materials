#########################################################################################################
## Quadrature method
start_time<-Sys.time()
f<-function(x) {
  return(sin(pi*x)*((sin(pi*x^(2)))^(20)))
}

T1<-function(f,range,n){
  h<-diff(range)/n
  i<-1:n-1
  s<-0+i*h
  est<-(h/2)*(f(0)+2*sum(f(s))+f(1))
  return(est)}

T1(f,range=c(0,1),100000)                                        #find estimate for first part

g<-function(y) {
  return(sin(pi*y)*((sin(2*pi*y^(2)))^(20)))
}

T2<-function(g,range,n){
  h<-diff(range)/n
  i<-1:n-1
  s<-0+i*h
  est<-(h/2)*(g(0)+2*sum(g(s))+g(1))
  return(est)}

T2(g,range=c(0,1),100000)                                        #find estimate for second part

c<-1/(T1(f,range=c(0,1),100000)+T2(g,range=c(0,1),100000))       #find constant

c

EX1<-function(x) {
  return(x*sin(pi*x)*((sin(pi*x^(2)))^(20)))
}

T<-function(EX1,range,n){
  h<-diff(range)/n
  i<-1:n-1
  s<-0+i*h
  est<-(h/2)*(EX1(0)+2*sum(EX1(s))+EX1(1))
  return(est)}

T(EX1,range=c(0,1),100000)   #find estimate for first part

T2(g,range=c(0,1),100000)    #find estimate for second part

x<-function(x){x}            #find estimate for third part
integrate(x,0,1)

EX<-c*(T(EX1,range=c(0,1),100000)+T2(g,range=c(0,1),100000)*0.5)   #find E(X)
EX

EX2<-function(x) {
  return((x^2)*sin(pi*x)*((sin(pi*x^(2)))^(20)))
}

T<-function(EX1,range,n){
  h<-diff(range)/n
  i<-1:n-1
  s<-0+i*h
  est<-(h/2)*(EX2(0)+2*sum(EX2(s))+EX2(1))
  return(est)}

T(EX2,range=c(0,1),100000)   #find estimate for first part

T2(g,range=c(0,1),100000)    #find estimate for second part

x2<-function(x){x^2}         #find estimate for third part
integrate(x2,0,1)

EX2<-c*(T(EX2,range=c(0,1),100000)+T2(g,range=c(0,1),100000)*1/3)   #find E(X)^2
EX2

T1(f,range=c(0,1),100000)    #find estimate for first part

EY1<-function(y) {
  return(y*sin(pi*y)*((sin(2*pi*y^(2)))^(20)))
}

T<-function(EY1,range,n){
  h<-diff(range)/n
  i<-1:n-1
  s<-0+i*h
  est<-(h/2)*(EY1(0)+2*sum(EY1(s))+EY1(1))
  return(est)}

T(EY1,range=c(0,1),100000)  #find estimate for second part

y<-function(y){y}           #find estimate for third part
integrate(y,0,1)

EY<-c*(T(EY1,range=c(0,1),100000)+T1(f,range=c(0,1),100000)*0.5)  #find E(Y)
EY

T1(f,range=c(0,1),100000)    #find estimate for first part

EY2<-function(y) {
  return((y^2)*sin(pi*y)*((sin(2*pi*y^(2)))^(20)))
}

T<-function(EY2,range,n){
  h<-diff(range)/n
  i<-1:n-1
  s<-0+i*h
  est<-(h/2)*(EY2(0)+2*sum(EY2(s))+EY2(1))
  return(est)}

T(EY2,range=c(0,1),100000)  #find estimate for second part

y2<-function(y){y^2}        #find estimate for third part
integrate(y2,0,1)

EY2<-c*(T(EY2,range=c(0,1),100000)+T1(f,range=c(0,1),100000)*1/3)  #find E(Y)^2
EY2

EXY1<-(T(EX1,range=c(0,1),100000)*0.5)  #find estimate for first part
EXY1

EXY2<-(T(EY1,range=c(0,1),100000)*0.5)  #find estimate for second part
EXY2

EXY<-c*(EXY1+EXY2) #find E(XY)
EXY

VarX<-EX2-EX^2     #find Var(X)
VarX

VarY<-EY2-EY^2     #find Var(Y)
VarY

cov<-EXY-EX*EY     #find COV(X,Y)
cov

Corr<-cov/sqrt(VarX*VarY) #find Corr(X,Y)
Corr
end_time<-Sys.time()
end_time-start_time

#########################################################################################################
## Monte Carlo method
start_time<-Sys.time()
f<-function(x,y){
  sin(pi*x)*(sin(pi*x^2))^(20)+sin(pi*y)*(sin(2*pi*y^2))^(20)
}
n=100000
x=runif(n)
y=runif(n)
EX=mean(x*f(x,y))/mean(f(x,y))
EX^2
varX=mean(x^2*f(x,y))/mean(f(x,y))-EX^2
EY=mean(y*f(x,y))/mean(f(x,y))
EY^2
varY=mean(y^2*f(x,y))/mean(f(x,y))-EY^2
EXY=mean(x*y*f(x,y))/mean(f(x,y))
covXY=EXY-EX*EY
corr=covXY/sqrt(varX*varY)
end_time<-Sys.time()
end_time-start_time
#########################################################################################################