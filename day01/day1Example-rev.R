### UN INFANT MORTALITY DATA ###

# Write code here to load packages and data

# Write code here to calculate correlations

# Write code here to make a new dataframe with incomplete rows omitted

# Write code here to examine the distribution of the data

# Write code here to take the log transformation of the data

# Write code here to examine the distribution of the log-transformed data

# Good linear fit
ggplot(ldf, aes(gdp, infant.mortality)) + geom_point() + geom_smooth(method = "lm")

# Calculate linear fit of infant mortality vs. GDP
linear_fit = lm(infant.mortality ~ gdp, df)

# Calculate linear fit of log(infant mortality) vs. log(GDP)
loglog_fit = lm(infant.mortality ~ gdp, ldf)

# Plot of linear fit residuals
qplot(df$gdp, linear_fit$residuals)

# Plot of linear fit residuals after log transformation of GDP and infant mortality
qplot(df$gdp, df$infant.mortality - exp(fitted(loglog_fit)))

# Compare simple fit and fit after 
### GALTON HEIGHT DATA ###

