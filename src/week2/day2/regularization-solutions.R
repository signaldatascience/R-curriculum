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

# Get RMSEs for L1/L2 glmnet() fit given lambda
get_rmses = function(fit, lamb) rmse(predict(fit, activities_scaled, s=lamb), attr_o)

# Given L1/L2 glmnet() fit, return lambda and RMSE corresponding to minimum RMSE
get_min_rmse = function(fit) {
  rmses = sapply(fit$lambda, get_rmses, fit=fit)
  c(lambda=fit$lambda[arg_min(rmses)], rmse=min(rmses))
}

### EXPLORING REGULARIZATION WITH SIMULATED DATA ###############################

set.seed(1); j = 50; a = 0.25
x = rnorm(j); y = a*x + sqrt(1 - a^2)*rnorm(j)
x = scale(x)[,1]; y = scale(y)
summary(lm(y ~ x - 1))
qplot(x, y) + geom_smooth(method = "lm")

cost =  function(x, y, aEst, lambda){
  sqrt(mean((y - aEst*x)^2)) + lambda*abs(aEst)^1
}
lambdas = 2^(seq(-8, 5, 1))
as = seq(-0.1, 0.3, by= 0.001)
expanded = expand.grid(lambda = lambdas,a = as)
expanded$error = 0
for(a in as){
  for(lam in lambdas){
    expanded[expanded$lambda == lam & expanded$a == a,"error"] = cost(x, y, a, lam)
  }
}

expanded = round(expanded, 3)
l = lapply(1:10, function(k){
  lambdas = round(lambdas, 3)
  aEst = expanded[expanded$lambda == lambdas[k],"a"]
  error = expanded[expanded$lambda == lambdas[k],"error"]
  qplot(aEst, error)
})

multiplot(plotlist = l, cols = 2)

### COMPARING REGULARIZATION AND STEPWISE REGRESSION ###########################

set.seed(1)

# Load data
setwd('C:/Users/Andrew/Documents/Signal/curriculum/src/week2/day1/')
df = read.csv('speedDatingSimple.csv')

# Filter for gender == 1
df = filter(df, gender==1)

# Get features/target variables
activities = select(df, sports:yoga)
activities_scaled = scale(activities)
attr_o = df$attr_o

# Stepwise regression on entire dataset
df_step = select(df, attr_o, sports:yoga)
model_init = lm(attr_o ~ ., df_step)
model_full = formula("attr_o ~ .")
fit_step = step(model_init, model_full, direction="backward", trace=0)

# L1/L2 regularized fit on entire dataset
fit_l1 = glmnet(activities_scaled, attr_o, alpha=1)
fit_l2 = glmnet(activities_scaled, attr_o, alpha=0)

# Get RMSEs
rmse_step = rmse(predict(fit_step, df_step), attr_o)
min_l1_rmse = get_min_rmse(fit_l1)["rmse"]
min_l2_rmse = get_min_rmse(fit_l2)["rmse"]

# Compare the RMSE values for stepwise regression, L1/L2 regularization
c(step=rmse_step, l1=min_l1_rmse, l2=min_l2_rmse)

# View coefficients of L1/L2 models for lambda=0.2 (arbitrarily chosen)
coef(fit_l1, s=0.1)
coef(fit_l2, s=0.2)

# Plot the RMSE for L1/L2 regularization as function of lambda
qplot(fit_l1$lambda, rmse_l1)
qplot(fit_l2$lambda, rmse_l2)

# Use cv.glmnet() to determine optimal cross-validated lambda
fit_l1_cv = cv.glmnet(activities_scaled, attr_o, alpha=1)
fit_l2_cv = cv.glmnet(activities_scaled, attr_o, alpha=0)

# Get optimal lambdas for the two fits
c(l1=fit_l1_cv$lambda.min, l2=fit_l2_cv$lambda.min)

### MAKING CROSS-VALIDATED RMSE PREDICTIONS ####################################

# I won't write a function -- instead I'll just do it directly
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
  features_test = scale(activities[folds == i, ])
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
param_grid = expand.grid(.alpha=1:10*0.1, .lambda=10^seq(-4, -1, length.out=10))
control = trainControl(method="repeatedcv", number=10, repeats=3, verboseIter=TRUE)

# As before, I won't wrap it in a function, I'll just do it directly
caret_fit = train(x=activities_scaled, y=attr_o, method="glmnet", tuneGrid=param_grid, trControl=control)

caret_fit
