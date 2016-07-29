library(ggplot2)
library(plyr)
library(pryr)
library(tictoc)
library(MASS)
library(klaR)
library(dplyr)
library(e1071)
select = dplyr::select

# Create simulated data functions
lin_pair = function(m, b, label) {
  cond = FALSE
  while (!cond) {
    x = runif(1)
    y = runif(1)
    cond = label * y > label * (m*x + b)
  }
  c(x, y)
}

df_test = as.data.frame(do.call(rbind, lapply(1:200, function(x) lin_pair(2, -0.3, 1))))
names(df_test) = c("x", "y")
qplot(df_test$x, df_test$y)

quad_pair = function(a, b, c, label) {
  cond = FALSE
  while (!cond) {
    x = runif(1)
    y = runif(1)
    cond = label * y > label * (a*(x - b)^2 + c)
  }
  c(x, y)
}

# Load Iris dataset
df_iris = iris

ggplot(df_iris, aes(Sepal.Length, Sepal.Width, color=Species)) + geom_point()
ggplot(df_iris, aes(Sepal.Length, Petal.Length, color=Species)) + geom_point()
ggplot(df_iris, aes(Sepal.Length, Petal.Width, color=Species)) + geom_point()
ggplot(df_iris, aes(Sepal.Width, Petal.Length, color=Species)) + geom_point()
ggplot(df_iris, aes(Sepal.Width, Petal.Width, color=Species)) + geom_point()
ggplot(df_iris, aes(Petal.Length, Petal.Width, color=Species)) + geom_point()

# Load wine dataset
df_wine = read.csv('C:/Users/Andrew/Documents/Signal/curriculum/datasets/wine-cultivars/wine.data')

# Discriminant analysis

# Simulated data analysis
set.seed(1)
n = 100

upper = do.call(rbind, rlply(n, partial(lin_pair, 0.75, 0.05, 1)))
lower = do.call(rbind, rlply(n, partial(lin_pair, 0.75, -0.1, -1)))
linearda_data = as.data.frame(rbind(upper, lower))
linearda_labels = factor(c(rep(1, n), rep(-1, n)))
qplot(linearda_data[,1], linearda_data[,2], color=linearda_labels)

upper = do.call(rbind, rlply(n, partial(quad_pair, 4, 0.5, 0.4, 1)))
lower = do.call(rbind, rlply(n, partial(quad_pair, 4, 0.5, 0.38, -1)))
quadda_data = as.data.frame(rbind(upper, lower))
quadda_labels = factor(c(rep(1, n), rep(-1, n)))
qplot(quadda_data[,1], quadda_data[,2], color=quadda_labels)

partimat(linearda_data, linearda_labels, method="lda")
partimat(linearda_data, linearda_labels, method="qda")

partimat(quadda_data, quadda_labels, method="lda")
partimat(quadda_data, quadda_labels, method="qda")

# LDA/QDA on wine dataset
wine_features = select(df_wine, -Type)
wine_cultivar = factor(df_wine$Type)
wine_lda = lda(wine_features, wine_cultivar)
wine_ldapreds = predict(wine_lda)
ldahist(wine_ldapreds$x[,1], wine_cultivar)
ldahist(wine_ldapreds$x[,2], wine_cultivar)
qplot(wine_ldapreds$x[,1], wine_ldapreds$x[,2], color=wine_cultivar)
wine_pc = prcomp(wine_features, scale.=TRUE)
qplot(wine_pc$x[,1], wine_pc$x[,2], color=wine_cultivar)

# Iris stuff (not part of assignment)
iris_features = select(df_iris, -Species)
iris_species = df_iris$Species
iris_pc = prcomp(iris_features, scale.=TRUE)
iris_lda = lda(iris_features, iris_species)
iris_ldap = predict(iris_lda)
qplot(iris_ldap$x[,1], iris_ldap$x[,2], color=iris_species)
qplot(iris_pc$x[,1], iris_pc$x[,2], color=iris_species)

p_iris = prcomp(select(df_iris, -Species), scale.=TRUE)
qplot(p_iris$x[,1], p_iris$x[,2], color=df_iris$Species)

par(mar=c(1,1,1,1))
pcx = p_iris$x[,1:2]
pcx_lda = lda(pcx, df_iris$Species)
pcx_qda = qda(pcx, df_iris$Species)
preds_lda = predict(pcx_lda)
preds_qda = predict(pcx_qda)
ldahist(preds_lda$x[,1], df_iris$Species)
ldahist(preds_qda$x[,2], df_iris$Species)

# Perceptron

# Generate data
set.seed(1)
n = 2000
upper = do.call(rbind, rlply(n/2, partial(lin_pair, 1.5, 0.2, 1)))
lower = do.call(rbind, rlply(n/2, partial(lin_pair, 1.5, 0.05, -1)))
mat_pt = rbind(upper, lower)
labels_pt = c(rep(1, n/2), rep(-1, n/2))
qplot(mat_pt[,1], mat_pt[,2], color=labels_pt)
mat_pt = cbind(mat_pt, rep(1, n))

# Dot product function
dot = function(x, y) sum(x*y)

# Perceptron algorithm implementation
perceptron = function(xs, y, w, rate, seed) {
  set.seed(seed)
  for (i in sample(nrow(xs))) {
    xi = xs[i, ]
    if (y[i] == 1 & dot(w, xi) <= 0) {
      w = w + rate*xi
    } else if (y[i] == -1 & dot(w, xi) >= 0) {
      w = w - rate*xi
    }
  }
  w
}

# Plotting results of perceptron
perceptron_plot = function(xs, y, w) {
  qplot(xs[,1], xs[,2], color=y) + geom_abline(intercept=-w[3]/w[2], slope=-w[1]/w[2])
}

