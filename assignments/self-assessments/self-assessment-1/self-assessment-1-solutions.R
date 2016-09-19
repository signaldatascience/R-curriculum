library(ggplot2)
library(dplyr)
library(psych)

### Part 1 ###

# Simulate X and Y for 10000 trials
n_trials = 10000
X = runif(n_trials)
Y = runif(n_trials, max=X)
#OR
Y = X*runif(n_trials)

qplot(Y, X)

# Do the binning
bin_width = 0.01
n_bins = 1/bin_width
bin_right = 1:n_bins * bin_width
bin_left = bin_right - bin_width
X_bins = sapply(1:n_bins, function(n) mean(X[Y > bin_left[n] & Y < bin_right[n]]))
Y_bins = sapply(1:n_bins, function(n) mean(c(bin_left[n], bin_right[n])))
qplot(Y_bins, X_bins)

#OR
df = data.frame(Y = round(Y, 2), X)
agged = aggregate(df, df["Y"], FUN = mean)
qplot(agged$Y, agged$X)


# Plot theoretical result
Y_theory = seq(0, 1, length.out=n_bins)
X_theory = (Y_theory - 1) / log(Y_theory)
qplot(Y_theory, X_theory)


# Plot simulated + theoretical result
agged = data.frame(agged, Y_theory, X_theory)
ggplot(agged) + geom_point(aes(x=Y, y=X)) + geom_smooth(aes(x=Y_theory, y=X_theory))


### Part 2###

# Load dataset
help(msq)
df = msq

# Compute fraction of missing values
frac_missing = sapply(df, function(col) sum(is.na(col)) / length(col))
frac_missing[order(frac_missing, decreasing=TRUE)][1:10]

# Select subset of columns
df = select(df, Extraversion, Neuroticism, active:scornful)

# Replace missing values with column means
for (i in 1:ncol(df)) {
  df[[i]][is.na(df[[i]])] = mean(df[[i]], na.rm=TRUE)
}

# Plots
ggplot(df, aes(x=Extraversion)) + geom_histogram()
ggplot(df, aes(x=Neuroticism)) + geom_histogram()
ggplot(df, aes(x=Extraversion)) + geom_density()
ggplot(df, aes(x=Neuroticism)) + geom_density()
ggplot(df, aes(x=Neuroticism, y=Extraversion)) + geom_point() + geom_smooth()

# Linear fits
fit_neuro = lm(Neuroticism ~ .-Extraversion, df)
fit_extra = lm(Extraversion ~ .-Neuroticism, df)

summary(fit_neuro)
summary(fit_extra)

# Coefficients
top_ten = function(coefs) coefs[order(abs(coefs), decreasing=TRUE)][1:10]
top_ten(coef(fit_neuro))
top_ten(coef(fit_extra))

### Part 3 ###

# Question 1
# The HAVING clause specifies a search condition if we use some grouping or aggregation clause like GROUP BY. 
# The WHERE clause does not apply to GROUP BY. I.e., 
# HAVING serves the function of WHERE but for a table that's been grouped by GROUP BY.

# Question 2
# One way:
SELECT MAX(Salary)
FROM Employees
WHERE Salary < (
	SELECT MAX(Salary)
	FROM Employees
);
# Another way:
SELECT Salary
FROM (
	SELECT Salary
	FROM Employees
	ORDER BY Salary DESC
	LIMIT 2
)
ORDER BY Salary ASC
LIMIT 1;

# Question 3
# See http://stackoverflow.com/a/28719292/3721976

# Question 4
# SELECT faculty_name 
# FROM COURSES 
# INNER JOIN COURSE_FACULTY 
# ON course_id 
# INNER JOIN FACULTY 
# ON faculty_id 
# WHERE course_name = "whatever"