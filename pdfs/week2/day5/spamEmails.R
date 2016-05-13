library(readr)
library(caret)
library(tm)
library(glmnet)
library(quanteda)
library(SnowballC)
library(dplyr)
df = read_csv("~/Desktop/spam-emails.csv")
df = df[order(df[1]),]
vs =VectorSource(df$Message)
vc= VCorpus(vs)
vc <- tm_map(vc, content_transformer(tolower), lazy= TRUE)
vc <- tm_map(vc, content_transformer(removePunctuation), lazy = TRUE)
vc <- tm_map(vc, content_transformer(removeNumbers), lazy = TRUE)
stops = stopwords("en")
for(i in 1:length(vc)){
  vc[[i]] <- removeWords(vc[[i]], stops)
}
arr = sapply(vc, as.character)
d = dfm(arr, verbose = FALSE, ngrams = 1)
sums = colSums(d)
d = d[,sums >= 10]
table(colSums(d))
lines = readLines("~/Desktop/spam-emails-key.txt")
labs = sapply(1:length(lines), function(i){strsplit(lines[i], " ")[[1]][1]})
names = sapply(1:length(lines), function(i){strsplit(lines[i], " ")[[1]][2]})
kdf = data.frame(names, as.numeric(labs))
kdf$names = as.character(kdf$names)
colnames(kdf)[1] = colnames(df)[1]

joined = inner_join(df[1], kdf)

labs = joined[[2]]
grid = expand.grid(alpha = 1, lambda = 2^(-c(0:60)))
tar = factor(labs, labels = c("notSpam", "spam"))
Control <- trainControl(method = "repeatedcv",repeats = 1, verboseIter = T,search = "grid", classProbs = T, summaryFunction = multiClassSummary)
netFit <- train(x = d, y = tar,
                method = "glmnet",
                tuneGrid = grid,
                metric = "logLoss",
                trControl = Control)
tar = ifelse(tar == "spam", 1, 0)
m = glmnet(d, tar , family = "gaussian", lambda = 1.953125e-03 , alpha = 1)
predf = data.frame(df, predict(m, d)[,1])


