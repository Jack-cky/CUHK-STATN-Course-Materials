# Q1
questionnaire <- function() {
	data <- matrix(, nrow = 0, ncol = 3)
	colnames(data) = c("Name", "Age", "Gender")
	data <- as.data.frame(data)
	cat("Please respond to the following three questions.\n\n")
	n <- 1
	repeat {
		cat("Question 1: What's your name? : ")
		data[n,1] <- readline()
		repeat {
			cat("Question 2: What's your age? <integer required>: ")
			inp <- readline()
			inp <- as.numeric(inp)
			if (is.na(inp) == TRUE) {
				cat("Please input integer.\n")
				next
			}
			if (trunc(inp) != inp) {	
				cat("Please input integer.\n")
				next
			}
			data[n,2] <- inp
			break
		}
		repeat {
			cat("Question 3: What's your gender? <M/F>: ")
			inp <- toupper(readline())
			if ((inp == "M")|(inp == "F")) {
				data[n,3] <- inp
				break
			} else {
				cat("Please input M or F.\n")
			}
		}
		repeat {
			cat("New entry? <Y/N>: ")
			inp <- toupper(readline())
			if ((inp == "Y")|(inp == "N")) {
				break
			} else {
				cat("Please input Y or N.\n")
			}
		}
		if (inp == "Y") {
			n <- n+1
			next
		} else {
			break
		}
	}
	cat("The average age is", mean(data$Age),"from", n, "respondents.\n")
	m <- sum(data$Gender == "M")
	pie(c(m/n,1-m/n), labels = c("M", "F"), init.angle = 90)
	return(data)
}


# Q2a
T<-matrix(c(0.5,0.2,0.3,0.3,0.4,0.3,0.4,0.3,0.3),nrow=3,byrow=T)	
T%*%T

# Q2b
T6 <- diag(3)
for (i in 1:6) {
	T6 <- T6 %*% T
}
T6[1,1]

# Q2c
# Strategy 1
T_S1<-matrix(c(0.45,0.25,0.3,0.3,0.4,0.3,0.4,0.3,0.3),nrow=3,byrow=T)
eig1<-eigen(t(T_S1))
(eig1$vectors[,1]/sum(eig1$vectors[,1]))[2]

# Strategy 2
T_S2<-matrix(c(0.5,0.2,0.3,0.3,0.4,0.3,0.4,0.35,0.25),nrow=3,byrow=T)
eig2<-eigen(t(T_S2))
(eig2$vectors[,1]/sum(eig2$vectors[,1]))[2]

# Stragegy 1 is better.