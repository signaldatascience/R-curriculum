library(dplyr)
library(corrplot)
library(glmnet)
df = read.csv('~/Desktop/speedDatingSimple.csv')
women = df %>% filter(gender == 0) %>% select(-gender, -X)
men = df %>% filter(gender == 1) %>% select(-gender, -X)

getCoefficients = function(df){
  targets = select(df, attr_o:amb_o)
  features = select(df, sports:yoga)
  s = scale(features)
  l = lapply(targets, function(tar){
    m = cv.glmnet(s, tar)
    data.frame(as.matrix(round(coef(m, m$lambda.min),2 )))
  })  
  adf = as.data.frame(l)
  colnames(adf)
  colnames(adf) = names(targets)
  as.matrix(adf[-1,])
}
corrplot(getCoefficients(women), is.corr = F)
corrplot(getCoefficients(women), is.corr = F)