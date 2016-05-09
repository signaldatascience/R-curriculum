library(ggplot2)

### Part 1 ###

# Simulate X and Y for 10000 trials
n_trials = 10000
X = runif(n_trials)
Y = runif(n_trials, max=X)
qplot(Y, X)

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

### Part 2 ###
