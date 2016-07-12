library(readr)
library(ggplot2)
library(gridExtra)
library(dplyr)
library(glmnet)
df = read_csv("~/Desktop/africanSoil.csv")
n = names(df)
bands = select(df, starts_with("m"))
targets = select(df, Ca:Sand)
others = select(df, BSAN:Depth)

biggestCors = function(name,
                       df1 = bands, 
                       df2 = targets, 
                       sign = 1, number = 5){
  cors = cor(df1, df2)
  corDF = as.data.frame(cors)
  corDF = corDF[order(-sign*corDF[name]),]
  head(corDF[name], number)
}


print("negative correlations")
lapply(names(targets), function(name){biggestCors(name, sign = -1)})

print("positive correlations")
lapply(names(targets), function(name){biggestCors(name, sign = 1)})

#Plot wave numbers
bandNames = names(bands)
waveNums = as.numeric(sapply(bandNames, function(x){
  as.numeric(substr(x, 2, 10))
}))
qplot(waveNums)



#Plot correlations with targets against wave numbers
cors = cor(bands, targets)
corDF = as.data.frame(cors)
plots = lapply(names(targets), function(target){qplot(x = waveNums, 
                                                      y = corDF[[target]] ,
                                                      geom = "point", 
                                                      xlab = "Wave Number",
                                                      ylab = names(corDF[target]))})
plots[[1]]
do.call(grid.arrange, plots)


#Plot coefficients of L^2 regularization along with correlations
m = cv.glmnet(scale(bands),targets$Ca, family ="gaussian", alpha = 0)
ndf = data.frame(waveNums, corrs = cor(bands,targets$Ca)[,1],coefficients = coef(m, m$lambda.min)[-1,1])
ggplot(ndf) + geom_point(aes(x = waveNums, y = corrs, colour="#000099")) + geom_point(aes(x = waveNums, y = 50*coefficients, colour="#CC0000", alpha = 0.1))

