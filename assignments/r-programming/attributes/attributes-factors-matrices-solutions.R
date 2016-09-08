# Converting the first floor(ncol(df)/2) columns into factors
col_factor = function(df){
  li = list()
  for (i in 1:floor(ncol(df))){
    f = factor(unlist(df[i]))
    print (f)
    li[[i]] = f
    #li = list(li,f)
  }
  return (li)
}

# Converts columns with at most 5 unique values into factors
factor_5 = function(df){
  li = list()
  df_logical = lapply(df, function(col) { length(unique(col)) <= 5})
  new_df = df[unlist(df_logical)]
  col_factor(new_df)
}

mode_find = function(fact){
  fact = fact[!is.na(fact)]
  tab = tabulate(fact)
  m = max(tab)
  fact[match(m,tab)]
}

## replace NA with most common
NA_imputed = function(df){
  fac_df = col_factor(df)
  for (i in 1:ncol(df)){
    fac = fac_df[[i]]
    check = is.na(fac)
    names(check) = NULL
    if (any(check)){
      n_check = log_to_num(check) # indices
      current_column = fac
      for (j in n_check) {
        imputed = sample(fac, 1)
        rac = replace(current_column,j,imputed)  # change most
        names(rac) = NULL
        current_column = rac
        fac_df[[i]] = rac
        # print (fac_df)
      }
    }
  }
  return(fac_df)
}

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

# Determine if matrix is symmetrix
is_sym_matrix = function(M) (sum(M == t(M)) == length(M) & dim(M)[1] == dim(M)[2])

# Trace of matrix
trace = function(M) sum(diag(M))

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
