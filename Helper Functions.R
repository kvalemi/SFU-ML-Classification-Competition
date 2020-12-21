library(FNN)
library(nnet)   # For logistic regression
library(car)    # For ANOVA after logistic regression with nnet
library(glmnet) # For logistic regression and LASSO
library(MASS)   # For discriminant analysis
library(klaR)   # For naive Bayes
library(rpart)        # For fitting classification trees
library(rpart.plot)   # For plotting classification trees
library(randomForest) # For random forests
library(gbm)          # For boosting
library(nnet)  
library(e1071)    # For SVM
library(caret)    # For tuning
library(kernlab)  # For SVM with caret


### We will regularly need to shuffle a vector. This function
### does that for us.
shuffle = function(X){
  new.order = sample.int(length(X))
  new.X = X[new.order]
  return(new.X)
}

### We will also often need to calculate MSE using an observed
### and a prediction vector. This is another useful function.
get.MSPE = function(Y, Y.hat){
  return(mean((Y - Y.hat)^2))
}

### Create k CV folds for a dataset of size n
get.folds = function(n, K) {
  ### Get the appropriate number of fold labels
  n.fold = ceiling(n / K) # Number of observations per fold (rounded up)
  fold.ids.raw = rep(1:K, times = n.fold) # Generate extra labels
  fold.ids = fold.ids.raw[1:n] # Keep only the correct number of labels
  
  ### Shuffle the fold labels
  folds.rand = fold.ids[sample.int(n)]
  
  return(folds.rand)
}


rescale <- function(x1,x2){
  for(col in 1:ncol(x1)){
    a <- min(x2[,col])
    b <- max(x2[,col])
    x1[,col] <- (x1[,col]-a)/(b-a)
  }
  x1
}

### Rescale x1 using the means and SDs of x2
scale.1 <- function(x1,x2){
  for(col in 1:ncol(x1)){
    a <- mean(x2[,col])
    b <- sd(x2[,col])
    x1[,col] <- (x1[,col]-a)/b
  }
  x1
}