# Iterative principal component analysis

set.seed(1)
X = matrix(sample(0:1, 100, replace=TRUE), nrow=10)
X = scale(X)

objective = function(w, X) (t(w)%*%t(X)%*%X%*%w)/(t(w)%*%w)

vnorm = function(x) sqrt(sum(x^2))
dot_prod = function(x, y) x*y
vnorm(1:10)

extract_pc = function(X, method) {
  o = optim(rep(1, ncol(X)), objective, control=list(maxit=10000, fnscale=-1), method=method, X=X)
  o$par/vnorm(o$par)
}

prcomp_pc = function(X) prcomp(X)$rotation[,1]

angle = function(x, y) {
  z = acos(sum(dot_prod(x, y))/vnorm(x)/vnorm(y))*360/2/pi
  min(z, 180-z)
}
angle(1:5, 6:10)
angle(1:5, -5:-1)

pc1_a = extract_pc(scale(X), "Nelder-Mead")
pc1_b = prcomp_pc(scale(X))
angle(pc1_a, pc1_b)
pc1_c = extract_pc(scale(X), "BFGS")
angle(pc1_c, pc1_b)

remove_pc = function(Xorig, Xint, pc) {
  Xint - Xorig%*%pc%*%t(pc)
}

extract_all = function(X, method) {
  Xorig = X
  pcs = matrix(nrow=ncol(X), ncol=ncol(X))
  for (i in 1:ncol(X)) {
    pcs[, i] = extract_pc(X, method)
    X = remove_pc(Xorig, X, pcs[, i])
  }
  pcs
}

prcomp_all = function(X) prcomp(X)$rotation

angles_all = function(X, method) {
  a = extract_all(X, method)
  b = prcomp_all(X)
  sapply(1:ncol(X), function(i) angle(a[,i], b[,i]))
}

angles_all(X, "Nelder-Mead")
angles_all(X, "BFGS")
