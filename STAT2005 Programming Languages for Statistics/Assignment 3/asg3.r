# Question 1
questionnaire <- function() {
  
  # create "Name", "Age", and "Gender" as the variables in data frame
  Name <- NULL
  Age <- NULL
  Gender = NULL

  # loop until no more entry
  repeat {

    # get name from first question
    name <- readline(prompt = "Question 1: What's your name? : ")
    
    repeat {
      # get age from second question
      age <- as.numeric(readline(prompt = "Question 2: What's your age? <integer required>: "))
      
      # check input validity
      if(!is.na(age) & age %% 1 == 0)
        break
      else
        cat("Please input integer.")
    }
    
    repeat {
      # get gender from third question
      gender <- toupper(as.character(readline(prompt = "Question 3: What's your gender? <M/F>: ")))
      
      # check input validity
      if(gender == "M" | gender == "F")
        break
      else
        cat("Please input M or F.")
    }

    repeat {
      # ask user if there is new record
      newRecord <- toupper(readline(prompt = "New entry? <Y/N>: "))
      
      # check input validity
      if(newRecord == "Y" | newRecord == "N")
        break
      else
        cat("Please input Y or N.")
    }
    
    # merge data to data frame variable
    Name <- c(Name, name)
    Age <- c(Age, age)
    Gender <- c(Gender, gender)
    
    # end of looping
    if(newRecord == "N")
      break
  }
  
  # create "df" storing variables
  df <- data.frame(Name, Age, Gender)
  
  # output statistical analysis
  cat("The average age is", mean(df$Age), "from", nrow(df), "respondents.\n")
  
  # plot a pie chart by number of gender
  pie(table(df$Gender), clockwise = T, col = c("Light Blue", 0))
  
  return(df)
}

data <- questionnaire()


# Question 2
# transition probability matrix
T <- matrix(c(0.5, 0.2, 0.3, 0.3, 0.4, 0.3, 0.4, 0.3, 0.3), nr = 3, byr = T)

# (a)
# assume TV is off at first
t <- c(0, 0, 1)

# calculate the 2‐step transition
n <- 2
for(i in 1:n)
  t <- t %*% T
t

# the 2‐step transition is (0.41, 0.29, 0.3) ^ T

# (b)
# assume TV is off at first
t <- c(0, 0, 1)

# calculate the transition at 15:00
n <- 15 - 9
for(i in 1:n)
  t <- t %*% T
t

# the 2‐step transition is (0.412496, 0.287504, 0.3) ^ T

# (c)
# strategy 1
# given information
T <- matrix(c(0.45, 0.25, 0.3, 0.3, 0.4, 0.3, 0.4, 0.3, 0.3), nr = 3, byr = T)

# assume TV is off at first
t <- c(0, 0, 1)

# calculate the 8‐step transition
n <- 8
for(i in 1:n)
  t <- t %*% T
t

# the final transition for strategy 1 is (0.3882353, 0.3117647, 0.3) ^ T

# strategy 2
T <- matrix(c(0.5, 0.2, 0.3, 0.3, 0.4, 0.3, 0.4, 0.35, 0.25), nr = 3, byr = T)

# assume TV is off at first
t <- c(0, 0, 1)

# calculate the 8‐step transition
n <- 8
for(i in 1:n)
  t <- t %*% T
t

# the final transition for strategy 1 is (0.410714, 0.3035717, 0.2857143) ^ T

# in strategy 1, switching to Channel 2 has a higher probability (0.3117647 > 0.3035717)
# thus, strategy 1 is more preferable