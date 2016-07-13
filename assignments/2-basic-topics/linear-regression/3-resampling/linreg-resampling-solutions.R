library(dplyr)
library(ggplot2)

# Load data
setwd('C:/Users/Andrew/Documents/Signal/curriculum/datasets/speed-dating-simple/')
df = read.csv('speed-dating-simple.csv')
df_attr = select(df, -intel_o, -amb_o, -fun_o, -sinc_o)
df_attr = filter(df_attr, gender==0)
df_attr = select(df_attr, -gender)

# Single train/test split
split_data = function(df) {
  groups = sample(1:nrow(df)) %% 2
  train = df[groups == 0, ]
  test = df[groups == 1, ]
  list(train=train, test=test)
}

split_predict = function(train, test) {
  model = lm(attr_o ~ ., train)
  pred_train = predict(model, train)
  pred_test = predict(model, test)
  list(train=pred_train, test=pred_test)
}

rmse = function(x, y) sqrt(mean((x-y)^2))

niter = 100
rmse_train = rep(0, niter)
rmse_test = rep(0, niter)
for (i in 1:niter) {
  print(paste('Iteration:', i))
  splits = split_data(df_attr)
  preds = split_predict(splits$train, splits$test)
  rmse_train[i] = rmse(preds$train, splits$train$attr_o)
  rmse_test[i] = rmse(preds$test, splits$test$attr_o)
}
rmses = data.frame(rmse_train, rmse_test)
ggplot(rmses) + geom_histogram(aes(rmse_train), fill="blue", alpha=0.2) + geom_histogram(aes(rmse_test), fill="red", alpha=0.2)

std_error = function(x) sd(x) / sqrt(length(x))

std_error(rmse_test)
std_error(rmse_train)

# n-fold cross validation
nfold_cv = function(df, n_folds) {
  # Make empty predictions vector
  preds = numeric(nrow(df))

  # Calculate the different folds
  folds = sample(nrow(df)) %% n_folds + 1

  for (i in 1:n_folds) {
    # Get subsets of the data
    df_train = df[folds != i, ]
    df_test = df[folds == i, ]

    # Fit linear model to training set
    fit = lm(attr_o ~ ., df_train)

    # Make predictions for other training set
    preds[folds == i] = predict(fit, df_test)
  }

  # Return RMSE
  sqrt(mean((preds - df$attr_o)^2))
}

# Run 100 trials for calculation of RMSE
rmse_2 = numeric(100)
rmse_10 = numeric(100)

for (i in 1:100) {
  print(paste('Iteration', i))
  rmse_2[i] = nfold_cv(df_attr, 2)
  rmse_10[i] = nfold_cv(df_attr, 10)
}

# Plot values of RMSE
df_rmse = data.frame(rmse_2, rmse_10)
ggplot(df_rmse) + geom_histogram(aes(x=rmse_2), alpha=0.3, fill="red") + geom_histogram(aes(x=rmse_10), alpha=0.3, fill="blue")

std_error(rmse_2)
std_error(rmse_10)


# Stepwise regression code by Michael Beese II (heavily modified)

backward_step = function(df) {
  rmse_cv = c()
  rmse_nocv = c()
  n_removed = c()
  n_removed_count = 0
  while (length(colnames(df)) > 1) {
    # Fit model
    model = lm(attr_o ~ ., df)

    # Add cross-validated RMSE estimate
    rmse_cv = c(rmse_cv, nfold_cv(df, 10))

    # Add RMSE for linear regression on whole dataset
    rmse_nocv = c(rmse_nocv, rmse(predict(model, df), df$attr_o))

    # Add # features removed
    n_removed = c(n_removed, n_removed_count)

    # Feature elimination
    sumDF = as.data.frame(summary(model)$coefficients)
    sumDF = cbind(sumDF, rownames(sumDF))
    sumDF = sumDF[-1, ] # remove Intercept column
    maxRow = filter(sumDF, sumDF[4] == max(sumDF[4])) # biggest p-value

    # Eliminate column
    df = select(df, -one_of(as.character(maxRow[[5]])))

    n_removed_count = n_removed_count + 1
  }
  return(data.frame(n_removed=n_removed, rmse_cv=rmse_cv, rmse_nocv=rmse_nocv))
}

step_results = backward_step(df_attr)

# Not a completely smooth plot, but RMSE decreases as
# features are removed and then sharply climbs when you've
# removed ~14 variables
ggplot(step_results) + geom_point(aes(x=n_removed, y=rmse_cv), color="red") + geom_point(aes(x=n_removed, y=rmse_nocv))

# Using the real step() function
backStepOfficial = function(df) {
  responseVars = c("attr_o", "sinc_o","intel_o","fun_o","amb_o")
  finalModels = list()
  for(i in responseVars){
    activities = select(df, one_of(i), sports:yoga)
    f = paste(i,"~.")
    model = lm(f, activities)
    s = step(model, formula(model), direction="backward")
    finalModels[[length(finalModels)+1]] = s
  }
  return(finalModels)
}

# Female vs. male
step_f = backStepOfficial(filter(df, gender==0))
step_m = backStepOfficial(filter(df, gender==1))

