library(ggplot2)
library(dplyr)
df = read.csv("~/Desktop/speedDating.csv")

probs = seq(0.01, 0.99, by = 0.001)
qplot(probs)
ors = probs/(1 - probs)
qplot(ors)
lors = log(ors)
qplot(lors, bins = 30)
ldf = select(df, iid, gender, career_c, dec_o, like_o, race, race_o,sports:yoga)
ldf$gender = factor(ldf$gender, levels = 0:1)


agged = aggregate(ldf, ldf["iid"], FUN = mean, na.rm = T)
m = lm(dec_o ~ like_o, ldf)
probs = exp(predict(m))/(1 + exp(predict(m)))
ldf[!is.na(ldf$like_o),"lmProbs"] = probs


m = glm(dec_o ~ like_o, ldf, family = "binomial")

summary(m)

probs = exp(predict(m))/(1 + exp(predict(m)))
ldf[!is.na(ldf$like_o),"logisticProbs"] = probs


agged = aggregate(ldf[c("dec_o", "lmProbs", "logisticProbs")], ldf[c("like_o")], FUN = mean, na.rm = T)
agged = agged[agged$like_o %in% 1:10,]

g = ggplot(agged) + geom_point(aes(like_o, dec_o))
g + geom_hline(yintercept = 1) 
g + geom_smooth(aes(like_o, lmProbs))
g + geom_smooth(aes(like_o, logisticProbs))

#LOG = a*like_o + b
#log(p/(1 - p)) = a*like_o + b
#p = exp(a*like_o + b)/(1  + exp(a*like_o + b))
agged = aggregate(ldf[c("dec_o","lmProbs", "logisticProbs")], ldf[c("like_o")], FUN = mean, na.rm = T)
g = ggplot(agged, aes(like_o, dec_o)) + geom_point()
ldf$raceAsian = ifelse(ldf$race == 4, 1, 0)
ldf$race_oAsian = ifelse(ldf$race_o == 4, 1, 0)
ldf = ldf[ldf$gender == 1,]
dim(ldf)

agged = aggregate(ldf["race"], ldf["iid"], FUN = mean)

table(agged$race)
mdf = ldf[c("dec_o", "raceAsian", "race_oAsian")]
mdf = mdf[!is.na(rowSums(mdf)),]
m = glm(dec_o ~ raceAsian*race_oAsian,mdf, family = "binomial")
probs = fitted(m)
actual = mdf$dec_o
actual
logLoss = function(actual, predicted){
  losses = -actual*log(predicted) -(1 - actual)*log(1 - predicted)
  mean(losses)
}
library(pROC)

r = roc(actual,probs)
plot(r)
mdf = data.frame(m$fitted.values, mdf)
mdf


#Log loss 
#Make prediction with probability p
#If prediction is true your score is -log(p)
#If prediction is false your score is -log(1 - p)
