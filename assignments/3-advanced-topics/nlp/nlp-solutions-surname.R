library(caret)
library(glmnet)
library(dplyr)

n_jap = scan('C:/Users/Andrew/Documents/Signal/curriculum/datasets/surnames/japanese.txt', what=character())
n_ger = scan('C:/Users/Andrew/Documents/Signal/curriculum/datasets/surnames/german.txt', what=character())
nl_jap = sapply(n_jap, tolower)
nl_ger = sapply(n_ger, tolower)

lower_to_vec = function(v) as.data.frame(do.call(rbind, lapply(strsplit(v, ""), function(x) table(factor(x, letters)))))
df_nl_jap = lower_to_vec(nl_jap)
df_nl_ger = lower_to_vec(nl_ger)
df_nl = rbind(df_nl_jap, df_nl_ger)
df_nl = df_nl[, sapply(df_nl, function(c) var(c) != 0)]
lbl_nl = factor(c(rep("Japanese", length(n_jap)), rep("German", length(nl_ger))))

caret_class = function(x, y) {
  set.seed(1)
  control = trainControl(method="repeatedcv", repeats=3, number=10, verboseIter=TRUE, classProbs=TRUE, summaryFunction=twoClassSummary)
  grid = expand.grid(alpha=seq(0, 1, 0.1), lambda=2^seq(-4, 1, length.out=20))
  train(x=x, y=y, method="glmnet", tuneGrid=grid, trControl=control, metric="ROC", preProcess=c("center", "scale"))
}

train_nl = caret_class(df_nl, lbl_nl)
