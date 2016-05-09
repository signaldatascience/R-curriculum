library(ggplot2)
library(dplyr)
library(psych)

### Part 1 (Andrew's solution) ###

# Simulate X and Y for 10000 trials
n_trials = 1000000
X = runif(n_trials)
Y = runif(n_trials, max=X)
#qplot(Y, X)

# Do the binning
bin_width = 0.01
n_bins = 1/bin_width
bin_right = 1:n_bins * bin_width
bin_left = bin_right - bin_width
X_bins = sapply(1:n_bins, function(n) mean(X[Y > bin_left[n] & Y < bin_right[n]]))
Y_bins = sapply(1:n_bins, function(n) mean(bin_left[n], bin_right[n]))
qplot(Y_bins, X_bins)

# Plot theoretical result
Y_sim = seq(0, 1, length.out=n_bins)
X_sim = (Y_sim - 1) / log(Y_sim)
qplot(Y_sim, X_sim)

# Plot simulated + theoretical result
df = data.frame(X_bins, Y_bins, X_sim, Y_sim)
ggplot(df) + geom_point(aes(x=Y_bins, y=X_bins)) + geom_smooth(aes(x=Y_sim, y=X_sim))

### Part 1 (Jonah's solution for Monte Carlo simulation) ###

ldf = data.frame(t(sapply(1:1000000, function(i){x = runif(1); y = runif(1)*x; c(x,y)})))
ldf$X2 = round(ldf$X2 , 3)
agged = aggregate(ldf, ldf["X2"], FUN = mean)
agged = agged[1:2]
qplot(agged$X2, agged$X1)

### Part 2 (Andrew's solution) ###

# Load dataset
help(msq)
df = msq

# Compute fraction of missing values
frac_missing = sapply(df, function(col) sum(is.na(col)) / length(col))
frac_missing[order(frac_missing, decreasing=TRUE)]

# Select subset of columns
df = select(df, Extraversion, Neuroticism, active:scornful)

# Replace missing values with column means
for (i in 1:ncol(df)) {
  df[[i]][is.na(df[[i]])] = mean(df[[i]], na.rm=TRUE)
}

# Plots
ggplot(df, aes(x=Extraversion)) + geom_histogram()
ggplot(df, aes(x=Neuroticism)) + geom_histogram()
ggplot(df, aes(x=Extraversion)) + geom_density()
ggplot(df, aes(x=Neuroticism)) + geom_density()
ggplot(df, aes(x=Neuroticism, y=Extraversion)) + geom_point() + geom_smooth()

# Linear fits
fit_neuro = lm(Neuroticism ~ .-Extraversion, df)
fit_extra = lm(Extraversion ~ .-Neuroticism, df)

# Coefficients
top_ten = function(coefs) coefs[order(abs(coefs), decreasing=TRUE)][1:10]
top_ten(coef(fit_neuro))
top_ten(coef(fit_extra))
