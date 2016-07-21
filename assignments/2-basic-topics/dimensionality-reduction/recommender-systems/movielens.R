# Load and subset data
df = read.csv("C:/Users/Andrew/Downloads/ml-1m/ratings.dat", sep = ":", header = FALSE)
df = df[c(1, 3, 5)]
names(df)
colnames(df)[1:3] = c("uid", "mid", "rating")

# Load libraries
library(softImpute)
library(dplyr)

# Compute unique user and movie IDs, mean rating
uids = unique(df$uid)
mids = unique(df$mid)
m = mean(df$rating)

# Generate train and test sets
set.seed(3); samps = sample(1:nrow(df), nrow(df)*0.8)
train = df[samps,]
test = df[-samps,]

# Calculate maximum movie and user IDs
help(Incomplete)
midmax = max(df$mid)
uidmax = max(df$uid)
head(df)

# Create grid1 (movie rated by every user) and grid2 (user who rated every movie) and add to train set
grid1 = expand.grid(mid = midmax + 1, uid =  1:uidmax, rating = m)
grid2 = expand.grid(mid = 1:midmax, uid =  uidmax + 1, rating = m)
grid1$rating = grid1$rating + 0.01*rnorm(length(grid1$rating))
grid2$rating = grid2$rating + 0.01*rnorm(length(grid2$rating))
train = rbind(train, grid1, grid2)

# Create sparse matrix of users and movie ratings
mat = Incomplete(train$uid, train$mid, train$rating)

#lambdas = seq(0.51, 0.6, 0.01)
#lambdas = seq(0.5, 1., 0.05)

##################################################

# Scale data
scaled = biScale(mat, maxit = 5, trace = TRUE)

# Get lambda values
lam0 = lambda0(scaled)
lamseq=exp(seq(from=log(lam0),to=log(1),length=20))

# Initialize results data frame and fits vector
results = data.frame(lambda=lamseq)
results$rank = 0
results$rmse = 0
fits = vector("list", 20)

# RMSE utility function
rmse = function(arr1, arr2){
  sqrt(mean((arr1 - arr2)^2))
}

# Alternating least squares for different lambda values
warm = NULL
for(i in seq_along(lamseq)){
  fiti=softImpute(scaled, lambda=lamseq[i], rank.max=50, warm.start=warm, maxit = 1000)
  fit_rank = sum(round(fiti$d,4)>0)
  warm = fiti
  fits[[i]] = fiti
  imps = impute(fiti, test$uid, test$mid )
  r = rmse(test$rating, imps)

  results[i, 2:3] = c(fit_rank, r)
  cat(i,"lambda=",lamseq[i],"rank",fit_rank,"rmse", r, "\n")
}

# Store best result
best_svd = fits[[match(min(results$rmse), results$rmse)]]

##################################################

# Load the movies dataset
movies = read.csv("C:/Users/Andrew/Downloads/ml-1m/movies.dat", sep = ":", header = F)
head(movies)
movies = movies[c(1,3,5)]
head(movies)
colnames(movies) = c("mid", "title", "genres")

# Make indicator variables for each movie's membership in listed genres
l = lapply(movies$genres, function(pip){
  strsplit(as.character(pip), split = "\\|")[[1]]
})
head(l)
unique(unlist(l))
us = unique(unlist(l))[1:18]
movies[unique(unlist(l))[1:18]] = 0
for(i in 1:length(l)){
  chars = l[[i]]
  for(char in chars){
    if(char %in% us){
      movies[i,char] = 1
    }
  }
}
movies = movies[movies$mid %in% unique(train$mid),]
dim(best_svd$v)
movies = data.frame(movies, best_svd$v[as.numeric(as.character(movies$mid)),])
head(movies)
cor(movies$Drama, select(movies, X1:X30))
sels = select(movies, Drama, X1:X30)
m = glm(Drama ~ . , sels, family = "binomial")
summary(m)
library(DAAG)
cvs = CVbinary(m)
library(pROC)
roc(sels$Drama,cvs$cvhat)
pdf = data.frame(movies[c("title", "Drama")], cvs$cvhat)
head(pdf)
head(pdf[order(pdf["cvs.cvhat"]),], 40)
tail(pdf[order(pdf["cvs.cvhat"]),], 40)
