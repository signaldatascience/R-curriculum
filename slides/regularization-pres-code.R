library(Rmisc)
library(ggplot2)
set.seed(1); j = 50; a = 0.25
x = rnorm(j); y = a*x + sqrt(1 - a^2)*rnorm(j)
x = scale(x)[,1]; y = scale(y)
summary(lm(y ~ x - 1))
qplot(x, y) + geom_smooth(method = "lm")

cost =  function(x, y, aEst, lambda, p){
  penalty = lambda*abs(aEst)^p
  sqrt(mean((y - aEst*x)^2)) + penalty
}
lambdas = 2^(seq(-8, 5, 1))
as = seq(-0.1, 0.3, by= 0.001)
expanded = expand.grid(lambda = lambdas,a = as)
expanded[c("L2cost", "L1cost")] = 0
for(a in as){
  for(lam in lambdas){
    expanded[expanded$lambda == lam & expanded$a == a,"L1cost"] = cost(x, y, a, lam, p = 1)
    expanded[expanded$lambda == lam & expanded$a == a,"L2cost"] = cost(x, y, a, lam, p = 2)
  }
}

expanded = round(expanded, 3)

plotCost = function(k, costName){
  lambdas = round(lambdas, 3)
  aEst = expanded[expanded$lambda == lambdas[k],"a"]
  error = expanded[expanded$lambda == lambdas[k],costName]
  tempdf = data.frame(aEst, error)
  ggplot(tempdf) + geom_line(aes(aEst, error)) + scale_x_continuous(limits = c(-0.1, 0.3)) + theme_bw()
}


l1costs = lapply(1:10, plotCost, costName = "L1cost")
l2costs = lapply(1:10, plotCost, costName = "L2cost")
x11()
multiplot(plotlist = l1costs, cols = 2)