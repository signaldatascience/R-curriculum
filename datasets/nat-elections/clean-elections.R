# Adapted from https://github.com/hueykwik/Signal/blob/228d0be4672c8b0ac6ad5f2f6dc58b5a00127fa0/week2/logisticRegression.R

setwd('C:/Users/Andrew/Documents/Signal/curriculum/datasets/nat-elections')

library(foreign)
library(dplyr)
library(dummies)

df = read.dta("elections.dta")
head(df)
str(df) # Lot of NAs

presDf = df %>% select(year, age:religion, vote, presvote) %>% filter(year %% 4 == 0)
lapply(presDf[sapply(presDf,is.factor)], levels)

factor_names = names(presDf[sapply(presDf,is.factor)])

#gender     race    educ1    urban   region   income   occup1    union religion     vote presvote
levels(presDf$gender) = c(NA, "male", "female")
levels(presDf$race) = c("white", "black", "asian", "native american", "hispanic", "other", NA)
levels(presDf$educ1) = c(NA, "grade school", "high school", "some college", "college or higher")
levels(presDf$urban) = c(NA, "central", "suburban", "rural")
levels(presDf$region) = c(NA, "northeast", "north central", "south", "west")
levels(presDf$income) = c(NA, "0-16 %ile", "17-33 %ile", "34-67 %ile", "68-95 %ile", "96-100 %ile")
levels(presDf$occup1) = c(NA, "professional", "clerical", "skilled", "laborer", "farmers", "homemakers")
levels(presDf$union) = c(NA, "yes", "no")
levels(presDf$religion) = c(NA, "protestant", "catholic", "jewish", "other")
levels(presDf$vote) = c(NA, "no", "yes")
levels(presDf$presvote) = c(NA, "democrat", "republican", "other")

# Impute NAs
for (i in 1:ncol(presDf)) {
  col = presDf[[i]]
  if (is.numeric(col)) {
    presDf[is.na(presDf[,i]), i] <- mean(presDf[,i], na.rm = TRUE)
  }
  if (is.factor(col)) {
    n = length(presDf[is.na(presDf[,i]), i])
    non_NAs = na.omit(presDf[,i])
    presDf[is.na(presDf[,i]), i] = sample(non_NAs, n, TRUE)
  }
}
str(presDf$age) # original df has NAs, expect no NAs now
str(presDf$gender)

oldpresDf = presDf
presDf_dummy = dummy.data.frame(presDf, names=factor_names, sep="_")


write.dta(presDf, 'elections-cleaned.dta')

df2 = read.dta('elections-cleaned.dta')
str(df2)
ncol(df2)
names(df2)
sapply(df2, class)
levels(df2$urban)
