# Two different implementations of a nesting depth function

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

test = list(list()) # depth 2
test2 = list(list(list(list(1)))) # depth 4
test3 = list("asdf", list(list(1), 2, list(2, list(3, list())), 4, 5), 6, 7) # depth 5

nesting_depth(test)
nesting_depth(test2)
nesting_depth(test3)

nesting_depth2(test)
nesting_depth2(test2)
nesting_depth2(test3)
