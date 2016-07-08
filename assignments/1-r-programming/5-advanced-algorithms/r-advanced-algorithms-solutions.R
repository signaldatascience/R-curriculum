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

# Linear congruential generators
lcg = function(a, c, m, s) {
  function() {
    s <<- (a*s + c) %% m
    return(s)
  }
}

plotlag = function(x) {
  plot(x[1:(length(x)-1)], x[2:length(x)])
}

f_best = lcg(53, 0, 127, 1)
f_worst = lcg(85, 0, 127, 1)
rs_best = sapply(1:10000, function(x) f_best())
rs_worst = sapply(1:10000, function(x) f_worst())

hist(rs_best)
hist(rs_worst)

plotlag(rs_best)
plotlag(rs_worst)

library(Rmpfr)

lcg_mpfr = function(a, c, m, s) {
  s = mpfr(s, precBits=50)
  function() {
    s <<- (a*s + c) %% m
    return(s)
  }
}

randu = lcg_mpfr(65539, 0, 2^31, 1)
rs_randu = sapply(1:10000, function(x) as.numeric(randu()))
hist(rs_randu)
plotlag(rs_randu)

library(scatterplot3d)
scatterplot3d(rs_randu[1:(10000-2)], rs_randu[2:(10000-1)], rs_randu[3:10000], angle=150)

# Bitwise operations
to_binary = function(n) {
  d = decompose(n)
  s = ""
  for (i in 0:max(d)) {
    s = paste0(ifelse(i %in% d, 1, 0), s)
  }
  s
}

to_decimal = function(s) {
  n = 0
  for (i in 1:nchar(s)) {
    spos = nchar(s) - (i-1)
    if (substr(s, spos, spos) == "1") {
      n = n + 2^(i-1)
    }
  }
  n
}

bitwise_xor = function(a, b) {
  if (nchar(a) != nchar(b)) {
    c = ifelse(nchar(a) > nchar(b), a, b)
    d = ifelse(nchar(a) < nchar(b), a, b)
    for (i in 1:abs(nchar(a) - nchar(b))) {
      d = paste0("0", d)
    }
    a = c
    b = d
  }
  r = ""
  for (i in 1:nchar(a)) {
    r = paste0(r, ifelse(substr(a, i, i) != substr(b, i, i), "1", "0"))
  }
  r
}

left_shift = function(s, k) {
  for (i in 1:k) {
    s = paste0(substr(s, 2, nchar(s)), "0")
  }
  s
}

right_shift = function(s, k) {
  for (i in 1:k) {
    s = paste0("0", substr(s, 1, nchar(s)-1))
  }
  s
}


lpad = function(s, k) {
  if (k < nchar(s)) {
    return(s)
  }
  for (i in 1:(k - nchar(s))) {
    s = paste0("0", s)
  }
  s
}

to_binary_len = function(n, k) {
  lpad(to_binary(n), k)
}

# The xorshift pRNG
xorshift = function(x, y, z, w) {
  x = to_binary_len(x, 31)
  y = to_binary_len(y, 31)
  z = to_binary_len(z, 31)
  w = to_binary_len(w, 31)
  function() {
    t = x
    t = bitwise_xor(t, left_shift(t, 11))
    t = bitwise_xor(t, right_shift(t, 8))
    x <<- y
    y <<- z
    z <<- w
    w <<- bitwise_xor(w, right_shift(w, 19))
    w <<- bitwise_xor(w, t)
    to_decimal(w)
  }
}

xorshift_rng = xorshift(1, 2, 3, 4)
rs = sapply(1:10000, function(x) xorshift_rng())
plot(rs[1:9999], rs[2:10000])
hist(rs)

plotlag(rs)
scatterplot3d(rs[1:(10000-2)], rs[2:(10000-1)], rs[3:10000], angle=150)

# Sieve of Erastosthenes
sieve = function(N) {
  nums = 2:N
  p = 2
  stop = FALSE
  while (!stop) {
    nums = nums[(nums %% p != 0) | (nums == p)]
    if (p == max(nums)) {
      stop = TRUE
    } else {
      p = min(nums[nums > p])
    }
  }
  nums
}
sieve(100)

# decompose_even
decompose_even = function(n) {
  s = 0
  for (i in 1:floor(log(n, 2))) {
    tmp = 2^i
    if (n %% tmp == 0) {
      s = i
    }
  }
  d = n/(2^s)
  c(s, d)
}

# Miller-Rabin primality testing
miller_rabin = function(n) {
  if (n <= 1) {
    return(FALSE)
  }

  as = c(2, 7, 61)
  if (n %in% as) {
    return(TRUE)
  }

  sd = decompose_even(n-1)
  if (n %% 2 == 0) {
    return(FALSE)
  }

  for (a in as) {
    res = c()
    res = c(res, pow3(a, sd[2], n) != 1)
    for (r in 0:(sd[1]-1)) {
      res = c(res, pow3(a, 2^r*sd[2], n) != n-1)
    }
    if (sum(res) == length(res)) {
      return(FALSE)
    }
  }
  TRUE
}

simple_check = function(n) {
  if (n <= 1) {
    return(FALSE)
  } else if (n == 2 | n == 3) {
    return(TRUE)
  }

  for (i in (2:floor(sqrt(n)))) {
    if (n %% i == 0) {
      return(FALSE)
    }
  }
  return(TRUE)
}

library(tictoc)
nlim = 1000000
time_mr = rep(0, nlim)
time_simp = rep(0, nlim)
for (i in 1:nlim) {
  tic()
  res_mr = miller_rabin(i)
  t_mr = toc(quiet=TRUE)
  t_mr = t_mr$toc - t_mr$tic

  tic()
  res_simp = simple_check(i)
  t_simp = toc(quiet=TRUE)
  t_simp = t_simp$toc - t_simp$tic

  time_mr[i] = t_mr
  time_simp[i] = t_simp
}

# Variations function
variations = function(n) {
  n = as.character(n)
  digits = sapply(0:9, as.character)
  vars = rep(0, 9*nchar(n))
  i = 1
  for (j in 1:nchar(n)) {
    for (d in digits) {
      if (d != substr(n, j, j)) {
        llim = max(0, j-1)
        ulim = min(nchar(n)+1, j+1)
        newnum = paste0(substr(n, 0, llim), d, substr(n, ulim, nchar(n)+1))
        newnum = as.numeric(newnum)
        vars[i] = newnum
        i = i + 1
      }
    }
  }
  vars
}

# Number theory problem -- test numbers from 1 to 1000
for (i in 1:1000) {
  print(paste('Checking:', i))
  prime_check = sapply(variations(i), miller_rabin)
  if (sum(prime_check) == 0) {
    print(paste('Counterexample found:', i))
    break
  }
}
