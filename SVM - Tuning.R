# set the working directory + other stuff
setwd('Project 2/')
data = read.csv('P2Data2020.csv')
source("Helper Functions.R")
data$Y = as.factor(data$Y)

Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6',)] 
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X13', 'X6', 'X12', 'X1', 'X8')] 4 - 2 ==> 0.1830
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X13', 'X6', 'X12')] 4 - 3 ==> 0.20
# Data = Data[,c('Y', 'X16', 'X7', 'X9')]  7 - 5 ==> 0.2162


p.train = 0.75
n = nrow(data)
n.train = floor(p.train*n)

ind.random = sample(1:n)
data.train = data[ind.random <= n.train,]
X.train = data.train[,-1]
Y.train = data.train[,1]

data.valid = data[ind.random > n.train,]
X.valid = data.valid[,-1]
Y.valid = data.valid[,1]


caret.settings = trainControl(method="repeatedcv", number=10, repeats=2,
                              returnResamp="all")

### Next, we choose all the parameter combinations that we will tune
all.Cs     = 10^(0:5)
all.sigmas = c(0.01, 0.02, 0.04, 0.06, 0.08, 0.1) #10^(-(1:5)) 

# sigma instead of gamma
all.pars = expand.grid(C = all.Cs, sigma = all.sigmas)

info.SVM = train(X.train, Y.train, method = "svmRadial",
                 preProcess = c("center", "scale"), tuneGrid = all.pars,
                 trControl = caret.settings)


CV.acc.raw = info.SVM$resample
CV.acc.wide = reshape(data=CV.acc.raw[,-2], 
                      idvar=c("C", "sigma"), 
                      timevar="Resample", 
                      direction="wide")

CV.mis = 1 - t(CV.acc.wide[,c(-1, -2)])
colnames(CV.mis) = apply(CV.acc.wide[,1:2], 1, paste, collapse = ",")
head(CV.mis)

boxplot(CV.mis, las = 2)
rel.CV.mis = apply(CV.mis, 1, function(W) W/min(W))
boxplot(t(rel.CV.mis), las=2)



