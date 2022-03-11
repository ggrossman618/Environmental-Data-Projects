#use built in iris dataset
#take a look at it 
head(iris)
#load in some tidyverse packages

#install.packages(c("dplyr"))
#install.packages(c("ggplot2"))

library(dplyr)
library(ggplot2)

#####################################
##### Part 1: for loops         #####
#####################################

#Using only data for iris versicolor
#write a for loop
#that produces a regression table
#for each of the following relationships
#1. iris  sepal length x width
#2. iris  petal length x width
#3. iris sepal length x petal length

# hint: consider using a list, and also new vectors for regression variables

versicolor <- iris[iris$Species == "versicolor", ]
firstCond <- list(versicolor$Sepal.Length, versicolor$Petal.Length, versicolor$Sepal.Length)
secondCond <- list(versicolor$Petal.Width, versicolor$Petal.Width, versicolor$Petal.Length)
regressionList <- list()

for(i in 1:3){
  regressionList[i] <- lm(unlist(firstCond[i]) ~ unlist(secondCond[i]))
}

regressionList


#####################################
##### Part 2: data in dplyr     #####
#####################################

#use dplyr to join data of maximum height
#to a new iris data frame
height <- data.frame(Species = c("virginica","setosa","versicolor"),
                     Height.cm = c(60,100,11.8))



#####################################
##### Part 3: plots in ggplot2  #####
#####################################

#look at base R scatter plot
plot(iris$Sepal.Length,iris$Sepal.Width)

#3a. now make the same plot in ggplot


#3b. make a scatter plot with ggplot and get rid of  busy grid lines


#3c. make a scatter plot with ggplot, remove grid lines, add a title and axis labels, 
#    show species by color, and make the point size proportional to petal length

#####################################
##### Question: how did         #####
##### arguments differ between  #####
##### plot and ggplot?          #####
#####################################	