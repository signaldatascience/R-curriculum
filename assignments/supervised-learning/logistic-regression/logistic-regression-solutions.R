setwd('C:/Users/Andrew/Documents/Signal/curriculum/datasets/speed-dating')

library(pROC)
library(dplyr)
library(glmnet)

df = read.csv('speeddating-aggregated.csv')
sum(!complete.cases(df))
sum(!complete.cases(df)) / nrow(df)
df = na.omit(df)

to_probs = function(v) exp(v) / (1 + exp(v))

# Unregularized logistic regression

fit_gender = glm(gender ~ ., select(df, gender, sports:yoga), family="binomial")
fit_gender
probs_gender = to_probs(predict(fit_gender, df))
roc_gender = roc(df$gender, probs_gender)
plot(roc_gender)

df_career = filter(df, career_c %in% c(2, 7))
df_career$career_c = factor(df_career$career_c)
fit_career = glm(career_c ~ ., select(df_career, career_c, sports:yoga), family="binomial")
fit_career
probs_career = to_probs(predict(fit_career, df_career))
roc_career = roc(df_career$career_c, probs_career)
plot(roc_career)
x
df_race = filter(df, race %in% c(2, 4))
df_race$race = factor(df_race$race)
fit_race = glm(race ~ ., select(df_race, race, sports:yoga), family="binomial")
fit_race
probs_race = to_probs(predict(fit_race, df_race))
roc_race = roc(df_race$race, probs_race)
plot(roc_race)

# Regularized logistic regression

ct = model.matrix(~ .*. + 0, select(df, sports:yoga))
ct = scale(ct)
fg2 = cv.glmnet(ct, df$gender, alpha=1, family="binomial")
c = coef(fg2, s=fg2$lambda.min)
c[c[, 1] != 0, ]
pg = to_probs(predict(fg2, ct, s=fg2$lambda.min))
rg = roc(df$gender, pg[, 1])
plot(rg)

# Other stuff (can ignore)

df_career = filter(df, career_c %in% c(2, 7))
ratings = select(df_career, attr_o:amb_o)
cross_terms = model.matrix(~ . *.* + 0, ratings)
features = cbind(cross_terms, df_career$gender)
features = scale(features)
df_career$career_c = ifelse(df_career$career_c == 2, 0, 1)

fit_noreg = glm(features, df_career$career_c, family="binomial")

df_race = filter(df, race %in% c(2, 4))
df_activities = select(df_race, sports:yoga)
cross_terms = model.matrix(~ .*. + 0, df_activities)
cross_terms = scale(cross_terms)
fit_race_2 = cv.glmnet(cross_terms, df_race$race, alpha=1, family="binomial")
c = coef(fit_race_2, s=fit_race_2$lambda.min)
c[c[, 1] != 0, ]
probs_race_2 = to_probs(predict(fit_race_2, cross_terms, s=fit_race_2$lambda.min))
roc_race_2 = roc(df_race$race, probs_race_2[, 1])
plot(roc_race_2)
