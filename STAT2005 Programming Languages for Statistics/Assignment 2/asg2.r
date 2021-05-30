# Question 1
# (a)
# plot a graph pressure against temperature from built-in data frame
plot(pressure ~ temperature, data = pressure)

# given command
curve((0.168 + 0.007 * x) ^ (20 / 3), from = 0, to = 400, add = TRUE)

# from (c) title the graph
title("Relationship between pressure and temperature")


# (b)
# plot a graph pressure ^ (3 / 20) against temperature from built-in data frame
plot(pressure ^ (3 / 20) ~ temperature, data = pressure)

# plot a straight line with intercept 0.168 and slope 0.007
abline(0.168, 0.007)

# the modified pressure and the temperature are positively linear associated

# from (c) title the graph
title("Relationship between pressure ^ (3 / 20)  and temperature")

# (c)
# please see the above solutions

# (d)
# set up a 1 by 2 multi-frame for graphs; suppresses the box; display axis in horizontal
par(mfrow = c(1, 2), bty = "n",las = 1)

# from (a)
plot(pressure ~ temperature, data = pressure)
curve((0.168 + 0.007 * x) ^ (20 / 3), from = 0, to = 400, add = TRUE)
title("Relationship between pressure and temperature")

# from (b)
plot(pressure ^ (3 / 20) ~ temperature, data = pressure)
abline(0.168, 0.007)
title("Relationship between pressure ^ (3 / 20)  and temperature")


# Question 2
alt_matrix <- function(n) {
  
  # check user input
  if(n < 0)
    stop("Invalid Input")
  
  # create an n by n matrix with value 1 in each entity
  m <- matrix(rep(1, n * n), nr = n, nc = n)
  
  # avoid looping from 0 in a case of 0 by 0 matrix
  if(n > 0)
    
    # loop through each elements in the matrix
    for(i in 1:n)
      for(j in 1:n)
        
        # convert value to 0 for odd rows with odd columns and even rows with even columns
        if(i %% 2 == 1 & j %% 2 == 1)
          m[i, j] <- 0
        else if(i %% 2 == 0 & j %% 2 == 0)
          m[i, j] <- 0
  
  # return matrix
  m
}


# Question 3
# plot a blank graph with 0 to 10 in x-axis and y-axis
plot(0, 0, type = "n", xlim = c(0, 10), ylim = c(0, 10), bty = "n", xlab = "", ylab = "")

# plot the base horizontal line in "red"
lines(c(0,10), c(0, 0), col = "red")

for(i in 0:4) {
  
  # plot 5 horizontal lines in "red" colour
  lines(c(i, 9 - i), c(1 + i, 1 + i), col = "red")
  
  # plot 5 vertical lines in "orange" colour
  lines(c(6 + i, 6 + i), c(4 - i, 6 + i), col = "orange")
  
  # plot 5 horizontal lines in "green" colour
  lines(c(4 - i, 6 + i), c(6 + i, 6 + i), col = "green")
  
  # plot 5 vertical lines in "blue" colour
  lines(c(i, i), c(1 + i, 10 - i), col = "blue")
}


# Question 4
# find all the prime numbers less than 1000
n <- 1000

# create "p" as a temporary variable for storing the prime numbers
p <- NULL

# loop from 2 to "n" to be the dividend
for(i in 2:n) {
  
  # initialise a "flag" to be TRUE for each loop
  flag <- TRUE
  
  # loop from 2 to "n" to be the divisor
  for(j in 2:n)
    
    # check if the dividend can be factorised by the divisor
    if(i %% j == 0 & i != j) {
      
      # turn the "flag" to be FALSE for non-prime numbers
      flag <- FALSE
      
      # (optional) you know, be effective
      break
    }
  
  # store prime numbers into "p" if it passes above restrictions
  if(flag == TRUE)
    p <- c(p, i)
}

# create "z" as a vector for storing twin prime
z <- NULL

# use a nested loop to find twin prime
for(i in p)
  for(j in p)
    
    # store twin prime values to "z"
    if(j == i + 2) {
      z = c(z, i, j)
      
      # (optional) you know, be effective
      break
  }

# extract only non duplicated twin prime
unique(z)