# set the working directory + other stuff
setwd('Project 2/')
Data = read.csv('P2Data2020.csv')
source("Helper Functions.R")
Data$Y = as.factor(Data$Y)

Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X12')]

# Data Investigation
#names(Data)
#summary(Data)
#Dim(Data)




## Step 0: Data Investigation ##

# check out the expl variables
#hist(Data$X16)
# X1 - X5 are very normal
# X6 is less normal, seems a bit bimodal
# X7 is normal
# X8, X9 is less normal
# X10 is a bit left skewed
# X11 is normal
# X13 - X15 is less normal
# X16 is very left skewed

#corrs = round(cor(Data[,-1], method = "pearson"), 2)
#(corrs)




## Step 1 ##

H = 50   # Number of times to repeat CV

### Container for CV misclassification rates. Need to include room for
 column_names = c(#'KNN', 
#                  'Log Reg', 
#                  'Log Reg (LASSO)', 
#                  'LDA', 
#                  'QDA',
#                  'NB - Kernel - No PC', 
#                  'NB - Normal - No PC', 
#                  'NB - Kernel - PC', 
#                  'NB - Normal - PC', 
                 'RF')#, 
                 #'NN')

CV.misclass = array(0, dim = c(H, length(column_names)))
colnames(CV.misclass) = column_names


