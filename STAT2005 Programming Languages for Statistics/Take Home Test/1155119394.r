# Question 1
my_det = function(x) {
  
  # get the dimension of the input matrix
  r = nrow(x)
  c = ncol(x)
  
  # initial determinant as 0
  det = 0
  
  # check if it is a square matrix
  if(r != c)
    stop("Input matrix is not a square matrix.")
  
  # a case if the matrix is 1 by 1
  else if(r == 1)
    det = x[1,1]
  
  # return the determinant for 2 by 2 matrix
  else if(r == 2)
    det = x[1,1] * x[2,2] - x[1,2] * x[2,1]
  
  # use a recursive function to calculate determinant if the matrix is large than 2 by 2
  else
    for(i in 1:r)
      det = det + (-1) ^ (i + 1) * x[1, i] * my_det(x[-1,-i])
  
  # return determinant
  return(det)
}


# Question 2
secant = function(f, x0, x1, n, err) {
  
  for(i in 1:n) {
    
    # calculate x2
    x2 = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
    
    # check if x2 - x1 is small enough
    if(abs(x2 - x1) < err)
      
      # x2 if the root and i is the number of iterations
      return(c(x2, i))
    
    # update values of x0 and x1
    x0 = x1                                                                                                                                    
    x1 = x2
  }
}

fx = function(x) {
  3 * exp(-x * 0.5) + 3 * exp(-x * 1) + 3 * exp(-x * 1.5) + 103 * exp(-x * 2) - 98.39
}

secant(fx, 0.0001, 1, 1000, 1e-5)

# it returns 0.06759816 6.00000000
# thus, the root is 0.06759816
# the number of iterations needed for secant is 6
# recap the bisection method, bisection(fx,0.0001,1,1000,10^-5)
# it return 0.06759813 and it needs 12 times of iteration
# although there is very insignificatant different 3e-08,
# secant method calculates faster as it loops for lesser times