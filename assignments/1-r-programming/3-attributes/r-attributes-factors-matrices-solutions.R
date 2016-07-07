# Function to convert factors to binary indicator variables
expand_factors = function(df) {
  for (n in names(df)) {
    if (class(df[[n]]) == "factor") {
      lev = levels(df[[n]])
      df[[n]] = as.integer(df[[n]])
      for (i in unique(df[[n]])) {
        df[[gsub(" ", "_", paste(n, lev[i], sep="_"))]] = ifelse(df[[n]] == i, 1, 0)
      }
      df[[n]] = NULL
    }
  }
  return(df)
}

# Code to convert the time.dat columns into "# of hours past 8 PM"
threshold = 8
for (i in 42:43) {
  rn = paste("H2GH", as.character(i), sep="")
  new_col = sapply(as.character(df[[rn]]), function(x) {
    if (substr(x, 6, 6) == "A" & substr(x, 1, 2) == "12") {
      x = paste("00", substr(x, 3, 6), sep="")
    }
    if (substr(x, 6, 6) == "A") {
      x = paste(as.character(as.numeric(substr(x, 1, 2)) + 12), substr(x, 3, 6), sep="")
    }
    if (substr(x, 3, 3) == ":") {
      as.numeric(substr(x, 1, 2)) + as.numeric(substr(x, 4, 5)) / 60 - threshold
    } else {
      NA
    }
  })
  names(new_col) = NULL
  df[[rn]] = unlist(new_col)
}

# min_matrix
min_matrix = function(n, m) {
  ret = matrix(rep(0, n*m), nrow=n)
  for (i in 1:n) {
    for (j in 1:m) {
      ret[i, j] = min(i, j)
    }
  }
  ret
}

# Implementation of matrix multiplication
dot_prod = function(x, y) {
  sum(x*y)
}
matrix_mult = function(A, B) {
  dim_x = dim(A)[1]
  dim_y = dim(B)[2]
  ret = matrix(rep(0, dim_x * dim_y), nrow=dim_y)
  for (i in 1:nrow(A)) {
    for (j in 1:ncol(B)) {
      row = A[i, ]
      col = B[, j]
      ret[i, j] = dot_prod(row, col)
    }
  }
  return(ret)
}

A = matrix(1:6, nrow=2)
B = matrix(1:6, nrow=3)
matrix_mult(A, B)
