### UN INFANT MORTALITY DATA ###

# Write code here to load packages and data

# Write code here to calculate correlations

# Write code here to make a new dataframe with incomplete rows omitted

# Write code here to examine the distribution of the data

# Write code here to take the log transformation of the data

# Write code here to examine the distribution of the log-transformed data

# Good linear fit
ggplot(ldf, aes(gdp, infant.mortality)) + geom_point() + geom_smooth(method = "lm")

# Compare simple fit and fit after transforming from log/log scale
lin.fit = lm(infant.mortality ~ gdp,df)
df$lin.fit = fitted(lin.fit)
log.fit = lm(infant.mortality ~ gdp,ldf)
df$log.fit = exp(fitted(log.fit))
exp.log.fit = lm(infant.mortality ~ log.fit,df)

#Predictor vs. residuals for  linear fit
qplot(df$gdp, lin.fit$residuals)

#Predictor vs. residuals for  exponential of logarithmic fit
qplot(df$gdp, exp.log.fit$residuals)

### GALTON HEIGHT DATA ###

