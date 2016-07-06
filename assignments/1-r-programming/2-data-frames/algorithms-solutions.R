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

# Permutation generation
perm_naive = function(n) {

}
