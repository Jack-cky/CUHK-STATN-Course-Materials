################################################################################

# define basic parameters
n <- 10
m <- 100
lb <- 0
ub <- 10
probCrossover <- 0.9
probMutatuin <- 0.5
set.seed(3011)

################################################################################

# objective function
f <- function(x) {
  # throw an exception: product of x >= 0.75
  if(prod(x) < 0.75)
    return(0)
  else
    return(abs((sum(cos(x) ^ 4) - 2 * prod(cos(x) ^ 2)) / sqrt(sum(x ^ 2 * 1:n))))
}

################################################################################

compare <- function(){
  return(c(max(fitnessEval(initialPopulation)), max(fitnessEval(x)), mean(fitnessEval(initialPopulation)), mean(fitnessEval(x))))
}

################################################################################

# original population
initialPopulation <- matrix(runif(n * m, lb, ub), nr = n, nc = m)
rownames(initialPopulation) <- paste0("Cromosome", 1:n)
colnames(initialPopulation) <- paste0("Solution", 1:m)

################################################################################

# evaluate the fitness score
fitnessEval <- function(population) {
  
  fitness <- c()
  
  for(i in 1:ncol(population)) {
    fitness <- c(fitness, f(population[, i]))
  }
  
  return(fitness)
}

################################################################################

# sort fitness
fitnessSort <- function(population) {
  
  fitness <- fitnessEval(population)
  return(population[, order(fitness)])
  
}

################################################################################

# selection from population
selection <- function(population) {
  population <- fitnessSort(population)
  fitness <- fitnessEval(population)
  probSelect <- fitness / sum(fitness)
  cumProbSelect <- cumsum(probSelect)
  
  bestSol <- population[, (m * 0.8):m]
  
  ran <- runif(m * 0.8, 0, 1)
  index <- c()
  
  for(i in 1:(m * 0.8)) {
    for(j in 1:m) {
      if(ran[i] <= cumProbSelect[j]) {
        index <- c(index, j)
        break
      }
    }
  }
  
  newSelectionPopulation <- bestSol
  for(i in 1:(m * 0.8 - 1)) {
    newSelectionPopulation <- cbind(newSelectionPopulation, population[, index[i]])
  }
  
  newSelectionPopulation <- fitnessSort(newSelectionPopulation)
  
  rankSelect <- fitnessSort(newSelectionPopulation[, sample(1:m, replace = T, prob = probSelect)])
    
  newSelectionPopulation <- cbind(rankSelect[, 1:(m - 1)], newSelectionPopulation[, m])
  
  colnames(newSelectionPopulation) <- paste0("Solution", 1:m)
  
  return(newSelectionPopulation)
}

x=selection(initialPopulation)
compare()

################################################################################

# crossover from population
crossover <- function(population, probCrossover) {
  sexPartner <- sample(1:m)
  population <- population[, sexPartner]
  newCrossoverPopulation <- c()
  
  for(i in seq(1, m, 2)) {
    flag <- sample(c(0,1), 1, prob = c(1 - probCrossover, probCrossover))
    if(flag == 1)
      newCrossoverPopulation <- cbind(newCrossoverPopulation, crossoverADT(population[, i:(i + 1)]))
    else
      newCrossoverPopulation <- cbind(newCrossoverPopulation, population[, i:(i + 1)])
  }
  
  # survive solutions from previous generation
  surviveSol <- fitnessSort(population)[, (m * 0.9 + 1):m]
  newCrossoverPopulation <- cbind(fitnessSort(newCrossoverPopulation)[, (m * 0.1 + 1):m], surviveSol)
  
  colnames(newCrossoverPopulation) <- paste0("Solution", 1:m)
  rownames(newCrossoverPopulation) <- paste0("Cromosome", 1:n)
  return(newCrossoverPopulation)
}

crossoverADT <- function(population) {
  
  iter <- 0
  
  repeat {
    index <- sample(1:(n - 1), 1)
    
    sol1_vector <- population[1:index, 1]
    sol1_vector2 <- population[(index + 1):n, 1]
    
    sol2_vector <- population[1:index, 2]
    sol2_vector2 <- population[(index + 1):n, 2]
    
    newSol <- c(sol1_vector, sol2_vector2)
    newSol2 <- c(sol2_vector, sol1_vector2)
    
    if(all(prod(newSol) >= 0.75 & prod(newSol2) >= 0.75))
      break
    else
      iter = iter + 1
    if(iter > 20)
      return(population)
  }
  return(cbind(newSol, newSol2))
}

x = crossover(x, probCrossover)
compare()

################################################################################

# mutation of population
mutation <- function(population, probMutatuin) {
  
  newMutationPopulation <- fitnessSort(population)
  for(i in 1:(m - 1)) {
    #i=1
    flag <- sample(c(0,1), 1, prob = c(1 - probMutatuin, probMutatuin))
    if(flag == 1) {
      post <- sample(1:n,1)
      repeat {
        for(j in 1:post) {
          index <- sample(1:n, 1)
          newMutationPopulation[index, i] <- runif(1, lb, ub)
        }
        if(prod(newMutationPopulation[, i]) >= 0.75)
          break
      }
    }
  }
  
  # survive solutions from previous generation
  surviveSol <- fitnessSort(population)[, (m * 0.9 + 1):m]
  newMutationPopulation <- cbind(fitnessSort(newMutationPopulation)[, (m * 0.1 + 1):m], surviveSol)
  
  return(newMutationPopulation)
}

x = mutation(x, probMutatuin)
compare()

################################################################################

x <- mutation(crossover(selection(initialPopulation), probCrossover), probMutatuin)
maxX <- c()
meanX <- c()
for(i in 1:2000){
  x <- mutation(crossover(selection(x), probCrossover), probMutatuin)
  maxX <- c(maxX,max(fitnessEval(x)))
  meanX <- c(meanX, mean(fitnessEval(x)))
  print(paste0("Loop", i," Finish"))
}

compare()

plot(maxX)
plot(meanX)

################################################################################