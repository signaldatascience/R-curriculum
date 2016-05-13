library(foreign)
df = read.dta("~/Desktop/nes/nes5200_processed_voters_realideo.dta")
names(df)
names(df)
df = select(df, year, age:religion, vote, presvote)
levels(df$gender) = c(NA, "male", "female")
levels(df$race) = c("white" ,"black", "asian", "nativeAmerican", "hispanic", "other", NA)
levels(df$educ1) = c(NA, "gradeSchool", "highSchool", "someCollege", "college")
levels(df$urban) = c(NA, "city", "suburb", "rural")
levels(df$region) = c(NA, "northEast", "northCentral", "south", "west")
levels(df$income) = c(NA, 16, 33, 67, 95, 100)
levels(df$occup1) = c(NA, "professional", "clerical", "skilled", "laborer", "farmer", "homemaker")
levels(df$union) = c(NA, "yes", "no")
levels(df$religion) = c(NA, "protestant", "catholic", "jewish", "other")

levels(df$vote) = c(NA, "no", "yes")
levels(df$presvote)= c(NA, "democrat", "republican", "other")
df[c("educ1", "income")] = lapply(df[c("educ1", "income")], function(fact){as.numeric(fact)})
ldf = filter(df, year == 1992, presvote %in% c("democrat", "republican"), !is.na(gender), !is.na(race))
tar = ldf$presvote
tar = factor(tar)
ldf = ldf[-c(1, 12, 13, 14)]

library(dummies)
dums = dummy.data.frame(ldf[sapply(ldf, is.factor)])
grid = expand.grid(alpha = seq(0, 1, 0.1), lambda = 2^(-c(0:60)))

bound = cbind(ldf[c("age", "educ1", "income")], dums)
colSums(is.na(bound))
bound$income = ifelse(is.na(bound$income), mean(bound$income, na.rm = T), bound$income)
bound$educ1 = ifelse(is.na(bound$educ1), mean(bound$educ1, na.rm = T), bound$educ1)

Control <- trainControl(method = "repeatedcv",repeats = 1, verboseIter = T,search = "grid", classProbs = T, summaryFunction = twoClassSummary)
netFit <- train(x = bound, y = tar,
                method = "glmnet",
                tuneGrid = grid,
                metric = "ROC",
                trControl = Control)
netFit
