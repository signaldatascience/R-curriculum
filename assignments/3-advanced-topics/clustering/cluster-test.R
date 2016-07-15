setwd('C:/Users/Andrew/Documents/Signal/curriculum/src/week4/day4')
library(readr)
df = read_delim('protein.txt', '\t')
s = scale(df[-1])
rownames(s) = df[[1]]
d = dist(s)
h = hclust(d, method="ward.D2")
plot(h)
library(pvclust)
tr = t(df[-1])
colnames(tr) = df[[1]]
p2 = pvclust(t(s), method.hclust="ward.D2", method.dist="euclidean")
plot(p2)
pvrect(p2, alpha=0.95)

k = kmeans(s, 5)

library(fpc)
ks1 = kmeansruns(s, 1:10, criterion="ch")
ks2 = kmeansruns(s, 1:10, criterion="asw")
qplot(1:10, ks2$crit)

library(cluster)
library(HSAUR)
dissE = daisy(s)
dE2 = dissE^2
sk2 = silhouette(k$cluster, dE2)
plot(sk2)

plotcluster(s, k$cluster)
clusplot(s, kmeans(s,5)$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

library(mixtools)
m = Mclust(s)

g = normalmixEM(df$waiting, k=3)
plot(g, which=2)
lines(density(df$waiting))

of = faithful
g = spEMsymloc(of$waiting, mu0=4, bw=1)
plot(g)

g = mvnormalmixEM(s, k=2)
plot(g, which=2)

g = mvnormalmixEM(scale(faithful), k=2)
plot(g, density=TRUE)

g = npEM(scale(faithful), mu0=2, bw=1)
plot(g)

g = npEM(s, mu0=4)
plot(g)

c = clusterboot(s, clustermethod=kmeansCBI, runs=100, iter.max=100, krange=5)
c$result$partition
clusplot(s, c$result$partition, color=TRUE, shade=TRUE, labels=2, lines=0)
c$bootmean
c$bootbrd

library(tsne)
t = tsne(s, k=6)
qplot(t[, 1], t[, 2])

library(Rtsne)
set.seed(1)
t = Rtsne(s, dims=2, perplexity=5)
plot(t$Y)
text(t$Y, labels=rownames(s))