w = perceptron(mat_pt, labels_pt, rep(0, 3), 1, 6)
perceptron_plot(mat_pt, labels_pt, w)
w = perceptron(mat_pt, labels_pt, w, 1, 6)
perceptron_plot(mat_pt, labels_pt, w)
w = perceptron(mat_pt, labels_pt, w, 1, 6)
perceptron_plot(mat_pt, labels_pt, w)

# Run perceptron() until convergence
perceptron_conv = function(xs, y, rate, seed) {
  w = NULL
  w_new = rep(0, ncol(xs))
  while (!identical(w, w_new)) {
    w = w_new
    w_new = perceptron(xs, y, w, rate, seed)
  }
  w
}

perceptron_conv_plot = function(xs, y, rate, seed) {
  w = perceptron_conv(xs, y, rate, seed)
  perceptron_plot(xs, y, w)
}

perceptron_conv_plot(mat_pt, labels_pt, 1, 1)
perceptron_conv_plot(mat_pt, labels_pt, 1, 2)
perceptron_conv_plot(mat_pt, labels_pt, 1, 3)
perceptron_conv_plot(mat_pt, labels_pt, 1, 4)
perceptron_conv_plot(mat_pt, labels_pt, 1, 5)
perceptron_conv_plot(mat_pt, labels_pt, 1, 6)
perceptron_conv_plot(mat_pt, labels_pt, 1, 7)
perceptron_conv_plot(mat_pt, labels_pt, 1, 8)
perceptron_conv_plot(mat_pt, labels_pt, 1, 9)
perceptron_conv_plot(mat_pt, labels_pt, 1, 10)

# Make smaller dataset
set.seed(1)
n = 20
upper = do.call(rbind, rlply(n/2, partial(lin_pair, 1.5, 0.2, 1)))
lower = do.call(rbind, rlply(n/2, partial(lin_pair, 1.5, 0.05, -1)))
mat_small_pt = rbind(upper, lower)
mat_small_pt = cbind(mat_small_pt, rep(1, n))
labels_small_pt = c(rep(1, n/2), rep(-1, n/2))

perceptron_conv_plot(mat_small_pt, labels_small_pt, 1, 1)
perceptron_conv_plot(mat_small_pt, labels_small_pt, 1, 2)
perceptron_conv_plot(mat_small_pt, labels_small_pt, 1, 3)
perceptron_conv_plot(mat_small_pt, labels_small_pt, 1, 4)
perceptron_conv_plot(mat_small_pt, labels_small_pt, 1, 5)
perceptron_conv_plot(mat_small_pt, labels_small_pt, 1, 6)

# Function to time the perceptron
perceptron_time = function(xs, y, rate) {
  seeds = 1:100
  tot_time = 0
  for (s in seeds) {
    tic()
    w = perceptron_conv(xs, y, rate, s)
    t = toc(quiet=TRUE)
    tot_time = tot_time + t$toc - t$tic
  }
  tot_time / length(seeds)
}

rates = 10^seq(-1, 2, length.out=20)
times = rep(0, length(rates))
times_small = rep(0, length(rates))
for (i in seq_along(rates)) {
  times[i] = perceptron_time(mat_pt, labels_pt, rates[i])
  times_small[i] = perceptron_time(mat_small_pt, labels_small_pt, rates[i])
}
qplot(rates, times)
qplot(rates, times_small)

# Perceptron on quad_pair() data
set.seed(1)
n = 2000
qupper = do.call(rbind, rlply(n/2, partial(quad_pair, a=3, b=0.5, c=0.55, label=1)))
qlower = do.call(rbind, rlply(n/2, partial(quad_pair, a=3, b=0.5, c=0.4, label=-1)))
quad_pt = rbind(qupper, qlower)
quadlbl_pt = c(rep(1, n/2), rep(-1, n/2))
qplot(quad_pt[,1], quad_pt[,2], color=quadlbl_pt)
quad_pt = cbind(quad_pt, rep(1, n))
perceptron_conv(quad_pt, quadlbl_pt, 1, 1)

# Perceptron on Iris data
df_iris_nonsep = filter(df_iris, Species != "setosa")
df_species = select(df_iris_nonsep, starts_with("Sepal"))
df_species = cbind(df_species, rep(1, nrow(df_species)))
lbl_species = as.numeric(df_iris_nonsep$Species) - 2
w = perceptron_conv(df_species, lbl_species, 1, 1)
perceptron_plot(df_species, lbl_species, unlist(w))

# Support vector machines
# This section of the solution needs major revision
df3 = as.data.frame(df)
df3$label = factor(labels)
names(df3) = c('X', 'Y', 'label')
m = svm(label ~ ., df3, kernel="linear", scale=FALSE, cost=10000000)
plot(m, df3)
p = predict(m, df3)
sum(sign(as.numeric(as.character(p))) == labels)

t = tune.svm(df, labels)

n = 40
qupper = do.call(rbind, rlply(n/2, partial(quad_pair, a=3, b=0.5, c=0.55, label=1)))
qlower = do.call(rbind, rlply(n/2, partial(quad_pair, a=3, b=0.5, c=0.4, label=-1)))
qdf = as.data.frame(rbind(qupper, qlower))
qdf$label = c(rep(1, n/2), rep(-1, n/2))
names(qdf) = c('X', 'Y', 'label')
qdf$label = factor(qdf$label)
qplot(qdf$X, qdf$Y, color=qdf$label)
qsvm = svm(label ~ ., qdf, kernel="sigmoid")
plot(qsvm, qdf)
