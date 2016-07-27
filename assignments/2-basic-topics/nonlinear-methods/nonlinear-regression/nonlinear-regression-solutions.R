library(readr)
library(rpart)
library(randomForest)
library(caret)
library(dplyr)
library(kknn)
library(gbm)

rmse = function(x, y) sqrt(mean((x - y)^2))

# Load white wine dataset + plot
setwd('C:/Users/Andrew/Documents/Signal/curriculum/datasets/wine-quality')
df_white = read_delim('winequality-white.csv', ';')
names(df_white) = sapply(names(df_white), function(cs) sapply(cs, function(s) gsub(' ', '_', s)))

qplot(df_white$fixed_acidity, df_white$quality) + geom_smooth()
qplot(df_white$volatile_acidity, df_white$quality) + geom_smooth()
qplot(df_white$citric_acid, df_white$quality) + geom_smooth()
qplot(df_white$residual_sugar, df_white$quality) + geom_smooth()
qplot(df_white$chlorides, df_white$quality) + geom_smooth()
qplot(df_white$free_sulfur_dioxide, df_white$quality) + geom_smooth()
qplot(df_white$total_sulfur_dioxide, df_white$quality) + geom_smooth()
qplot(df_white$density, df_white$quality) + geom_smooth()
qplot(df_white$pH, df_white$quality) + geom_smooth()
qplot(df_white$sulphates, df_white$quality) + geom_smooth()
qplot(df_white$alcohol, df_white$quality) + geom_smooth()

# Caret utility functions
caret_reg = function(x, y, method, grid, ...) {
  set.seed(1)
  control = trainControl(method="repeatedcv", repeats=1, number=3, verboseIter=TRUE)
  train(x=x, y=y, method=method, tuneGrid=grid, trControl=control, metric="RMSE", preProcess=c("center", "scale"), ...)
}
caret_rmse = function(caret_fit) min(caret_fit$results$RMSE)

# Elastic net regularized regression for a baseline
wine_features = select(df_white, -quality)
wine_quality = df_white$quality

grid_glmnet = expand.grid(alpha=seq(0, 1, 0.1), lambda=2^seq(-4, 1, length.out=20))
fit_glmnet = caret_reg(wine_features, wine_quality, "glmnet", grid_glmnet)
results = data.frame(method="glmnet", rmse=caret_rmse(fit_glmnet))
results$method = as.character(results$method)
results

# K-Nearest Neighbors
grid_knn = expand.grid(k=1:20)
fit_knn = caret_reg(wine_features, wine_quality, "knn", grid_knn)
results = rbind(results, c("knn", caret_rmse(fit_knn)))
results

# Multivariate adaptive regression splines
grid_mars = expand.grid(degree=1:5, nprune=15:25)
fit_mars = caret_reg(wine_features, wine_quality, "earth", grid_mars)
results = rbind(results, c("mars", caret_rmse(fit_mars)))
results
coef(fit_mars$finalModel)

# Standard regression trees
grid_rpart = expand.grid(cp=10^seq(-3, 0, length.out=10))
fit_rpart = caret_reg(wine_features, wine_quality, "rpart", grid_rpart)
results = rbind(results, c("rpart", caret_rmse(fit_rpart)))
results
fit_rpart$finalModel

# Random forests
grid_rf = expand.grid(mtry=2:6)
fit_rf = caret_reg(wine_features, wine_quality, "ranger", grid_rf, importance="impurity")
results = rbind(results, c("rf", caret_rmse(fit_rf)))
results


#####################################################################

# Old stuff


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
rf_white3 = randomForest(quality ~ ., df_white, mtry=5)
rmse(predict(rf_white3), df_white$quality)

rf_grid = expand.grid(mtry=c(3, 5, 7, 11))
fit_rf = train(quality ~ ., data=df_white, method='rf', metric="RMSE", trControl=control, tuneGrid=rf_grid)
caretmin(fit_rf)
rmse(df_white$quality, predict(fit_rf$finalModel))

grid = expand.grid(n.trees=seq(500, 3000, 500), shrinkage=10^seq(-3, 0, length.out=10), interaction.depth=c(1, 2, 3), n.minobsinnode=seq(10, 100, length.out=10))
fit_gbm = train(quality ~ ., data=df_white, method="gbm", metric="RMSE", trControl=control, tuneGrid=grid)
caretmin(fit_gbm)

grid2 = expand.grid(n.trees=seq(500, 3000, 500), shrinkage=0.1, interaction.depth=3, n.minobsinnode=30)
fit_gbm2 = train(quality ~ ., data=df_white, method="gbm", metric="RMSE", trControl=control, tuneGrid=grid2)
caretmin(fit_gbm2)

cufit_gbm3 = gbm(formula=formula(quality ~ .), data=df_white, n.trees=2500, shrinkage=0.1, interaction.depth=3, n.minobsinnode=30, cv.folds=10)
min(cufit_gbm3$cv.error)
rmse(df_white$quality, predict(cufit_gbm3, df_white))

library(earth)

earth_grid = expand.grid(degree=3, nprune=10:20)
fit_mda = train(quality ~ ., data=df_white, method="earth", tuneGrid=earth_grid, metric="RMSE", trControl=control)
caretmin(fit_mda)

cubist_grid = expand.grid(committees=c(10, 15, 20, 25, 30), neighbors=0:9)
fit_cubist = train(quality ~ ., data=df_white, method="cubist", tuneGrid=cubist_grid, metric="RMSE", trControl=control)
caretmin(fit_cubist)

nnet_grid = expand.grid(size=1:3, dec)
fit_nnet = train(quality ~ ., data=df_white, method="nnet", tuneLength=10, metric="RMSE", trControl=control)
caretmin(fit_nnet)

library(caretEnsemble)

methods = c('earth', 'cubist', 'glmnet', 'kknn', 'rpart', 'gbm', 'rf', 'nnet')
tunes = list(
  earth=caretModelSpec(method='earth', tuneGrid=earth_grid),
  cubist=caretModelSpec(method='cubist', tuneGrid=cubist_grid),
  glmnet=caretModelSpec(method='glmnet', tuneLength=10),
  kknn=caretModelSpec(method='kknn', tuneLength=10),
  rpart=caretModelSpec(method='rpart', tuneLength=10),
  gbm=caretModelSpec(method='gbm', tuneGrid=grid2),
  rf=caretModelSpec(method='rf', tuneGrid=rf_grid),
  nnet=caretModelSpec(method='nnet', tuneLength=10, trace=FALSE)
)
fits = caretList(quality ~ ., df_white, trControl=control, methodList=methods, tuneList=tunes)
ens = caretEnsemble(fits)
ens
summary(ens)

stack = caretStack(fits, method="gbm", metric="RMSE", trControl=trainControl(method="repeatedcv", repeats=1, number=3, savePredictions="final", verboseIter=TRUE), tuneLength=10)
stack
summary(stack)

fit_svm = train(quality ~ ., data=df_white, method="svmRadialCost", tuneLength=10, metric="RMSE", trControl=control)
caretmin(fit_svm)
