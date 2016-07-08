library(dplyr)
library(ggplot2)
library(glmnet)
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

# L1/L2 regularized fit
fit_l1 = glmnet(activities_scaled, attr_o, alpha=1)
fit_l2 = glmnet(activities_scaled, attr_o, alpha=0)

# Get RMSEs
get_rmses = function(fit, lamb) sqrt(mean((predict(fit, activities_scaled, s=lamb)-attr_o)^2))
rmse_l1 = sapply(fit_l1$lambda, get_rmses, fit=fit_l1)
rmse_l2 = sapply(fit_l2$lambda, get_rmses, fit=fit_l2)

# Plot them
qplot(fit_l1$lambda, rmse_l1)
qplot(fit_l2$lambda, rmse_l2)
