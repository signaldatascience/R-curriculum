library(dplyr)
library(glmnet)
setwd('C:/Users/Andrew/Documents/Signal/curriculum/src/week2/day1/')
df = read.csv('speedDatingSimple.csv')
df_attr = select(df, -intel_o, -amb_o, -fun_o, -sinc_o)
attr_o = df$attr_o
n_folds = 10
folds = sample(nrow(df)) %% n_folds + 1
preds_step = numeric(nrow(df))
preds_l1 = numeric(nrow(df))
preds_l2 = numeric(nrow(df))
for (i in 1:n_folds) {
  print(i)
  step_train = df_attr[folds != i, ]
  step_test = df_attr[folds == i, ]
  model_init = lm(attr_o ~ ., step_train)
  model = formula(lm(attr_o ~ ., step_train))
  fit_step = step(model_init, model, direction="backward", trace=0)
  preds_step[folds == i] = predict(fit_step, step_test)
  feat_train = scale(select(df_attr, -attr_o)[folds != i,])
  feat_test = scale(select(df_attr, -attr_o)[folds == i,], center=attr(feat_train, "scaled:center"), scale=attr(feat_train, "scaled:scale"))
  targ_train = attr_o[folds != i]
  fit_l1 = cv.glmnet(feat_train, targ_train, alpha=1, family="gaussian")
  fit_l2 = cv.glmnet(feat_train, targ_train, alpha=0, family="gaussian")
  preds_l1[folds == i] = predict(fit_l1, feat_test, s=fit_l1$lambda.min)
  preds_l2[folds == i] = predict(fit_l2, feat_test, s=fit_l2$lambda.min)
}
rmse = function(a,b) sqrt(mean((a-b)^2))
rmse(attr_o, preds_step)
rmse(attr_o, preds_l1)
rmse(attr_o, preds_l2)


set.seed(1)
latent = rnorm(100)
X = latent/2 + rnorm(100)/2
Y = latent/2 + rnorm(100)/2
cor(X,Y)
