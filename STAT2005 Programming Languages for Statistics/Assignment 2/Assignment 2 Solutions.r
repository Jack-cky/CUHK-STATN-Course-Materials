# Q1a
plot(pressure$temperature,pressure$pressure)
curve((0.168 + 0.007*x)^(20/3), from = 0, to = 400, add = TRUE)

# Q1b
plot(pressure$temperature,(pressure$pressure)^(3/20))
# Linear relationship
abline(0.168,0.007)

# Q1c
plot(pressure$temperature,pressure$pressure, main = "Relationship between pressure and temperature")
curve((0.168 + 0.007*x)^(20/3), from = 0, to = 400, add = TRUE)

# Q1d
par(mfrow=c(1,2))
plot(pressure$temperature,pressure$pressure, bty='n', las=1)
curve((0.168 + 0.007*x)^(20/3), from = 0, to = 400, add = TRUE)
plot(pressure$temperature,(pressure$pressure)^(3/20), bty='n', las=1)
abline(0.168,0.007)


# Q2
alt_matrix <- function(n) {
	A = matrix(0, ncol = n, nrow = n)
	for (i in 1:n) {
		for (j in 1:n) {
			if ((i+j)%%2) 
			A[i,j] = 1
		}
	}
	return(A)
}

# alternative answer
alt_matrix <- function(n) {outer(1:n, 1:n, "+")%%2}
alt_matrix(9)


# Q3
d <- 1 # distance between lines
bl <- c(-d,0) # bottom left
br <- c(10,0) # bottom right
tl <- c(0,10) # top left
tr <- c(10,10) # top right
plot(0, 0, type="n", xlim=c(0,10), ylim=c(0,10), 
	bty="n", xlab="", ylab="")
phase <- 0
while (bl[1]<=br[1]) {
	phase <- (phase + 1)%%4
	if (phase == 1) { # bottom line: left to right
		segments(max(bl[1],0),bl[2],br[1],br[2], col="red")
		bl = bl + c(d,d)
	} else if (phase == 2) { # right line: bottom to top
		segments(br[1],br[2],tr[1],tr[2], col="orange")
		br <- br + c(-d,d)
	} else if (phase == 3) { # top line: right to left
		segments(tr[1],tr[2],tl[1],tl[2], col="green")
		tr <- tr + c(-d,-d)
	} else if (phase == 0) { # left line: top to bottom
		segments(tl[1],tl[2],bl[1],bl[2], col="blue")
		tl <- tl + c(d,-d)
	}
}

# Q4

# Version 1
prime_list <- function(n) {
	if (n >= 2) {
		comp <- seq(2, n)
		primes <- c()
		for (i in seq(2, n)) {
			if (any(comp == i)) {
				primes <- c(primes, i)
				comp <- comp[(comp %% i) != 0]
			}
		}
		return(primes)
	} else {
		stop("Input value of n should be at least 2.")
	}
}
twin_prime_list <- function(n) {
	if (n >= 5) {
		primes <- prime_list(n)
		tprimes <- c()
		for (i in 1:(length(primes)-1)) {
			if (primes[i+1] == primes[i]+2) {
				tprimes <- c(tprimes, primes[i], primes[i+1])
			}
		}
		return(unique(tprimes))
	} else if (n >= 3) {
		return(3)
	} else {
		stop("Input value of n should be at least 3.")
	}
}
twin_prime_list(1000)

# Version 2
twin_prime_list2 <- function(n) {
	if (n >= 5) {
		comp <- seq(2, n)
		primes <- c()
		tprimes <- c()
		for (i in seq(2, n)) {
			if (any(comp == i)) {
				primes <- c(primes, i)
				comp <- comp[(comp %% i) != 0]
				l <- length(primes)
				if (l>=2) {
					if (primes[l] == primes[l-1]+2) {
						tprimes <- c(tprimes, primes[l-1], primes[l])
					}
				}
			}
		}
		return(unique(tprimes))
	} else if (n >= 3) {
		return(3)
	} else {
		stop("Input value of n should be at least 3.")
	}
}
twin_prime_list2(1000)
