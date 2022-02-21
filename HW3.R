#create a function. The names of the arguments for your function will be in parentheses. Everything in curly brackets will be run each time the function is run.

#read data to variable datW
datW <- read.csv("Z:/students/ggrossman/data/bewkes_weather/bewkes_weather.csv",
                 na.strings=c("#N/A"), skip=3, header=FALSE)

#preview data
print(datW[1,])

assert <- function(statement,err.message){
  #if evaluates if a statement is true or false for a single item
  if(statement == FALSE){
    print(err.message)
  }
  
}

#check how the statement works
#evaluate a false statement
assert(1 == 2, "error: unequal values")

#evaluate a true statement
assert(2 == 2, "error: unequal values")

#nested functions 
a <- c(1,2,3,4)
b <- c(8,4,5)
assert(length(a) == length(b), "error: unequal length")
