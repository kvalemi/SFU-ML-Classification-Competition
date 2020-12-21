#################### Libraries ####################
library(randomForest)

#################### Load Data ####################

# Set the directory (change directory to local directory of files on your own computer)
setwd('/Users/Kaveh/Documents/School Files/STAT 452/Assignments/Project 2')

# Alter training data into its correct format
training_data   = read.csv('P2Data2020.csv')
training_data$Y = as.factor(training_data$Y)
training_data   = training_data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X12')]

#################### Model Training ####################

# RF Parameters
this.mtry       = 1         # mtry parameter
this.nodesize   = 8         # node size parameter
this.samplesize = 0.50      # sample size ration parameter

# Set The seed
set.seed(42)

# Build the Random Forest
fit.rf = randomForest(Y ~ ., 
                      data       = training_data, 
                      importance = F,
                      mtry       = this.mtry, 
                      nodesize   = this.nodesize,
                      ntree      = 1000,
                      sampsize   = this.samplesize * nrow(training_data))


# Read in the test data
test_Data = read.csv('P2Data2020testX.csv')
test_Data = test_Data[,c('X16', 'X7', 'X9', 'X6', 'X1', 'X12')]

# Predict Y from the test data
test_output = predict(fit.rf, test_Data)

# Output the data
write.table(test_output, file = './P2_Data_Test_Output.csv', sep = ",", quote = F, row.names = F, col.names = F)










