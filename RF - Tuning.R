# set the working directory + other stuff
setwd('Project 2/')
Data = read.csv('P2Data2020.csv')
source("Helper Functions.R")
Data$Y = as.factor(Data$Y)



Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X12')] # 0.169


# Tuning the RF:
# Winner: # Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X12')] # 1-11 ==> 0.1716
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', )] # 4 - 6 ==> 0.1810
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X8')] 4-4 ==> 0.1874
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1')] # 1-10 ==> 0.1760 # 1-9 ==> 0.1748
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X12')] # 1-11 ==> 0.1716
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X12', 'X13')] # 1-12 ==> 0.1750
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6', 'X1', 'X13')] # 1-9 ==> 0.1784

# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X13', 'X6', 'X12', 'X1', 'X8')] 4 - 2 ==> 0.1830
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X13', 'X6', 'X12')] 4 - 3 ==> 0.20
# Data = Data[,c('Y', 'X16', 'X7', 'X9')]  7 - 5 ==> 0.2162



## RF Tuning
all.mtry       = 1    # c(1:5)
all.nodesize   = 8    #  c(1:10)
all.samplesize = 0.50 # 0.50 #seq(from=0.5,to=0.75,by=0.05)
all.max.nodes       = seq(from=50, to=100, by=5)

all.pars = expand.grid(mtry     = all.mtry, 
                       nodesize = all.nodesize,
                       maxnodes = all.max.nodes,
                       ss       = all.samplesize)

n.pars   = nrow(all.pars)

M = 50
OOB.mis = array(0, dim = c(M, n.pars))

min.OOB.mis = 20

for(i in 1:n.pars){
  
  print(paste0(i, " of ", n.pars))
  
  this.mtry       = all.pars[i,"mtry"]
  this.nodesize   = all.pars[i,"nodesize"]
  this.samplesize = all.pars[i,"ss"]
  this.max.nodes  = all.pars[i,"maxnodes"]
  
  for(j in 1:M){
    
    fit.rf = randomForest(Y ~ ., 
                          data = Data, 
                          importance = F,
                          mtry = this.mtry, 
                          nodesize = this.nodesize,
                          maxnodes = this.max.nodes,
                          ntree = 1000,
                          sampsize = this.samplesize * nrow(Data))
    
    pred.this.rf = predict(fit.rf)
    OOB.mis.fit  = mean(Data$Y != pred.this.rf)
    
    OOB.mis[j, i] = OOB.mis.fit 
    
    if(OOB.mis.fit < min.OOB.mis) {
      min.OOB.mis = OOB.mis.fit
      print(paste0("Minimum OOB mis - ", OOB.mis.fit, " - acheived by parameters: (m, node, ss) --> ", 
                   this.mtry, ', ', 
                   this.nodesize, ', ', 
                   this.samplesize, ', ',
                   this.max.nodes))
      
      #print(fit.rf)
      
    } 
  }
}

names.pars = paste0(all.pars$mtry,"-", 
                    all.pars$nodesize, "-", 
                    all.pars$ss, "-",
                    all.pars$maxnodes)

colnames(OOB.mis) = names.pars


### Make boxplot
#boxplot(OOB.mis, las = 2)
#rel.CV.misclass = apply(OOB.mis, 1, function(W) W/min(W))
#boxplot(t(rel.CV.misclass), las=2)

sort(colMeans(OOB.mis))
#sort(colMeans(t(rel.CV.misclass)))

table(Y.valid, test.pred.log.nnet, dnn = c("Observed", "Predicted"))




