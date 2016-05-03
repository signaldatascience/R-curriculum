

In certain situations, you might want to subset with a *matrix*. Again, at this point, don't worry too much about what a matrix *is*.

**Exercise.** With the previously defined 10-by-10 data frame, set `df[5, 5] = NA; df[6, 6] = NA`. Figure out how `df[is.na(df)]` works. Write and test a function that takes as input a data frame `df` of purely numeric data and a number `k`, returning a vector of every number in `df` divisible by `k`.