# Bootstrap functions

bootstrap_bad = function(df, approach) {
  rmse_sum = 0
  for (i in 1:100) {
    idx_btstrap = sample(1:nrow(df), replace=TRUE)
    df_btstrap = df[idx_btstrap, ]

    if (approach == 1) {
      train = df_btstrap
      test = df
    } else if (approach == 2) {
      train = df
      test = df_btstrap
    }

    # Train model
    model = lm(attr_o ~ ., train)
    preds = predict(model, test)

    rmse_sum = rmse_sum + rmse(preds, df$attr_o)
  }
  rmse_sum / 100
}

backward_step_2 = function(df) {
  rmse_cv = c()
  rmse_nocv = c()
  rmse_btstrap_1 = c()
  rmse_btstrap_2 = c()
  n_removed = c()
  n_removed_count = 0
  while (length(colnames(df)) > 1) {
    # Fit model
    model = lm(attr_o ~ ., df)

    # Add cross-validated RMSE estimate
    rmse_cv = c(rmse_cv, nfold_cv(df, 10))

    # Add RMSE for linear regression on whole dataset
    rmse_nocv = c(rmse_nocv, rmse(predict(model, df), df$attr_o))

    # Add bootstrap RMSE
    rmse_btstrap_1 = c(rmse_btstrap_1, bootstrap_bad(df, approach=1))
    rmse_btstrap_2 = c(rmse_btstrap_2, bootstrap_bad(df, approach=2))

    # Add # features removed
    n_removed = c(n_removed, n_removed_count)

    # Feature elimination
    sumDF = as.data.frame(summary(model)$coefficients)
    sumDF = cbind(sumDF, rownames(sumDF))
    sumDF = sumDF[-1, ] # remove Intercept column
    maxRow = filter(sumDF, sumDF[4] == max(sumDF[4])) # biggest p-value

    # Eliminate column
    df = select(df, -one_of(as.character(maxRow[[5]])))

    n_removed_count = n_removed_count + 1
  }
  return(data.frame(n_removed=n_removed, rmse_cv=rmse_cv, rmse_nocv=rmse_nocv, rmse_btstrap_1=rmse_btstrap_1, rmse_btstrap_2=rmse_btstrap_2))
}

step_results_2 = backward_step_2(df_attr)

ggplot(step_results_2) + geom_point(aes(x=n_removed, y=rmse_cv), color="red") + geom_point(aes(x=n_removed, y=rmse_nocv)) + geom_point(aes(x=n_removed, y=rmse_btstrap_1), color="blue") + geom_point(aes(x=n_removed, y=rmse_btstrap_2), color="green")

bootstrap_good = function(df) {
  rmse_sum = 0
  for (i in 1:100) {
    idx_btstrap = sample(1:nrow(df), replace=TRUE)
    df_btstrap = df[idx_btstrap, ]
    model = lm(attr_o ~ ., df_btstrap)

    preds = predict(model, df[-unique(idx_btstrap), ])
    rmse_sum = rmse_sum + rmse(preds, df$attr_o[-unique(idx_btstrap)])
  }
  rmse_sum / 100
}

backward_step_3 = function(df) {
  rmse_cv = c()
  rmse_nocv = c()
  rmse_btstrap = c()
  n_removed = c()
  n_removed_count = 0
  while (length(colnames(df)) > 1) {
    # Fit model
    model = lm(attr_o ~ ., df)

    # Add cross-validated RMSE estimate
    rmse_cv = c(rmse_cv, nfold_cv(df, 10))

    # Add RMSE for linear regression on whole dataset
    rmse_nocv = c(rmse_nocv, rmse(predict(model, df), df$attr_o))

    # Add bootstrap RMSE
    rmse_btstrap = c(rmse_btstrap, bootstrap_good(df))

    # Add # features removed
    n_removed = c(n_removed, n_removed_count)

    # Feature elimination
    sumDF = as.data.frame(summary(model)$coefficients)
    sumDF = cbind(sumDF, rownames(sumDF))
    sumDF = sumDF[-1, ] # remove Intercept column
    maxRow = filter(sumDF, sumDF[4] == max(sumDF[4])) # biggest p-value

    # Eliminate column
    df = select(df, -one_of(as.character(maxRow[[5]])))

    n_removed_count = n_removed_count + 1
  }
  return(data.frame(n_removed=n_removed, rmse_cv=rmse_cv, rmse_nocv=rmse_nocv, rmse_btstrap=rmse_btstrap))
}

step_results_3 = backward_step_3(df_attr)

ggplot(step_results_3) + geom_point(aes(x=n_removed, y=rmse_cv), color="red") + geom_point(aes(x=n_removed, y=rmse_nocv)) + geom_point(aes(x=n_removed, y=rmse_btstrap), color="blue")

# Use whole dataset for convenience
rmses_btstrap = sapply(1:100, function(x) bootstrap_good(df_attr))
rmses_cv = sapply(1:100, function(x) nfold_cv(df_attr, 10))
qplot(rmses_btstrap) + qplot(rmses_cv)
