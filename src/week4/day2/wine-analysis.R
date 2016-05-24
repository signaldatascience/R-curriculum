library(readr)
library(rpart)
library(randomForest)
library(caret)
library(dplyr)
library(kknn)
library(gbm)
setwd('C:/Users/Andrew/Documents/Signal/curriculum/src/week4/day2/')
df_red = read_delim('winequality-red.csv', ';')
df_white = read_delim('winequality-white.csv', ';')
df_red = df_red[!rowSums(is.na(df_red)), ]

set.seed(1)

rmse = function(x, y) sqrt(mean((x - y)^2))
remove_spaces = function(cs) sapply(cs, function(s) gsub(' ', '_', s))

names(df_red) = remove_spaces(names(df_red))
names(df_white) = remove_spaces(names(df_white))

rtree_red = rpart(quality ~ ., df_red)
rmse(predict(rtree_red), df_red$quality)

rtree_white = rpart(quality ~ ., df_white)
rtree_white

nfolds = 10
red_folds = sample(nrow(df_red)) %% nfolds + 1

red_preds = numeric(nrow(df_red))
for (i in 1:nfolds) {
  red_train = df_red[red_folds != i, ]
  red_test = df_red[red_folds == i, ]
  red_fit = rpart(quality ~ ., red_train)
  red_preds[red_folds == i] = predict(red_fit, red_test)
}
rmse(red_preds, df_red$quality)

rf_red = randomForest(quality ~ ., df_red)
rmse(predict(rf_red), df_red$quality)

red_rfpreds = numeric(nrow(df_red))
for (i in 1:nfolds) {
  red_train = df_red[red_folds != i, ]
  red_test = df_red[red_folds == i, ]
  red_fit = randomForest(quality ~ ., red_train)
  red_rfpreds[red_folds == i] = predict(red_fit, red_test)
}
rmse(red_rfpreds, df_red$quality)

#############

caretmin = function(f) min(f$results[, "RMSE"])

library(caret)

control = trainControl(method="repeatedcv", repeats=1, number=3, verboseIter=TRUE)
fit_glmnet = train(quality ~ ., data=df_white, method="glmnet", tuneLength=11, metric="RMSE", trControl=control)
caretmin(fit_glmnet)

#fit_rf = train(quality ~ ., data=df_white, method="rf", tuneLength=3, metric="RMSE", trControl=control)

fit_knn = train(quality ~ ., data=df_white, method="kknn", tuneLength=10, metric="RMSE", trControl=control)
caretmin(fit_knn)

fit_rpart = train(quality ~ ., data=df_white, method="rpart", tuneLength=10, metric="RMSE", trControl=control)
caretmin(fit_rpart)

rf_white = randomForest(quality ~ ., df_white, mtry=floor(sqrt(11)))
rmse(predict(rf_white), df_white$quality)
rf_white2 = randomForest(quality ~ ., df_white, mtry=11)
rmse(predict(rf_white2), df_white$quality)

grid = expand.grid(n.trees=500, shrinkage=10^seq(-3, 0, length.out=10), interaction.depth=c(1, 2, 3), n.minobsinnode=seq(10, 100, length.out=10))
fit_gbm = train(quality ~ ., data=df_white, method="gbm", metric="RMSE", trControl=control, tuneGrid=grid)
caretmin(fit_gbm)

grid2 = expand.grid(n.trees=5000, shrinkage=0.1, interaction.depth=3, n.minobsinnode=20)
fit_gbm2 = train(quality ~ ., data=df_white, method="gbm", metric="RMSE", trControl=control, tuneGrid=grid2)
caretmin(fit_gbm2)

cufit_gbm3 = gbm(formula=formula(quality ~ .), data=df_white, n.trees=5000, shrinkage=0.1, interaction.depth=3, n.minobsinnode=20, cv.folds=3)

library(earth)

earth_grid = expand.grid(degree=1:5, nprune=10:20)
fit_mda = train(quality ~ ., data=df_white, method="earth", tuneGrid=earth_grid, metric="RMSE", trControl=control)
caretmin(fit_mda)

cubist_grid = expand.grid(committees=c(10, 15, 20, 25, 30), neighbors=0:9)
fit_cubist = train(quality ~ ., data=df_white, method="cubist", tuneGrid=cubist_grid, metric="RMSE", trControl=control)
caretmin(fit_cubist)

nnet_grid = expand.grid(size=1:3, dec)
fit_nnet = train(quality ~ ., data=df_white, method="nnet", tuneLength=10, metric="RMSE", trControl=control)
caretmin(fit_nnet)
