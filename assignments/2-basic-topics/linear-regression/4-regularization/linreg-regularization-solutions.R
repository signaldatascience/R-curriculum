library(dplyr)
library(ggplot2)
library(glmnet)
library(caret)
library(Rmisc)

### UTILITY FUNCTIONS ##########################################################

# Find leftmost index in vector corresponding to min value
arg_min = function(v) match(min(v), v)[1]

# RMSE for (actual, predicted)
rmse = function(x, y) sqrt(mean((x-y)^2))

### SIMULATED DATA FOR REGULARIZATION ##########################################

# Define x and y
set.seed(1); j = 50; a = 0.25
x = rnorm(j)
error = sqrt(1 - a^2)*rnorm(j)
y = a*x + error

# Look at lm() coefficient estimate
summary(lm(y ~ x - 1))
qplot(x, y) + geom_smooth(method = "lm")

# Define cost function
cost =  function(x, y, aEst, lambda, p){
  sum((y - aEst*x)^2) + lambda*abs(aEst)^p
}
cost(1, 2, 3, 4, 2)

# Create vectors
lambdas = 2^(seq(-2, 7, 1))
as = seq(-0.1, 0.3, by=0.001)

# Create grid
grid = expand.grid(lambda=lambdas, aEst=as)

# Add empty costL1 and costL2 columns
grid$costL1 = 0
grid$costL2 = 0

# Fill in empty columns
for (i in 1:nrow(grid)) {
  aEst = grid[i, "aEst"]
  lambda = grid[i, "lambda"]
  grid[i, "costL1"] = cost(x, y, aEst, lambda, 1)
  grid[i, "costL2"] = cost(x, y, aEst, lambda, 2)
}

# get_plot() function
get_plot = function(lambda, p) {
  aEst = grid[grid$lambda == lambda, "aEst"]
  if (p == 1) {
    cost = grid[grid$lambda == lambda, "costL1"]
  } else {
    cost = grid[grid$lambda == lambda, "costL2"]
  }
  qplot(aEst, cost)
}

# Make the lists of plots
plotsL1 = lapply(1:10, function(k) get_plot(lambdas[k], 1))
plotsL2 = lapply(1:10, function(k) get_plot(lambdas[k], 2))

# Calls to multiplot()
multiplot(plotlist=plotsL1, cols=2)
multiplot(plotlist=plotsL2, cols=2)

### COMPARING REGULARIZATION AND STEPWISE REGRESSION ###########################

set.seed(1)

# Load data
setwd('C:/Users/Andrew/Documents/Signal/curriculum/datasets/speed-dating-simple')
df = read.csv('speed-dating-simple.csv')

# Filter for gender == 1
df = filter(df, gender==1)

# Get features/target variables
activities = select(df, sports:yoga)
activities_scaled = scale(activities)
attr_o = df$attr_o

# L1/L2 regularized fit on entire dataset
fit_l1 = glmnet(activities_scaled, attr_o, alpha=1)
fit_l2 = glmnet(activities_scaled, attr_o, alpha=0)

# Function to calculate RMSE for each lambda
get_rmses = function(fit, features, target) {
  rmses = numeric(length(fit$lambda))
  for (i in 1:length(fit$lambda)) {
    lamb = fit$lambda[i]
    preds = predict(fit, features, s=lamb)
    tmp_rmse = rmse(preds, target)
    rmses[i] = tmp_rmse
  }
  rmses
}

# Get RMSE values
rmse_l1 = get_rmses(fit_l1, activities_scaled, attr_o)
rmse_l2 = get_rmses(fit_l2, activities_scaled, attr_o)

# Plot RMSE against lambda
qplot(fit_l1$lambda, rmse_l1)
qplot(fit_l2$lambda, rmse_l2)

# Use cv.glmnet() to determine optimal cross-validated lambda
fit_l1_cv = cv.glmnet(activities_scaled, attr_o, alpha=1)
fit_l2_cv = cv.glmnet(activities_scaled, attr_o, alpha=0)

# Plot cross-validated error against lambda
qplot(fit_l1_cv$lambda, fit_l1_cv$cvm)
qplot(fit_l2_cv$lambda, fit_l2_cv$cvm)

### MAKING CROSS-VALIDATED RMSE PREDICTIONS ####################################

set.seed(2)

# Initialize predictions vectors
preds_step = numeric(nrow(df))
preds_l1 = numeric(nrow(df))
preds_l2 = numeric(nrow(df))

# Do cross-validation
n_folds = 10
folds = sample(nrow(df)) %% n_folds + 1
for (i in 1:n_folds) {
  print(paste0("Running fold: ", as.character(i)))

  # L1/L2 regressions
  features_train = scale(activities[folds != i, ])
  features_test = scale(activities[folds == i, ], center=attr(features_train, "scaled:center"), scale=attr(features_train, "scaled:scale"))
  attr_o_train = attr_o[folds != i]
  cv_fit_l1 = cv.glmnet(features_train, attr_o_train, alpha=1)
  cv_fit_l2 = cv.glmnet(features_train, attr_o_train, alpha=0)

  # Stepwise regression
  df_step_train = df_step[folds != i, ]
  df_step_test = df_step[folds == i, ]
  model_init = lm(attr_o ~ ., df_step_train)
  model_full = formula("attr_o ~ .")
  cv_fit_step = step(model_init, model_full, direction="backward", trace=0)

  # Generate and store predictions
  preds_step[folds == i] = predict(cv_fit_step, df_step_test)
  preds_l1[folds == i] = predict(cv_fit_l1, features_test, s=cv_fit_l1$lambda.min)
  preds_l2[folds == i] = predict(cv_fit_l2, features_test, s=cv_fit_l2$lambda.min)
}

# Calculate RMSE values
cv_rmse_step = rmse(preds_step, attr_o)
cv_rmse_l1 = rmse(preds_l1, attr_o)
cv_rmse_l2 = rmse(preds_l2, attr_o)

# Compare them
c(step=cv_rmse_step, l1=cv_rmse_l1, l2=cv_rmse_l2)

### ELASTIC NET REGRESSION #####################################################

set.seed(3)

# Set parameters
param_grid = expand.grid(.alpha=1:10*0.1, .lambda=10^seq(-4, 0, length.out=10))
control = trainControl(method="repeatedcv", number=10, repeats=3, verboseIter=TRUE)

# Search
caret_fit = train(x=activities_scaled, y=attr_o, method="glmnet", tuneGrid=param_grid, trControl=control)

# View minimum RMSE
min(caret_fit$results$RMSE)

# View hyperparameters
caret_fit$bestTune
