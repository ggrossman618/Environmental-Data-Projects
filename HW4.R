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
# confermed with 

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
                     Max.Height.cm = c(60,100,11.8))

iris_join <- full_join(
  height,
  iris
)

iris_join


#####################################
##### Part 3: plots in ggplot2  #####
#####################################

#look at base R scatter plot
plot(iris$Sepal.Length,iris$Sepal.Width)

#3a. now make the same plot in ggplot

ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point() 

#3b. make a scatter plot with ggplot and get rid of  busy grid lines

ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point() + theme(panel.grid.major.x = element_blank()) + theme(panel.grid.major.y = element_blank()) + theme(panel.grid.minor.x = element_blank()) + theme(panel.grid.minor.y = element_blank()) 
 

#3c. make a scatter plot with ggplot, remove grid lines, add a title and axis labels, 
#    show species by color, and make the point size proportional to petal length

scatterplot <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color=Species))
scatterplot <- scatterplot + geom_point() + theme(panel.grid.major.x = element_blank()) 
scatterplot <- scatterplot + theme(panel.grid.major.y = element_blank()) 
scatterplot <- scatterplot + theme(panel.grid.minor.x = element_blank()) 
scatterplot <- scatterplot + theme(panel.grid.minor.y = element_blank()) 
scatterplot <- scatterplot + labs(title = "Iris Species Length vs Width",
                                  x = "Sepal Length", y = "Sepal Length") 
scatterplot <- scatterplot + geom_point(size = iris$Petal.Length) 

scatterplot #keeping this in so you can see all the changes to scatterplot


#####################################
##### Question: how did         #####
##### arguments differ between  #####
##### plot and ggplot?          #####
#####################################	

# Answered in document