# set the working directory + other stuff
setwd('Project 2/')
Data = read.csv('P2Data2020.csv')
source("Helper Functions.R")
Data$Y = as.factor(Data$Y)


## RF ##
fit.rf <- randomForest(data=Data, 
                      Y ~ ., 
                      importance=TRUE, 
                      keep.forest=TRUE)

### Is 500 enough trees???  Probably so.  
x11(h=7,w=6,pointsize=12)
plot(fit.rf)

round(importance(fit.rf),3) # Print out importance measures
x11(h=7,w=15)
varImpPlot(fit.rf) # Plot of importance measures; more interesting with more variables



## Log Reg ANOVA ##

rescale <- function(x1,x2){
  for(col in 1:ncol(x1)){
    a <- min(x2[,col])
    b <- max(x2[,col])
    x1[,col] <- (x1[,col]-a)/(b-a)
  }
  x1
}


data.train.scale = Data
data.train.scale[,-1] = rescale(data.train.scale[,-1], data.train.scale[,-1])

# fit a simple logistic regression
fit.log.nnet = multinom(Y ~ ., data = data.train.scale, maxit = 1000)

Anova(fit.log.nnet)




