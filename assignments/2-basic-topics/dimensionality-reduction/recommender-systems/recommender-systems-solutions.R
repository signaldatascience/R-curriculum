# Load and subset data
df = read.csv("C:/Users/Andrew/Downloads/ml-1m/ratings.dat", sep = ":", header = FALSE)
df = df[c(1, 3, 5)]
names(df)
colnames(df)[1:3] = c("uid", "mid", "rating")

# Load libraries
library(softImpute)
library(dplyr)
library(DAAG)
library(pROC)

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

##################################################

#lambdas = seq(0.51, 0.6, 0.01)
#lambdas = seq(0.5, 1., 0.05)

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

# Calculate MAE
mae = function(x, y) mean(abs(x-y))
results$mae = sapply(seq_along(lamseq), function(i) mae(impute(fits[[i]], test$uid, test$mid), test$rating))

# Calculating precision and recall
precision = function(true, pred, threshold) {
  true = ifelse(true > threshold, 1, 0)
  pred = ifelse(pred > threshold, 1, 0)
  sum(true * pred) / sum(pred)
}
recall = function(true, pred, threshold) {
  true = ifelse(true > threshold, 1, 0)
  pred = ifelse(pred > threshold, 1, 0)
  sum(true * pred) / sum(true)
}
results$precision = sapply(seq_along(lamseq), function(i) precision(test$rating, impute(fits[[i]], test$uid, test$mid), m))
results$recall = sapply(seq_along(lamseq), function(i) recall(test$rating, impute(fits[[i]], test$uid, test$mid), m))

# Asymmetric cost function
L = matrix(c(0, 0, 0, 7.5, 10, 0, 0, 0, 4, 6, 0, 0, 0, 1.5, 3, 3, 2, 1, 0, 0, 4, 3, 2, 0, 0), nrow=5)
round_rating = function(x) min(max(round(x), 1), 5)
Lcost = function(true, pred) sum(sapply(seq_along(true), function(i) L[true[i], round_rating(pred[i])]))
results$asym = sapply(seq_along(lamseq), function(i) Lcost(test$rating, impute(fits[[i]], test$uid, test$mid)))

# Spearman's rank correlation
# Not part of assignment
rankcor = function(true, pred) {
  rank_true = match(true, sort(true))
  rank_pred = match(pred, sort(pred))
  cor(rank_true, rank_pred)
}
rankcor_metric = function(true, pred, uids) {
  cor_sum = 0
  for (u in unique(uids)) {
    c = rankcor(true[uids == u], pred[uids == u])
    cor_sum = cor_sum + c
  }
  cor_sum / length(unique(uids))
}
results$rankcor = sapply(seq_along(lamseq), function(i) rankcor_metric(test$rating, impute(fits[[i]], test$uid, test$mid), test$uid))

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


# Restrict to movies which were listed in the ratings dataset
movies = movies[movies$mid %in% unique(train$mid),]

# Add "factor columns" to movies data frame
dim(best_svd$v)
movies = data.frame(movies, best_svd$v[as.numeric(as.character(movies$mid)),])

# Look at Drama genre with logistic regression against factors
head(movies)
cor(movies$Drama, select(movies, X1:X30))
sels = select(movies, Drama, X1:X30)
m = glm(Drama ~ ., sels, family = "binomial")
summary(m)
cvs = CVbinary(m)
roc(sels$Drama,cvs$cvhat)

pdf = data.frame(movies[c("title", "Drama")], cvs$cvhat)
head(pdf)
head(pdf[order(pdf["cvs.cvhat"]),], 40)
tail(pdf[order(pdf["cvs.cvhat"]),], 40)

# Users dataset
users = read.csv("C:/Users/Andrew/Downloads/ml-1m/users.dat", sep = ":", header = F)
users = users[c(1, 3, 5, 7)]
names(users) = c("uid", "gender", "age", "career")
users = data.frame(users, best_svd$u[1:6040, ])
car = users$career
library(dummies)
users = dummy.data.frame(users, names="career", sep="_")
users = data.frame(users, career=car)
sort(table(users$career), decreasing=TRUE)
sort(table(filter(users, age > 25)$career), decreasing=TRUE)

# Multinomial logistic regression for career
users_c = filter(users, career %in% c(7, 1, 17, 6))
users_c = filter(users_c, age > 25)
facs = select(users_c, X1:X30)
library(glmnet)
fit_c = glmnet(scale(facs), users_c$career, family="multinomial")
preds_c = predict(fit_c, scale(facs), s=0)
pca_c = prcomp(scale(as.data.frame(preds_c)))
rownames(pca_c$rotation) = c('academic', 'medicine', 'executive', 'engineer')
library(corrplot)
corrplot(pca_c$rotation, is.corr=FALSE)

# Calculation of characteristic factor score vectors
genre_facs = list()
for (genre in us) {
  set.seed(1)
  print(paste("Genre:", genre))
  orig_name = genre
  genre = gsub("'", ".", genre)
  genre = gsub("-", ".", genre)
  sels = select(movies, X1:X30, one_of(genre))
  fit_genre = glm(paste(genre, "~ ."), sels, family="binomial")
  p_genre = CVbinary(fit_genre)$cvhat
  fscores = sapply(1:30, function(i) weighted.mean(sels[[i]], p_genre))
  genre_facs[[orig_name]] = fscores
}
genre_facs = as.data.frame(genre_facs)

career_facs = list()
for (car in 0:20) {
  set.seed(1)
  print(paste("Career:", car))
  cname = paste0("career_", car)
  sels = select(users, X1:X30, one_of(cname))
  fit_c = glm(paste(cname, "~ ."), sels, family="binomial")
  p_c = CVbinary(fit_c)$cvhat
  fscores = sapply(1:30, function(i) weighted.mean(sels[[i]], p_c))
  career_facs[[cname]] = fscores
}
career_facs = as.data.frame(career_facs)
names(career_facs) = c("other",
                       "academic/educator",
                       "artist",
                       "clerical/admin",
                       "college/grad student",
                       "customer service",
                       "doctor/health care",
                       "executive/managerial",
                       "farmer",
                       "homemaker",
                       "K-12 student",
                       "lawyer",
                       "programmer",
                       "retired",
                       "sales/marketing",
                       "scientist",
                       "self-employed",
                       "technician/engineer",
                       "tradesman/craftsman",
                       "unemployed",
                       "writer")

rating = function(x, y) sum(sapply(1:length(x), function(i) x[i]*best_svd$d[i]*y[i]))
cs = matrix(nrow=ncol(genre_facs), ncol=ncol(career_facs))
for (i in 1:ncol(genre_facs)) {
  for (j in 1:ncol(career_facs)) {
    cs[i, j] = rating(genre_facs[[i]], career_facs[[j]])
  }
}
rownames(cs) = names(genre_facs)
colnames(cs) = names(career_facs)
scs = scale(cs)
corrplot(scs, is.corr=FALSE)
scs2 = t(scale(t(cs)))
corrplot(scs2, is.corr=FALSE)

scs3 = biScale(cs)
corrplot(scs3, is.corr=FALSE)

corrplot(cs, tl.cex=1.2, is.corr=FALSE)

corrplot(cs, is.corr=FALSE, method="pie")
corrplot(cs[-17, -c(10, 11)], is.corr=FALSE)
