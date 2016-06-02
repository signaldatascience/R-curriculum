library(plyr)
library(ggplot2)

get_pair = function(m, b, label) {
  cond = FALSE
  while (!cond) {
    x = runif(1)
    y = runif(1)
    cond = label * y > label * (m*x + b)
  }
  c(x, y)
}
dot = function(x, y) as.numeric(t(x) %*% y)

quad_pair = function(a, b, c, label) {
  cond = FALSE
  while (!cond) {
    x = runif(1)
    y = runif(1)
    cond = label * y > label * (a*(x - b)^2 + c)
  }
  c(x, y)
}

perceptron = function(xs, y, w, rate, niter=nrow(xs)) {
  for (i in sample(nrow(xs), niter, replace=TRUE)) {
    xi = xs[i, ]
    if (y[i] == 1 & dot(w, xi) <= 0) {
      w = w + rate * xi
    } else if (y[i] == -1 & dot(w, xi) >= 0) {
      w = w - rate * xi
    }
  }
  w
}

perceptron_conv = function(xs, y, rate) {
  w = rep(0, ncol(xs))
  run = 0
  i = 0
  while (run < nrow(xs)) {
    i = i + 1
    wnew = perceptron(xs, y, w, rate, niter=1)
    if (sqrt(sum((w-wnew)^2)) < 1e-10) {
      run = run + 1
    } else {
      run = 0
    }
    w = wnew
  }
  list(weights=w, niter=i)
}

set.seed(1)
n = 2000
upper = do.call(rbind, rlply(n/2, partial(get_pair, m=1.5, b=0.2, label=1)))
lower = do.call(rbind, rlply(n/2, partial(get_pair, m=1.5, b=0.05, label=-1)))
df = rbind(upper, lower)
df2 = cbind(df, rep(1, nrow(df)))
labels = c(rep(1, n/2), rep(-1, n/2))
qplot(df[,1], df[,2], color=labels)

set.seed(3)
w = perceptron_conv(df2, labels, 0.001)$weights
qplot(df[,1], df[,2], color=labels) + xlim(0, 1) + ylim(0, 1) + geom_abline(intercept=-w[3]/w[2], slope=-w[1]/w[2])

set.seed(5)
w = perceptron(df2, labels, c(0, 0, 0), 1)
w = perceptron(df2, labels, w, 1)
w = perceptron(df2, labels, w, 1)
qplot(df[,1], df[,2], color=labels) + xlim(0, 1) + ylim(0, 1) + geom_abline(intercept=-w[3]/w[2], slope=-w[1]/w[2])

fit_lda = lda(df, labels)
qplot(df[,1], df[,2], color=labels) + xlim(0, 1) + ylim(0, 1) + geom_abline(intercept=0, slope=0)

assign = sign(sapply(1:n, function(i) dot(w, df2[i, ])))

df2 = as.data.frame(df)
names(df2) = c('X', 'Y', 'label')
fit = glm(label ~ ., df2, family="binomial")

library(e1071)
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

