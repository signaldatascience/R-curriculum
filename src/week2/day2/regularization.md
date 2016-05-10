---
title: Regularized Linear Regression
---

- simulate regularization for case of single predictor variable
- read some exposition in assignment about how glmnet works (calculating for multiple lambdas simultaneously)
- directly use stepwise, L1, L2 regularization on entire dataset and note RMSE (with cv.glmnet())
- calculate cross-validated RMSE for all three
	- make sure to discuss using attributes for scale()
- look at L1/L2 coefficients; interpret
- read about elastic net regression and use caret package to do grid search
	- in later assignment, can implement grid/random search & do fancier stuff for, say, boosting