# set the working directory + other stuff
setwd('Project 2/')
data = read.csv('P2Data2020.csv')
source("Helper Functions.R")

data$Y = as.factor(data$Y)

# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X6',)] 0.20875
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X13', 'X6', 'X12', 'X1', 'X8')] 0.2075
# Data = Data[,c('Y', 'X16', 'X7', 'X9', 'X13', 'X6', 'X12')] 0.2025
# Data = Data[,c('Y', 'X16', 'X7', 'X9')]  # 0.20875



### Split the data into training and validation sets
p.train = 0.80
n = nrow(data)
n.train = floor(p.train*n)

ind.random = sample(1:n)

data.train = data[ind.random <= n.train,]
X.train.raw = data.train[,-1]
Y.train = data.train[,1]

data.valid = data[ind.random > n.train,]
X.valid.raw = data.valid[,-1]
Y.valid = data.valid[,1]

### Rescale columns of X to fall between 0 and 1 using Tom's function
rescale <- function(x1,x2){
  for(col in 1:ncol(x1)){
    a <- min(x2[,col])
    b <- max(x2[,col])
    x1[,col] <- (x1[,col]-a)/(b-a)
  }
  x1
}

X.train = rescale(X.train.raw, X.train.raw)
X.valid = rescale(X.valid.raw, X.train.raw)



### Convert Y to a factor and the corresponding indicator. The nnet() function
### needs a separate indicator for each class. We can get these indicators
### using the class.ind() function after converting our response to a factor
Y.train.fact = factor(Y.train, levels = c("A", "B", "C", "D", "E"))
Y.train.num  = class.ind(Y.train.fact)

Y.valid.fact = factor(Y.valid, levels = c("A", "B", "C", "D", "E"))
Y.valid.num  = class.ind(Y.valid.fact)


### Candidate parameter values
all.sizes  = 9 #c(7:13)
all.decays =  0.30 #seq(from=0.2,to=0.30,by=0.01)

all.pars = expand.grid(size = all.sizes, decay = all.decays)
n.pars = nrow(all.pars)
par.names = apply(all.pars, 1, paste, collapse = "-")

H = 1    # Number of times to repeat CV
K = 10   # Number of folds for CV
M = 7   # Number of times to re-run nnet() at each iteration

### Container for CV misclassification rates. Need to include room for
### H*K CV errors
CV.misclass = array(0, dim = c(H*K, n.pars))
colnames(CV.misclass) = par.names

for(h in 1:H) {
  
  ### Get all CV folds
  folds = get.folds(n.train, K)
  
  for (i in 1:K) {
    print(paste0(h, "-", i, " of ", H, "-", K))
    
    ### Split training set according to fold i
    data.train.inner = data.train[folds != i, ]
    data.valid.inner = data.train[folds == i, ]
    
    ### Separate response from predictors
    Y.train.inner     = data.train.inner[, 1]
    X.train.inner.raw = data.train.inner[, -1]
    Y.valid.inner     = data.valid.inner[, 1]
    X.valid.inner.raw = data.valid.inner[, -1]
    
    ### Transform predictors and response for nnet()
    X.train.inner = rescale(X.train.inner.raw, X.train.inner.raw)
    X.valid.inner = rescale(X.valid.inner.raw, X.train.inner.raw)
    Y.train.inner.num = class.ind(factor(Y.train.inner))
    Y.valid.inner.num = class.ind(factor(Y.valid.inner))
    
    for (j in 1:n.pars) {
      
      ### Get parameter values
      this.size  = all.pars[j, "size"]
      this.decay = all.pars[j, "decay"]
      
      ### Get ready to re-fit NNet with current parameter values
      MSE.best = Inf
      
      ### Re-run nnet() M times and keep the one with best sMSE
      for (l in 1:M) {
        
        this.nnet = nnet(
                      X.train.inner,
                      Y.train.inner.num,
                      size = this.size,
                      decay = this.decay,
                      maxit = 2000,
                      softmax = T,
                      trace = F
        )
        
        this.MSE = this.nnet$value
        
        if (this.MSE < MSE.best) {
          nnet.best = this.nnet
        }
        
      }
      
      ### Get CV misclassification rate for chosen nnet()
      pred.nnet.best = predict(nnet.best, X.valid.inner, type = "class")
      this.mis.CV = mean(Y.valid.inner != pred.nnet.best)
      
      ### Store this CV error. Be sure to put it in the correct row
      ind.row = (h - 1) * K + i
      CV.misclass[ind.row, j] = this.mis.CV
      
    }
  }
}


### Make absolute and relative boxplots
boxplot(CV.misclass, las = 2)
rel.CV.misclass = apply(CV.misclass, 1, function(W) W/min(W))
boxplot(t(rel.CV.misclass), las=2)

sort(colMeans(CV.misclass))



