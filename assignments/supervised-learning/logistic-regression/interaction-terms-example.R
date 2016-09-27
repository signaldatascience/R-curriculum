df = data.frame(matrix(rnorm(90), ncol=9))
names(df) = c("X1", "X2", "X3", "Y1", "Y2", "Y3", "Z1", "Z2", "Z3")
names(df)

# Suppose we want to form interaction terms between X-Y and Y-Z pairs, but not between X-Z pairs.
