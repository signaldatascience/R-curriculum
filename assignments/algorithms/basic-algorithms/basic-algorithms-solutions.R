# Run length encoding
arg_max = function(v) match(max(v), v)[1]
longest_run = function(v) {
  r = rle(v)
  pos = arg_max(r$lengths)
  rep(r$values[pos], r$lengths[pos])
}
x = c(1, 2, 2, 1, 2, 2, 2, 3, 3, 3, 3, 3, 2, 2, 1)
longest_run(x)

# Reservoir sampling
reservoir = function(v, k) {
  res = v[1:k]
  for (i in (k+1):length(v)) {
    j = sample(1:i, 1)
    if (j <= k) {
      res[j] = v[i]
    }
  }
  res
}
num_iter = 10000
times_chosen = rep(0, 20)
for (i in 1:num_iter) {
  res = reservoir(1:20, 5)
  for (j in res) {
    times_chosen[j] = times_chosen[j] + 1
  }
}
times_chosen = times_chosen/num_iter
times_chosen

# Permutation generation (naive)
perm_naive = function(n) {
  if (n == 1) {
    return(list(1))
  }

  smaller = perm_naive(n-1)
  perms = vector("list", length(smaller) * n)
  pos = 0
  for (i in 1:length(smaller)) {
    old = smaller[[i]]
    for (j in 1:(n-1)) {
      pos = pos + 1
      if (j < (n-1)) {
        perms[[pos]] = c(old[1:j], n, old[(j+1):(n-1)])
      } else {
        perms[[pos]] = c(old, n)
      }
    }
    pos = pos + 1
    perms[[pos]] = c(n, old)
  }
  unique(perms)
}
perm_naive(4)

# Quicksort implemented with for loops
quicksort = function(L) {
  if (length(L) <= 1) {
    return(L)
  }

  pivot_idx = sample(1:length(L), 1)
  pivot = L[pivot_idx]

  small = c()
  large = c()

  for (i in 1:length(L)) {
    if (i != pivot_idx) {
      if (L[i] <= pivot) {
        small = c(small, L[i])
      } else {
        large = c(large, L[i])
      }
    }
  }

  return(c(quicksort(small), pivot, quicksort(large)))
}

# Quicksort implemented with direct subsetting
quicksort2 = function(L) {
  if (length(L) <= 1) {
    return(L)
  }

  pivot_idx = sample(1:length(L), 1)
  pivot = L[pivot_idx]

  L = L[-pivot_idx]
  small = L[L <= pivot]
  large = L[L > pivot]

  return(c(quicksort(small), pivot, quicksort(large)))
}

x = c(sample(1:5), sample(1:5), sample(1:5))
x
quicksort(x)
quicksort2(x)

# Quickselect for kth smallest element of L
quickselect = function(L, k) {
  pivot_idx = sample(1:length(L), 1)
  pivot = L[pivot_idx]

  L = L[-pivot_idx]
  small = L[L <= pivot]
  large = L[L > pivot]

  if (length(small) == k-1) {
    return(pivot)
  } else if (length(small) >= k) {
    return(quickselect(small, k))
  } else {
    return(quickselect(large, k-length(small)-1))
  }
}

x = sample(1:10)
x
quickselect(x, 3)
quickselect(x, 10)

# Fast modular exponentiation
decompose = function(n) {
  powers = c()
  current_pow = 1
  i = 0
  while (current_pow <= n) {
    powers = c(powers, current_pow)
    i = i + 1
    current_pow = current_pow * 2
  }
  needed = c()
  while (n > 0) {
    sub = powers[powers <= n]
    cur_pow = sub[length(sub)]
    cur_idx = length(sub) - 1
    needed = c(needed, cur_idx)
    n = n - cur_pow
  }
  needed
}

# pow3(6, 17, 7) = 6
# pow3(50, 67, 39) = 2
pow3 = function(a, b, c) {
  dec = decompose(b)
  powers = c()
  tmp_pow = a
  for (i in 0:floor(log(b, 2))) {
    powers = c(powers, tmp_pow)
    tmp_pow = (tmp_pow * tmp_pow) %% c
  }
  s = 1
  for (d in dec) {
    s = (s * powers[d+1]) %% c
  }
  s
}