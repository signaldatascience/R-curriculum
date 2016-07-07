# Partial solutions for UN infant mortality / Galton height assignments
# From my own time at Signal in February 2016 
# -- Andrew Ho

library(car)
library(ggplot2)
library(GGally)
df = UN

cor(df)
#Produces NA

#Uses rows with no missing entries
cor(df, use = "pairwise.complete.obs")

#More readable b/c decimals and extra digits are missing
round(100*cor(df, use = "pairwise.complete.obs"))

#Remove rows with missing values
df = df[!is.na(rowSums(df)),]

names(df)
# [1] "infant.mortality" "gdp"             

#Plot histograms and scatter plots of variables
ggpairs(df)

#Plot linear fit: not so good
ggplot(df, aes(gdp, infant.mortality)) + geom_point() + geom_smooth(method = "lm")

#Transform data by taking logarithms of variables
ldf = log(df)

ggpairs(ldf)
#Distributions are closer to normal, correlation has rise from -0.51 to -0.81, scatter plot closer to a line

#Good linear fit
ggplot(ldf, aes(gdp, infant.mortality)) + geom_point() + geom_smooth(method = "lm")

#Compare simple fit and fit after transforming from log/log scale
lin.fit = lm(infant.mortality ~ gdp,df)
df$lin.fit = fitted(lin.fit)
log.fit = lm(infant.mortality ~ gdp,ldf)
df$log.fit = exp(fitted(log.fit))
exp.log.fit = lm(infant.mortality ~ log.fit,df)

#Predictor vs. residuals for  linear fit
qplot(df$gdp, lin.fit$residuals)

#Predictor vs. residuals for  exponential of logarithmic fit
qplot(df$gdp, exp.log.fit$residuals)

# cor2(df1, df2) -- compute correlation matrix for every pair of numeric columns
cor2 = function(df1, df2 = df1) {
  return(round(100*cor(df1, df2, use = "pairwise.complete.obs")))
}

# remove.na.rows(df) -- removes rows with missing values
remove.na.rows = function(df) {
  return(df[!is.na(rowSums(df)),])
}

library(HistData)
data(GaltonFamilies)
#lut = c("male" = 1, "female" = 0)
#GaltonFamilies$gender = lut[GaltonFamilies$gender]
GaltonFamilies$gender = as.numeric(GaltonFamilies$gender)
GaltonFamilies$gender = GaltonFamilies$gender - 1
gf = GaltonFamilies %>%
  group_by(family) %>%
  dplyr::summarise(avg = mean(childHeight), mid = mean(midparentHeight),
                   father = mean(father), mother = mean(mother), count = n(), num_m = sum(gender)) %>%
  dplyr::mutate(pmale = num_m / count)

library(ggplot2)
library(Rmisc)
p1 = ggplot(gf, aes(x = mother, y = avg)) + geom_point(alpha = .3) + ggtitle("Average height vs mother's height")
p2 = ggplot(gf, aes(x = father, y = avg)) + geom_point(alpha = .3) + ggtitle("Average height vs father's height")
p3 = ggplot(gf, aes(x = mid, y = avg)) + geom_point(alpha = .3) + ggtitle("Average height vs midparent's height")
multiplot(p1, p2, p3, cols=2)

cor2(select(gf, -family))

l1 = lm(avg ~ father + mother, data = gf)
l2 = lm(avg ~ mid, data = gf)
summary(l1)$r.squared
summary(l2)$r.squared
summary(l1)$adj.r.squared
summary(l2)$adj.r.squared

l3 = lm(count ~ father + mother + avg, data = gf)
summary(l3)

l4 = lm(pmale ~ father + avg, data = gf)
l5 = lm(pmale ~ mother + avg, data = gf)
l6 = lm(pmale ~ mid + avg, data = gf)
summary(l4)$adj.r.squared
summary(l5)$adj.r.squared
summary(l6)$adj.r.squared

l7 = lm(pmale ~ avg, data = gf)
summary(l7)

p4 = ggplot(gf, aes(x = avg, y = pmale)) + geom_point(alpha = .3) + ggtitle("% male children vs average height")
multiplot(p4)

ggplot(gf, aes(x = count)) + geom_histogram() + ggtitle("Histogram of family size") + scale_x_continuous("Number of children") + scale_y_continuous("Family count")

