# Example of n-fold cross-validation

library(dplyr)
library(ggplot2)

# Load data
setwd('C:/Users/Andrew/Documents/Signal/curriculum/src/week2/day1/')
df = read.csv('speedDatingSimple.csv')
df_attr = select(df, -intel_o, -amb_o, -fun_o, -sinc_o)
df_attr = filter(df, gender==0)

# n-fold predictions
my_cv = function(df, n_folds) {
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
set.seed(1)
rmse_2 = numeric(100)
rmse_10 = numeric(100)

for (i in 1:100) {
  print(paste0("Iteration: ", as.character(i)))
  rmse_2[i] = my_cv(df_attr, 2)
  rmse_10[i] = my_cv(df_attr, 10)
}

# Plot values of RMSE
df_rmse = data.frame(rmse_2, rmse_10)
ggplot(df_rmse) + geom_histogram(aes(x=rmse_2), alpha=0.3, fill="red") + geom_histogram(aes(x=rmse_10), alpha=0.3, fill="blue")
