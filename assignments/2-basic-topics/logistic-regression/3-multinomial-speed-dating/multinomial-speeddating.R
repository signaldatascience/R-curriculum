library(readr)
library(dplyr)
library(glmnet)
setwd('C:/Users/Andrew/Documents/Signal/curriculum/src/week2/day4')
df = read_csv('speeddating-aggregated.csv')

subset1 = filter(df2, career_c %in% c(1, 2, 6, 7))
subset1_act = select(subset1, sports:yoga)
fit = glmnet(scale(subset1_act), subset1$career_c, family="multinomial", lambda=0)
betas = do.call(cbind, fit$beta)
colnames(betas) = c('lawyer', 'academia', 'arts', 'finance')
betas
p = prcomp(as.data.frame(predict(fit, scale(subset1_act))), scale.=TRUE)
p$rotation