for(h in 1:H) {
  
  print(paste0("-- ", h, " of ", H, " --"))
  
  # reset model index variable
  model_index = 0
  
  # split into 75% training and 25% test
  p.train = 0.75
  n = nrow(Data)
  n.train = floor(p.train*n)
  ind.random = sample(1:n)
  
  # training data
  data.train = Data[ind.random <= n.train,]
  X.train = data.train[,-1]
  Y.train = data.train[,1]
  
  # validation data
  data.valid = Data[ind.random > n.train,]
  X.valid = data.valid[,-1]
  Y.valid = data.valid[,1]  
  
  
  ################# KNN #################
  # 
  # K.max = 50
  # KNN.mis.CV = rep(0, times = K.max)
  # 
  # for(i in 1:K.max){
  #   this.knn = knn.cv(X.train, Y.train, k=i)
  #   this.mis.CV = mean(this.knn != Y.train)
  #   KNN.mis.CV[i] = this.mis.CV
  # }
  # 
  # # run on validation set
  # k.min = which.min(KNN.mis.CV)
  # knn.min = knn(X.train, X.valid, Y.train, k.min)
  # knn.opt.mis = mean(Y.valid != knn.min)
  # 
  # # save the misclassification rates
  # CV.misclass[h,'KNN'] = round(knn.opt.mis, 3)
  # 
  # ######################################
  # 
  # 
  # ################# Logistic Regression #################
  # 
  # # scale the data
  # data.train.scale = data.train
  # data.valid.scale = data.valid
  # data.train.scale[,-1] = rescale(data.train[,-1], data.train[,-1])
  # data.valid.scale[,-1] = rescale(data.valid[,-1], data.train[,-1])
  # 
  # # fit a simple logistic regression
  # fit.log.nnet = multinom(Y ~ ., data = data.train.scale, maxit = 5000)
  # 
  # # get the test misclassification rate
  # log.reg.preds = predict(fit.log.nnet, data.valid.scale)
  # log.reg.mis   = mean(log.reg.preds != Y.valid)
  # 
  # # save the misclassification rate
  # CV.misclass[h,'Log Reg'] = round(log.reg.mis, 3)
  # 
  # ######################################
  # 
  # 
  # ################# Logistic Regression LASSO #################
  # 
  # # set expl vars as matrices
  # X.train.scale = as.matrix(data.train.scale[,-1])
  # X.valid.scale = as.matrix(data.valid.scale[,-1])
  # 
  # # fit a log reg LASSO
  # fit.CV.lasso = cv.glmnet(X.train.scale, Y.train, family="multinomial")
  # lambda.min = fit.CV.lasso$lambda.min
  # 
  # # test error rate
  # pred.lasso.min = predict(fit.CV.lasso, X.valid.scale, s = lambda.min, type = "class")
  # miss.lasso.min = mean(Y.valid != pred.lasso.min)
  # 
  # # save the misclassification rate
  # CV.misclass[h,'Log Reg (LASSO)'] = round(miss.lasso.min, 3)  
  # 
  # ######################################
  # 
  # ################# LDA & QDA #################
  # 
  # # rescale the data according Discriminant Analysis rules
  # X.train.DA = scale.1(data.train[,-1], data.train[,-1])
  # X.valid.DA = scale.1(data.valid[,-1], data.train[,-1])
  # 
  # # fit the lda & qda
  # fit.lda = lda(X.train.DA, Y.train)
  # fit.qda = qda(X.train.DA, Y.train)
  # 
  # # test misclassifcation rate
  # pred.lda = predict(fit.lda, X.valid.DA)$class
  # miss.lda = mean(Y.valid != pred.lda)
  # #CV.misclass[h,'LDA'] = round(miss.lda, 3)  
  # 
  # #pred.qda = predict(fit.qda, X.valid.DA)$class
  # #miss.qda = mean(Y.valid != pred.qda)
  # #CV.misclass[h,'QDA'] = round(miss.qda, 3)
  
  ######################################
  
  
  ################# Naive Bayes + No PC #################  
  
  # No PC + Kernel
  #fit.NB.kernel = NaiveBayes(X.train, Y.train, usekernel = T)
  #CV.misclass[h,'NB - Kernel - No PC'] = round((mean(Y.valid != predict(fit.NB.kernel, X.valid)$class)), 3)
  
  # No PC + Normal
  #fit.NB.normal = NaiveBayes(X.train, Y.train, usekernel = F)
  #CV.misclass[h,'NB - Normal - No PC'] = round((mean(Y.valid != predict(fit.NB.normal, X.valid)$class)), 3)
  
  # PC Analysis
  #fit.PCA = prcomp(X.train, scale. = T)
  #X.train.PC = fit.PCA$x
  #X.valid.PC = predict(fit.PCA, data.valid)
  
  # PC + Kernel
  #fit.NB.PC.kernel = NaiveBayes(X.train.PC, Y.train, usekernel = T)
  #CV.misclass[h,'NB - Kernel - PC'] = round((mean(Y.valid != predict(fit.NB.PC.kernel, X.valid.PC)$class)), 3)
  
  # PC + Normal
  #fit.NB.PC.normal = NaiveBayes(X.train.PC, Y.train, usekernel = F)
  #CV.misclass[h,'NB - Normal - PC'] = round((mean(Y.valid != predict(fit.NB.PC.normal, X.valid.PC)$class)), 3)
  
  ######################################
  
  
  ################# Random Forests #################  
  
  this.mtry       = 1         # mtry parameter
  this.nodesize   = 8         # node size parameter
  this.samplesize = 0.50      # sample size ration parameter
  
  # Build the Random Forest
  fit.rf = randomForest(Y ~ ., 
                        data       = data.train, 
                        importance = F,
                        mtry       = this.mtry, 
                        nodesize   = this.nodesize,
                        ntree      = 1000,
                        sampsize   = this.samplesize * nrow(data.train))
  
  
  pred.this.rf = predict(fit.rf, X.valid)
  OOB.mis.fit  = mean(Y.valid != pred.this.rf)
  
  CV.misclass[h,'RF'] = round(OOB.mis.fit, 3)
  
  print(round(OOB.mis.fit, 3))
  
  
  ######################################
  
  
  ################# NN #################  
  
  #Y.train.inner     = data.train[,  1]
  #X.train.inner.raw = data.train[, -1]
  
  #Y.valid.inner     = data.valid[,  1]
  #X.valid.inner.raw = data.valid[, -1]
  
  #X.train.inner = rescale(X.train.inner.raw, X.train.inner.raw)
  # X.valid.inner = rescale(X.valid.inner.raw, X.train.inner.raw)
  
  #Y.train.inner.num = class.ind(factor(Y.train.inner))
  #Y.valid.inner.num = class.ind(factor(Y.valid.inner))
  
  #opt.size  = 9
  #opt.decay = 0.30
    
   # nnet.best = nnet(
     #             X.train.inner,
    #              Y.train.inner.num,
      #            size = opt.size,
       #           decay = opt.decay,
        #         softmax = T,
         #          trace = F)
  
  #pred.nnet.best = predict(nnet.best, X.valid.inner, type = "class")
 # this.mis.CV = mean(Y.valid.inner != pred.nnet.best)
  
  #CV.misclass[h,'NN'] = round(this.mis.CV, 3)
  
  ######################################
  
}



# print some summaries of the data

# column means
# mis.means.cols = (colMeans(CV.misclass))
# which.min(mis.means.cols)
# 
# # column SDs
# #mis.sd.cols = apply(CV.misclass, 1, sd)
# #which.min(mis.sd.cols)
# 
# # Normal Boxplots
# boxplot(CV.misclass, 
#         las = 2, 
#         main = 'Misclassification Rates Boxplot')
# 
# 
# rel.CV.misclass = apply(CV.misclass, 1, function(W) W/min(W))
# boxplot(t(rel.CV.misclass), 
#         las=2,
#         main = 'Relative Misclassification Rates Boxplot')
sort(colMeans(CV.misclass))


table(Y.valid, pred.this.rf, dnn = c("Observed", "Predicted"))



















