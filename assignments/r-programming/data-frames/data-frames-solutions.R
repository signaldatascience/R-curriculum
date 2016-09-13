# Three different implementations of a nesting depth function

# Checks if any of the elements of L are themselves a list
contains_list = function(L) {
  if (length(L) == 0) {
    return(FALSE)
  }
  for (i in 1:length(L)) {
    if (is.list(L[[i]])) {
      return(TRUE)
    }
  }
  return(FALSE)
}

# Evaluates the nesting depth of L by unlisting it one level at a time until none of the elements are lists
nesting_depth = function(L) {
  count = 1
  while (contains_list(L)) {
    L = unlist(L, recursive=FALSE)
    count = count + 1
  }
  return(count)
}

# Here's another implementation of nesting_depth() which uses a recursive solution
nesting_depth2 = function(L) {
  idx_lists = c()
  for (i in 1:length(L)) {
    if (is.list(L[[i]])) {
      idx_lists = c(idx_lists, i)
    }
  }

  if (length(idx_lists) == 0) {
    return(1)
  }

  depths = c()
  for (i in 1:length(idx_lists)) {
    depths = c(depths, nesting_depth(L[[idx_lists[i]]]))
  }
  depths = 1 + depths

  return(max(depths))
}

# Even simpler recursive solution
nesting_depth3 = function(L, depth=1) {
  if (!is.list(L)) {
    return(depth-1)
  } else if(length(L) == 0) {
    return(depth)
  } else {
    return(max(unlist(sapply(L, nesting_depth3, depth=depth+1))))
  }
}

test = list(list()) # depth 2
test2 = list(list(list(list(1)))) # depth 4
test3 = list("asdf", list(list(1), 2, list(2, list(3, list())), 4, 5), 6, 7) # depth 5

nesting_depth(test)
nesting_depth(test2)
nesting_depth(test3)

nesting_depth2(test)
nesting_depth2(test2)
nesting_depth2(test3)

nesting_depth3(test)
nesting_depth3(test2)
nesting_depth3(test3)

# Traverses data frame in counterclockwise spiral

# dir = 1 2 3 or 4 <=> left bottom right or up
get_slice = function(df, dir, clockwise=FALSE) {
  if (is.null(df)) {
    return(NULL)
  }

  if (dir == 1) {
    slice = df[, 1]
    df = df[, -1, drop=FALSE]
  } else if (dir == 2) {
    slice = df[nrow(df), ]
    df = df[-nrow(df), , drop=FALSE]
  } else if (dir == 3) {
    slice = df[, ncol(df)]
    df = df[, -ncol(df), drop=FALSE]
  } else {
    slice = df[1, ]
    df = df[-1, , drop=FALSE]
  }

  if (!clockwise & (dir == 3 | dir == 4)) {
    slice = rev(slice)
  } else if (clockwise & (dir == 1 | dir == 2)) {
    slice = rev(slice)
  }

  names(slice) = NULL
  list(slice=slice, df=df)
}

spiral = function(df, clockwise=FALSE) {
  stop = FALSE
  nums = c()
  iter = 1:4
  if (clockwise) {
    iter = rev(iter)
  }
  while (!stop) {
    for (dir in iter) {
      tmp = get_slice(df, dir, clockwise)
      slice = tmp$slice
      df = tmp$df

      if (length(slice) == 0) {
        stop = TRUE
        break
      } else {
        nums = c(nums, slice)
      }
    }
  }
  unlist(nums)
}

testdf1 = data.frame(matrix(1:9, nrow=3))
testdf2 = data.frame(matrix(1:6, nrow=2))

testdf1
spiral(testdf1)
spiral(testdf1, clockwise=TRUE)

testdf2
spiral(testdf2)
spiral(testdf2, clockwise=TRUE)
