setwd("C:/Users/Andrew/Documents/Signal/curriculum/src/unorganized/hyperparam")
library(readr)
library(dplyr)
library(glmnet)
df_orig = read_csv("training.csv")
df_orig$Depth = as.numeric(factor(df_orig$Depth)) - 1
df_orig$PIDN = NULL
nfolds = 10

# Remove spectra CO2 bands in the region m2379.76 to m2352.76
for (n in names(df_orig)) {
  if (substr(n, 1, 1) == "m") {
    nu = as.numeric(substr(n, 2, nchar(n)))
    if (nu >= 2352.76 & nu <= 2379.76) {
      df_orig[[n]] = NULL
    }
  }
}

target_vars = c("SOC", "pH", "Ca", "P", "Sand")

get_data = function(var) {
  select(df_orig, -one_of(setdiff(target_vars, var)))
}

# Score predictions with RMSE
score_preds = function(preds, var) {
  sqrt(mean((df_orig[[var]] - preds)^2))
}

# Generate preds for var using cross validated regularized regression
cv_reglin = function(var, alpha, lambda) {
  df = get_data(var)

  target = df[[var]]
  features = select(df, -one_of(var))
  preds = numeric(length(target))

  folds = sample(nrow(df)) %% nfolds + 1
  for (fnum in 1:length(unique(folds))) {
    print(fnum)
    features_train = scale(features[folds != fnum, ])
    target_train = target[folds != fnum]
    features_test = scale(features[folds == fnum, ], center=attr(features_train, "scaled:center"), scale=attr(features_train, "scaled:scale"))
    fit = glmnet(features_train, target_train, alpha=alpha, lambda=lambda)
    preds[folds == fnum] = predict(fit, features_test, s=lambda)
  }
  preds
}

# Score regularized elastic net linear regression
cv_reglin_score = function(var, alpha, lambda) {
  score_preds(cv_reglin(var, alpha, lambda), var)
}

# Grid search
values_lambda = 10^seq(-3, -1, length.out=10)
values_alpha = seq(0, 1, length.out=10)
scores_grid = matrix(numeric(length(values_lambda) * length(values_alpha)), nrow=length(values_lambda))
for (i in 1:length(values_lambda)) {
  for (j in 1:length(values_alpha)) {
    print(paste0(as.character(i), ",", as.character(j)))
    scores_grid[i,j] = cv_reglin_score("SOC", alpha=values_alpha[j], lambda=values_lambda[i])
  }
}
