# An example of the correct code for the simulated data portion of the assignment.

library(corrplot)
library(psych)

# Part 1: PCA

X = rnorm(100)
Y = rnorm(100)
Z = rnorm(100)
factors = data.frame(X, Y, Z)

noisyProxies = function(feature, k, correlation) as.data.frame(do.call(cbind, lapply(1:k, function(x) correlation*feature + sqrt(1-correlation^2)*rnorm(length(feature)))))

noisies = cbind(noisyProxies(X, 4, 0.9), noisyProxies(Y, 3, 0.9))

p_noisies = prcomp(scale(noisies))
corrplot(cor(noisies, p_noisies$x))
corrplot(cor(factors, p_noisies$x))

# Part 2: Orthogonal factor analysis

f_noisies = fa(scale(noisies), nfactors=2, rotate="varimax")
corrplot(cor(factors, f_noisies$scores))

fifty = as.data.frame(do.call(cbind, lapply(1:50, function(x) X*runif(1) + Y*runif(1) + Z*runif(1) + 0.5*rnorm(100))))

p_fifty = prcomp(scale(fifty))
corrplot(cor(factors, p_fifty$x[, 1:3]))

f_fifty = fa(scale(fifty), nfactors=3, rotate="varimax")
corrplot(cor(factors, f_fifty$scores))

# Part 3: Oblique factor analysis

W = 0.5*X + Y
cor(W, X)

wnoisies = cbind(noisyProxies(X, 10, 0.8), noisyProxies(W, 4, 0.8))
corrplot(cor(wnoisies))

f_ortho = fa(scale(wnoisies), nfactors=2, rotate="varimax")
corrplot(cor(factors, f_ortho$scores))

f_obliq = fa(scale(wnoisies), nfactors=2, rotate="oblimin")
corrplot(cor(factors, f_obliq$scores))
