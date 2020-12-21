## Machine Learning Classification Competition

My upper-level STAT 452 organized a machine learning competition that focused on an anonymized classification problem. The dataset was completely anonymized meaning that I had no knowledge of what the features and response actually represented. By doing this, more time had to be spent on tuning the prediction machine rather than researching the domain of the problem.

## Models Trained

- Logistic Regression
- KNN
- LASSO Logistic Regression
- Linear and Quadratic Discriminant Analysis
- Naive Bayes (with and without PCA)
- Random Forest
- Single level NN or Perceptron
- SVM

## Steps Taken

1) I created a benchmarking scripts to compare the performance of each of the trained models over a repeated 10-fold cross validation (repeated 20 times), where each model’s normal and relative misclassification rate was calculated on the same test fold. Since the Random Forest and Neural Network were the only models that required more hands-on parameter tuning, I tuned these two models in two separate scripts and added the best performing version of each model to the benchmarking script. After running the benchmarking script with the most optimal version of each model, I chose the model with the lowest mean misclassification rate to be my final model.

2) I only tuned Random Forest and Neural Network given that the other models were automatically tuned by my code. For the Random Forest, I initially performed a grid search on the following parameter values, with each individual model being refitted 10 times:

- mtry = (1:12)
- Node Size = (1:12)
- Sample Size = (0.50, 0.55, ..., 0.75)

The top 5 Random Forest’s with the smallest mean misclassification rates all had an mtry = 1, node size ranging between 8 and 10, and sample size ratio of 0.50, and as a result I followed the Law of Parsimony and chose the RF with mtry = 1, node size = 8, and sample size ratio = 0.50.
For the Neural Network, the general structure I followed was to iterate over a 10-fold cross validation 5 times, train each network 7 times on the training folds, and keep the model with the smallest sMSE from each training iteration. The networks with the smallest sMSE’s were then tested on the test fold and a misclassification rate was calculated. The models were all constructed from a grid-search consisting of the following parameter values:

- Node Size for Hidden Layer: (1:13)
- Shrinkage: (0.01, 0.1, 0.30, 0.70, 1)

Since each CV was repeated 7 times, I took the mean misclassification rate of each model and noticed that the top 5 models with the smallest error rates had a node count of 9 or 10 and a shrinkage parameter of 0.1. I updated the grid search to only iterate over the node size range of (9:10) and the shrinkage range of (0.1, 0.15, 0.20, ..., 0.40). The best performing model had a node size of 9 and a shrinkage parameter of 0.30, which I then chose as my most optimal Neural Network.
I chose my final model to be a Random Forest with the parameters mtry = 1, node size = 8, and sample size ratio = 0.50 given that it outperformed all other models.

3) I believe the effort I put into feature selection significantly improved my most optimal model’s error rate. I began feature selection by running the RF function varImPlot() on the raw data and only kept the top nine most important features. Using my benchmarking script, I retrained all of my models on the data with these nine features and used each model’s mean error rate as my error baseline. I then removed each feature one-by-one and re-ran my benchmarking script for each removal. If the removal of the feature resulted in the error rate to increase, then that feature was identified as important. If the error rate decreased as a result of a removal, then that feature was discarded from the data. I managed to go from the initial 16 features in the raw dataset to nine potentially important features to then six very important features.

## Final Model

I believe the following variables are important X16, X7, X9, X6, X1, X12 while everything else had no significant impact on the trained classifier.
