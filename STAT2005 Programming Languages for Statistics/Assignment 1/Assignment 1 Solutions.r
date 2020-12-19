# Q1a
seq(10, 30, by=2)

# Q1b
1:25-rep(seq(0,16, by=4), rep(5,5))


# Q2a
roots <- polyroot(0:5)

# Q2b
mode(roots)

# Q2c
roots[order(Im(roots))]


# Q3
suits <- c("D","C","H","S")
# D = ♦ Diamond, C = ♣ Club, H = ♥ Heart, S = ♠ Spade
ranks <- 2:14
# 11 = Jack, 12 = Queen, 13 = King, 14 = Ace

deck <- matrix(, nrow = 52, ncol = 2)
colnames(deck) = c("suit", "rank")
deck <- as.data.frame(deck)
deck$suit <- rep(suits, 13)
deck$rank <- rep(ranks, 4)

# Q3a
# deck is a data frame with 52 observations and 2 variables
# each row represent a playing card
# the first column is the suit of card
# the second column is the rank of card

# Q3b
hand <- deck[sample(52, size = 5, replace=F),]
# hand <- deck[1:5,] # straight 2,3,4,5,6
# hand <- deck[c(1:4, 13),] # straight A,2,3,4,5
# hand <- deck[c(17,9,1,49,41),] # flush 
# hand <- deck[c(6,46,34,22,10),] # straight flush

# Q3c
is.flush <- length(unique(hand$suit)) == 1

# Q3d
min_rank <- min(hand$rank)
is.straight <- all(sort(hand$rank) == seq(min_rank, min_rank+4))|all(sort(hand$rank) == c(2,3,4,5,14))

# Q3e
(is.straightflush <- is.flush & is.straight)
(is.flush <- is.flush & !is.straightflush)
(is.straight <- is.straight & !is.straightflush)


# Q4a
n <- 100
z <- rnorm(n,0,1)
w <- rnorm(n,0,1)
x <- cumsum(c(0,z))
y <- cumsum(c(0,w))
plot(x,y, type="l")

# Q4bi
rho <- -0.5
u <- rho*z + sqrt(1-rho^2)*w
qqnorm(u)
qqline(u, col="red")
mean(u)
var(u)
cor(u,z)

# Q4bii
rho <- 0.99
u <- rho*z + sqrt(1-rho^2)*w
x <- cumsum(c(0,z))
y <- cumsum(c(0,u))
plot(x,y, type="l")
