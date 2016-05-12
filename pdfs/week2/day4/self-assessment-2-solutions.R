library(ggplot2)
library(dplyr)
library(psych)
library(corrplot)

### REGULARIZATION #############################################################

# Set seed
set.seed(1)

# Choose values of alpha and lambda to search over
alphas = seq(0, 1, length.out=11)
lambdas = 10^seq(1, -3, length.out=50)

# Load data and fill in NAs
df = msq
for (i in 1:length(df)) {
  if (is.numeric(df[[i]])) {
    df[[i]][is.na(df[[i]])] = mean(df[[i]], na.rm=TRUE)
  }
}

# Get features/targets and scale features
features = select(df, active:scornful)
scaled_features = scale(features)
target_extra = df$Extraversion
target_neuro = df$Neuroticism

# Generate folds for the cross validation
n_folds = 10
folds = sample(nrow(features)) %% n_folds + 1

# Generate lists containing the scaled train/test splits for each fold and training data for Extraversion/Neuroticism
train_splits = vector("list", n_folds)
test_splits = vector("list", n_folds)
train_extra = vector("list", n_folds)
train_neuro = vector("list", n_folds)
for (i in 1:n_folds) {
  train_splits[[i]] = scale(features[i != folds, ])
  test_splits[[i]] = scale(features[i == folds, ])
  train_extra[[i]] = target_extra[i != folds]
  train_neuro[[i]] = target_neuro[i != folds]
}

# Make empty dataframe to store columns (alpha, lambda, rmse_extra, rmse_neuro)
results = data.frame()

# RMSE function for (actual, predicted)
rmse = function(x, y) sqrt(mean((x - y)^2))

# Iterate over values of alpha
for (alpha in alphas) {
  print(paste("alpha: ", alpha))

  # Initialize lists to hold the regularized models
  fits_extra = vector("list", n_folds)
  fits_neuro = vector("list", n_folds)

  # Generate the glmnet() models for all n_folds folds
  for (i in 1:n_folds) {
    fits_extra[[i]] = glmnet(train_splits[[i]], train_extra[[i]], alpha=alpha, lambda=lambdas)
    fits_neuro[[i]] = glmnet(train_splits[[i]], train_neuro[[i]], alpha=alpha, lambda=lambdas)
  }

  # Iterate over values of lambda
  for (lambda in lambdas) {
    print(paste("lambda: ", lambda))

    # Initialize predictions for Extraversion and Neuroticism
    preds_extra = numeric(nrow(features))
    preds_neuro = numeric(nrow(features))

    # Loop through the folds, filling in the prediction vectors
    for (i in 1:n_folds) {
      preds_extra[folds == i] = predict(fits_extra[[i]], test_splits[[i]], s=lambda)
      preds_neuro[folds == i] = predict(fits_neuro[[i]], test_splits[[i]], s=lambda)
    }

    # Calculate RMSE values
    rmse_extra = rmse(preds_extra, target_extra)
    rmse_neuro = rmse(preds_neuro, target_neuro)

    # Add data into dataframe
    results = rbind(results, c(alpha, lambda, rmse_extra, rmse_neuro))
  }
}

# Set dataframe column names
colnames(results) = c("alpha", "lambda", "rmse_extra", "rmse_neuro")

# Print out results dataframe
results

# Define function returning leftmost index minimizing a vector
arg_min = function(v) match(min(v), v)[1]

# Best fits for neuroticism and extraversion
optima_extra = results[arg_min(results$rmse_extra), ]
optima_neuro = results[arg_min(results$rmse_neuro), ]

# Train new regularized linear model with optimal parameters
fit_extra = glmnet(scaled_features, target_extra, alpha=optima_extra[[1]], lambda=optima_extra[[2]])
fit_neuro = glmnet(scaled_features, target_neuro, alpha=optima_neuro[[1]], lambda=optima_neuro[[2]])

# Extract coefficients
coef_extra = coef(fit_extra, s=fit_extra$lambda)
coef_neuro = coef(fit_neuro, s=fit_neuro$lambda)

# corrplot()!!!!
coefs = cbind(as.numeric(coef_extra), as.numeric(coef_neuro))
rownames(coefs) = rownames(coef_extra)
colnames(coefs) = c("Extraversion", "Neuroticism")
coefs = coefs[2:nrow(coefs), ]
rows_keep = c()
for (i in 1:nrow(coefs)) {
  if (abs(coefs[i, 1]) > 0.19 | abs(coefs[i, 2]) > 0.19) {
    rows_keep = c(rows_keep, i)
  }
}
coefs = coefs[rows_keep, ]
corrplot(coefs, method="circle", is.corr=FALSE)

### PROBABILITY QUESTIONS ######################################################

# Hashmap collision

n_iter = 10000
data = matrix(numeric(3*n_iter), ncol=3)
my_count = function(x, vec) sum(x == vec)
for (i in 1:n_iter) {
  print(paste("Iteration:", i))
  hash = sample(1:10, replace=TRUE)
  collision_exists = as.numeric(length(hash) > length(unique(hash)))
  num_collisions = sum(sapply(1:10, function(n) ifelse(my_count(n, hash) <= 1, 0, my_count(n, hash) - 1)))
  num_unused = sum(sapply(1:10, function(n) !(n %in% hash)))
  data[i, ] = c(collision_exists, num_collisions, num_unused)
}
colSums(data)/n_iter

# Rolling the dice

roll = function() ceiling(runif(1) * 6)

roll_dice = function() {
  all_rolls = c()
  while (length(unique(all_rolls)) < 6) {
    all_rolls = c(all_rolls, roll())
  }
  length(all_rolls)
}

n_iter = 10000
tmp_sum = 0
for (i in 1:n_iter) {
  print(paste("Iteration: ", i))
  tmp_sum = tmp_sum + roll_dice()
}
tmp_sum/n_iter

# Bobo the amoeba

next_gen = function(n) {
  if (n > 500) {
    return(501)
  }
  if (n == 0) {
    0
  } else {
    n_children = 0
    for (i in 1:n) {
      r = runif(1)

      if (r < 0.25) {
        n_children = n_children + 1
      } else if (r < 0.5) {
        n_children = n_children + 2
      } else if (r < 0.75) {
        n_children = n_children + 3
      }
    }
    n_children
  }
}

n_lineages = 10000
n_gens = 30
pop = matrix(numeric(n_lineages * (n_gens + 1)), ncol=n_lineages)
pop[1, ] = 1
for (i in 1:n_gens) {
  print(paste("Iteration:", i))
  pop[i+1, ] = sapply(pop[i, ], next_gen)
}
alive = matrix(sapply(pop, function(x) ifelse(x > 0, 1, 0)), ncol=n_lineages)
probs = (n_lineages - rowSums(alive)) / n_lineages
qplot(1:(n_gens + 1), probs)
