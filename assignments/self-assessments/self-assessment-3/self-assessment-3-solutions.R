setwd("~/Desktop")
library(dummies)
library(dplyr)
library(pROC)
library(glmnet)
library(caret)
library(ggplot2)
library(psych)

#NES analysis

df = read.csv("nes_cleaned_1992.csv")
#Remove voters who didn't vote republican or democrat
df = filter(df, vote %in% "no" | presvote %in% c("republican", "democrat"))
#Removes unused levels in factor
df$presvote = factor(df$presvote)
features = dummy.data.frame(df[1:10], sep = "_")
n = names(features)
n
#Remove one dummy for each feature
features = features[n[c(-3, -7, -12, -13, -16, -22, -25, -31, -35)]]
#Scale features
bound = cbind(df["presvote"], scale(features))
m = glm(presvote ~ . , bound[!is.na(bound$presvote),], family = "binomial")
summary(m)
#remove intercept
coefs = coef(m)[-1]
#Order coefficients by size
coefs[order(abs(coefs), decreasing = T)]
# Plot ROC and compute area under it
tar = bound[!is.na(bound$presvote),"presvote"]
r = roc(tar, fitted(m))
plot(r); r
#Generate predictions for nonvoters
preds = predict(m, bound[is.na(bound$presvote),])
#Convert predictions from log odds ratios to probabilities
probs = exp(preds)/(1 + exp(preds))
#Convert probabilities to binary predictions
bins = ifelse(probs >= 0.5, "republican", "democrat")
#Compute proportion of predicted republican votes amongst those who didn't vote
table(bins)/length(bins)
#Compare with proportion of actual republican voters
table(tar)/length(tar)



#National Merit Twin Study



df = read.csv("NMSQT.csv")
codes = read.csv("NMSQTcodebook.csv")
head(df)

#CPI quetions
s = scale(df[-4:0])
#Target variable
tar = df$NMSQT

#Use the caret package for selecting hyperparameters
grid = expand.grid(lambda = (1.2)^(seq(-20, 10, 1)), alpha = seq(0, 1, 0.1))
Control <- trainControl(method = "repeatedcv",
                        repeats = 1, 
                        number = 10,
                        verboseIter = T,
                        search = "grid")
netFit <- train(x =s, y = tar,
                method = "glmnet",
                tuneGrid = grid,
                trControl = Control)
best  = netFit$bestTune
#Train best model to extract coefficients
m = glmnet(s, tar, alpha = best[["alpha"]], lambda = best[["lambda"]])

#Get coefficients other than intercept
coefs = coef(m)[-1,1]

#Make a dataframe with question text and coefficients
coefs = cbind(codes[2], coefs)
#Get questions with largest coefficients
head(coefs[order(-abs(coefs[2])), ], 50)


#Make a scree plot
p = prcomp(s)
qplot(1:100,p$sdev[1:100])

#Factor analysis on the personality questions

#Use 14 factors to be conservative and not lose information
f = fa(s, 14, rotate = "oblimin", fm = "pa")

#Factor scores as a dataframe
fdf = as.data.frame(f$scores)

#Get questions with the highest loadings for each factor
l = lapply(1:14, function(i){
  tdf = data.frame(codes[2] ,loading = f$loadings[,i])
  tdf = tdf[order(-abs(tdf[2])),]
  head(tdf, 10)
})

#Name factors
colnames(fdf) = c("introverted", 
                  "troubled", 
                  "machiavellian", 
                  "masculine", 
                  "unhappyHome", 
                  "valuesProperBehavior", 
                  "bitter", 
                  "partier", 
                  "intellectualArtistic",
                  "careful",
                  "planner",
                  "tempermental", 
                  "fearful",
                  "noise")

#Scale factors
fdf[] = scale(fdf)

#Compute gender averages
agged = aggregate(fdf, df["SEX"], FUN = mean)
agged[-1] = round(agged[-1], 2)
agged

#Compute correlationes between corresponding twins
fdf = data.frame(df[c("ID", "ZYG")], df["NMSQT"],fdf)
fdf$ID
fdf = fdf[order(fdf["ID"]),]
fdf$ID

#Two dataframes, one with 
ones = fdf[seq(1, nrow(fdf), 2),]
twos = fdf[seq(2, nrow(fdf), 2),]

identicalCors = sapply(names(fdf)[-2:0], function(name){cor(
  ones[ones$ZYG == "identical",name], 
  twos[twos$ZYG == "identical", name])
  }
)
fraternalCors = sapply(names(fdf)[-2:0], function(name){cor(
  ones[ones$ZYG == "fraternal",name], 
  twos[twos$ZYG == "fraternal", name])
  }
)

#Compute additive genetic variation associated with each factor
cors = data.frame(identicalCors, fraternalCors)
cors$additiveGenetic = 2*(cors$identicalCors - cors$fraternalCors)
cors = round(cors, 2)
cors$additiveGenetic = 100*cors$additiveGenetic
cors[3]
