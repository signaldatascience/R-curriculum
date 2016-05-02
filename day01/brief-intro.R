# Set the random seed for reproducibility
set.seed(1)

# Set arbitrary sample size
n = 1000

# Create "true" latent variables driving variation
TF1 = rnorm(n)
TF2 = rnorm(n)
true_factors = cbind(TF1, TF2)

# Create 10 variables that pick up on the two latent variables

# Initialize ten variables to random noise
df = as.data.frame(lapply(1:10, rnorm, n=n))

# Make the first eight variables pick up on TF1
df[1:8] = lapply(df[1:8], function(c) (c + TF1))

# Make the last two variables pick up on TF2
df[9:10] = lapply(df[9:10], function(c) (c + TF2))

names(df) = sapply(1:10, as.character)

# Run factor analysis on the data with 2 factors
f = factanal(df, factors=2, scores="regression")

# View correlations
corrplot(cor(cbind(df, f$scores)))
corrplot(cor(cbind(true_factors, f$scores)))
