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

