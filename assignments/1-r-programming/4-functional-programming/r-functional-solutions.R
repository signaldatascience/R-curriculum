# lapply problems
df_class = function(df) lapply(df, class)
df_class(mtcars)

df_standardize = function(df) data.frame(lapply(df, function(x) (x-mean(x))/sd(x)))
df_standardize(mtcars)

df_standardize_numeric = function(df) data.frame(lapply(df, function(x) ifelse(sapply(x, is.numeric), (x-mean(x))/sd(x), x)))
df = data.frame(matrix(1:100, nrow=10))
df[1:5] = lapply(df[1:5], as.character)
df_standardize_numeric(df)

my_lapply = function(L, f) {
  ret = vector('list', length(L))
  for (i in 1:length(L)) {
    ret[[i]] = f(L[[i]])
  }
  ret
}
my_lapply(as.list(1:10), function(x) x^2)

# sapply mean of vectors
means = function(L) sapply(L, function(x) mean(x, na.rm=TRUE))
L = lapply(1:5, function(x) sample(c(1:4, NA)))
means(L)

# Append _n to dataframe names
modify_colnames = function(df) {
  for (i in 1:length(df)) {
    names(df)[i] = paste0(names(df)[i], '_', as.character(i))
  }
  df
}
modify_colnames(mtcars)

# Calculating sums with *apply functions
sum(sapply(10:100, function(i) (i^3 + 4*i^2)))
sum(sapply(1:25, function(i) (2^i/i + 3^i/i^2)))
sapply(seq(3, 6, .1), function(x) exp(x) * cos(x))

# Weighted means with Map
weighted_means = function(values, weights) {
  Map(weighted.mean, values, weights)
}
values = lapply(1:10, function(x) rnorm(10))
weights = lapply(1:10, function(x) rnorm(10))
weighted_means(values, weights)

# Weighted means ignoring NAs
weighted_means_narm = function(values, weights) {
  Map(function(x, w) weighted.mean(x, w, na.rm=TRUE), values, weights)
}

# Implementation of sum
my_sum = function(v) Reduce(`+`, v)
my_sum(1:10)

# Implementation of union and intersect
my_union = function(L) Reduce(union, L)
my_intersection = function(L) Reduce(intersect, L)

# Bidirectional reduce
bidirectional_reduce = function(f, L) {
  left = Reduce(f, L)
  right = Reduce(f, L, right=TRUE)
  if (identical(left, right)) {
    return(left)
  } else {
    return(NA)
  }
}

# Implementation of Reduce
my_reduce = function(f, L) {
  if (length(L) == 2) {
    return(f(L[[1]], L[[2]]))
  } else {
    return(my_reduce(f, c(f(L[[1]], L[[2]]), L[3:length(L)])))
  }
}

# Any() and All()
Any = function(f, L) ifelse(is.null(Find(f, L)), FALSE, TRUE)
All = function(f, L) sum(sapply(L, f)) == length(L)

is_even = function(x) x %% 2 == 0
a = c(1, 2, 3, 4)
b = c(1, 3, 5)
c = c(2, 4, 6)
Any(is_even, a)
Any(is_even, b)
Any(is_even, c)
All(is_even, a)
All(is_even, b)
All(is_even, c)
