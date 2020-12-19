set.seed(2001)
repeat{
  a1 = sample(1:100,1)
  a2 = 70 - a1
  a3 = sample(1:100,1)
  a4 = 30 - a3
  
  b1 = sample(1:218,1)
  b2 = 174 - b1
  b3 = sample(1:218,1)
  b4 = 44 - b3
  
  pa = a1 + a2
  sa = a1 + a3
  nsa = a2 + a4
  ta = a1 + a2 + a3 + a4
  
  pb = b1 + b2
  sb = b1 + b3
  nsb = b2 + b4
  tb = b1 + b2 + b3 + b4
  
  c1 = a1/sa > b1/sb
  c2 = a2/nsa > b2/nsb
  c3 = pa/ta < pb/tb
  c4 = all(a1 > 0, a2 > 0, a3 > 0, a4 > 0, b1 > 0, b2 > 0, b3 > 0, b4 > 0)
  
  if(all(c1, c2, c3, c4))
    break
}
data.frame(c(a1, a2, a3, a4, ta), c(b1, b2, b3, b4, tb))

(a1 + a2) / ta
(b1 + b2) / tb
a1 / sa
b1 / sb
a2 / nsa
b2 / nsb