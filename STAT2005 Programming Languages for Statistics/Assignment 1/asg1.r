# Question 1
# (a)
# a sequence from 10 to 30 increases by 2
seq(10, 30, 2)

# (b)
# a sequence from 1 to 5 for which each element increases with a vector from 0 to 4
1:5 + rep(0:4, each = 5)


# Question 2
# (a)
# create "roots" with roots of 5*x^5+4*x^4+3*x^3+2*x^2+x=0 using polyroot() 
roots <- polyroot(0:5)

# (b)
# the mode of "roots" is complex
mode(roots)

# (c)
# use Im() to extract the imaginary part of "roots"
# use order() to sort by value in "Im(roots)"
# rearrange the order and reassign to "roots"
roots <- roots[order(Im(roots))]


# Question 3
# given information
suits <- c("D","C","H","S")
ranks <- 2:14
deck <- matrix(, nrow = 52, ncol = 2)
colnames(deck) = c("suit", "rank")
deck <- as.data.frame(deck)
deck$suit <- rep(suits, 13)
deck$rank <- rep(ranks, 4)

# (a)
# data frame "deck" has 2 variables (aka columns)
# "suit" contains a vector of the types of the card in character data type
# "rank" contains a vector of the values of the card in numeric data type
# observations (aka rows) represent cards with its own types and values

# (b)
# create "hand" and use sample() to select 5 cards from "deck"
hand <- deck[sample(52, 5),]

# (c)
# get the numbers of type from "hand$suit" with unique() and length()
# test if "hand$suit" has only one type
# from (e)
# to avoid duplication from straight flush, negate the logical value from (d)
is.flush <- length(unique(hand[,1])) == 1 & !(all(hand[order(hand[, 2]), 2] - min(hand[, 2]) + 1 == 1:5 | hand[order(hand[, 2]), 2] - min(hand[, 2]) + 1 == c(1:4, 13)))

# (d)
# sort "hand" by "rank" and subtract from the smallest value using min()
# +1 to convert the numeric vector to a range
# test if it follows with a sequence from 1 to 5, which means cards follows a sequential
# again, test if it follows with a sequence from 1 to 4 and 13, in a case that Ace is the smallest card in the sequence
# use all() to convert the above vector to a single logical value
# from (e)
# to avoid duplication from straight flush, negate the logical value from (c)
is.straight <- all(hand[order(hand[, 2]), 2] - min(hand[, 2]) + 1 == 1:5 | hand[order(hand[, 2]), 2] - min(hand[, 2]) + 1 == c(1:4, 13)) & !(length(unique(hand[,1])) == 1)

# (e)
# test if (c) and (d) happen at the same time
is.straightflush <- length(unique(hand[,1])) == 1 & (all(hand[order(hand[, 2]), 2] - min(hand[, 2]) + 1 == 1:5 | hand[order(hand[, 2]), 2] - min(hand[, 2]) + 1 == c(1:4, 13)))


# Question 4
# (a)
# create "n" and assign sample size 100
n <- 100

# create "Z" and get "n" samples from the standard normal distribution using rnorm()
Z <- rnorm(n)
# create "X" and construct a vector with a cumulative sum of "Z" from 0
X <- c(0, cumsum(Z))

# create "W" and get "n" samples from the standard normal distribution using rnorm()
W <- rnorm(n)
# create "Y" and construct a vector with a cumulative sum of "W" from 0
Y <- c(0, cumsum(W))

# plot a graph with variable "X" and "Y" in lines
plot(X, Y, type = "l")

# (b)
# (i)
# create "r" and assign with -0.5 population correlation coefficient
r <- -0.5

# create "U" and get values from r * Z + sqrt(1 - r ^ 2) * W
U <- r * Z + sqrt(1 - r ^ 2) * W

# plot a normal QQ plot using qqnorm()
qqnorm(U)
# plat a reference line about the values in "U" using qqline()
qqline(U)

# there is a close to 45 degree straight line
# the random variable "U" seems to be normally distributed

# calculate the mean of "U" using mean()
mean(U)

# sample mean close to 0
# it seems to be a good estimate about the population mean

# calculate the variance of "U" using var()
var(U)

# sample mean close to 1
# it seems to be a good estimate about the population variance

# calculate the sample correlation coefficient using cor()
cor(Z, U)

# sample correlation coefficient close to -0.5
# it seems to be a good estimate about the population correlation coefficient

# thus, random variable "U" is likely to be normally distributed

# (ii)
# reassign "r" with 0.99 population correlation coefficient
r <- 0.99

# recalculate values from r * Z + sqrt(1 - r ^ 2) * W
U <- r * Z + sqrt(1 - r ^ 2) * W

# create "Yn" and construct a vector with a cumulative sum of "U" from 0
Yn <- cumsum(c(0, U))

# plot a graph with variable "X" and "Yn" in lines
plot(X, Yn, type = "l")

# it follows a close to 45 degree straight line and plots somehow, which is expected
# with 0.99 population correlation coefficient, "X" and "Yn" is positively associated
# the variability of "X" and "Yn" is much smaller compared to (a)