o1 = lm(childHeight ~ mother, data = GaltonFamilies)
o2 = lm(childHeight ~ father, data = GaltonFamilies)
o3 = lm(childHeight ~ midparentHeight, data = GaltonFamilies)
o4 = lm(childHeight ~ gender, data = GaltonFamilies)
summary(o1)$adj.r.squared
summary(o2)$adj.r.squared
summary(o3)$adj.r.squared
summary(o4)$adj.r.squared

o5 = lm(childHeight ~ mother + father + midparentHeight + gender, data = GaltonFamilies)
summary(o5)$adj.r.squared
o6 = lm(childHeight ~ mother + father + gender, data = GaltonFamilies)
summary(o6)$adj.r.squared
o7 = lm(childHeight ~ midparentHeight + gender, data = GaltonFamilies)
summary(o7)$adj.r.squared

g1 = lm(childHeight ~ mother + father + midparentHeight, data = GaltonFamilies, subset = GaltonFamilies$gender == 1)
summary(g1)$adj.r.squared
g2 = lm(childHeight ~ mother + father + midparentHeight, data = GaltonFamilies, subset = GaltonFamilies$gender == 0)
summary(g2)$adj.r.squared

gf2 = GaltonFamilies %>%
  filter(children >= 2) %>%
  filter(childNum == 1)

gf3 = GaltonFamilies %>%
  filter(children >= 2) %>%
  filter(childNum == 2)

gf2 = dplyr::rename(gf2, childHeight1 = childHeight)
gf2 = dplyr::rename(gf2, gender1 = gender)
gf2$gender = gf3$gender
gf2$childHeight2 = gf3$childHeight
gf2 = mutate(gf2, g = paste(gender1, gender2, sep=""))

s = "01"

c1 = lm(childHeight2 ~ midparentHeight, data = gf2, subset = g == s)
c2 = lm(childHeight2 ~ midparentHeight + childHeight1, data = gf2, subset = g == s)
summary(c1)$adj.r.squared
summary(c2)$adj.r.squared

c3 = lm(childHeight1 ~ midparentHeight, data = gf2, subset = g == s)
c4 = lm(childHeight1 ~ midparentHeight + childHeight2, data = gf2, subset = g == s)
summary(c3)$adj.r.squared
summary(c4)$adj.r.squared

######################

gf4 = GaltonFamilies %>%
  filter(children >= 3) %>%
  filter(childNum == 1)

gf5 = GaltonFamilies %>%
  filter(children >= 3) %>%
  filter(childNum == 2)

gf6 = GaltonFamilies %>%
  filter(children >= 3) %>%
  filter(childNum == 3)

gf4 = dplyr::rename(gf4, childHeight = childHeight)
gf4 = dplyr::rename(gf4, gender1 = gender)
gf4$gender2 = gf5$gender
gf4$gender3 = gf6$gender
gf4$childHeight2 = gf5$childHeight
gf4$childHeight3 = gf6$childHeight
gf4 = mutate(gf4, g = paste(gender1, gender2, gender3, sep=""))

s = "111"

c1 = lm(childHeight ~ midparentHeight, data = gf4, subset = g == s)
c2 = lm(childHeight ~ midparentHeight + childHeight2, data = gf4, subset = g == s)
c3 = lm(childHeight ~ midparentHeight + childHeight3, data = gf4, subset = g == s)
summary(c1)$adj.r.squared
summary(c2)$adj.r.squared
summary(c3)$adj.r.squared

c1 = lm(childHeight2 ~ midparentHeight, data = gf2, subset = g == s)
c2 = lm(childHeight2 ~ midparentHeight + childHeight2, data = gf2, subset = g == s)
c3 = lm(childHeight2 ~ midparentHeight + childHeight3, data = gf2, subset = g == s)
summary(c1)$adj.r.squared
summary(c2)$adj.r.squared
summary(c3)$adj.r.squared

c1 = lm(childHeight3 ~ midparentHeight, data = gf2, subset = g == s)
c2 = lm(childHeight3 ~ midparentHeight + childHeight2, data = gf2, subset = g == s)
c3 = lm(childHeight3 ~ midparentHeight + childHeight3, data = gf2, subset = g == s)
summary(c1)$adj.r.squared
summary(c2)$adj.r.squared
summary(c3)$adj.r.squared
