library(ggplot2)

# Hashmap collision

n_iter = 10000
data = matrix(numeric(3*n_iter), ncol=3)
my_count = function(x, vec) sum(x == vec)
for (i in 1:n_iter) {
  print(paste("Iteration:", i))
  hash = sample(1:10, replace=TRUE)
  collision_exists = as.numeric(length(hash) > length(unique(hash)))
  num_collisions = sum(sapply(1:10, function(n) ifelse(my_count(n, hash) <= 1, 0, my_count(n, hash) - 1)))
  num_unused = sum(sapply(1:10, function(n) !(n %in% hash)))
  data[i, ] = c(collision_exists, num_collisions, num_unused)
}
colSums(data)/n_iter

# Rolling the dice

roll = function() ceiling(runif(1) * 6)

roll_dice = function() {
  all_rolls = c()
  while (length(unique(all_rolls)) < 6) {
    all_rolls = c(all_rolls, roll())
  }
  length(all_rolls)
}

n_iter = 10000
tmp_sum = 0
for (i in 1:n_iter) {
  print(paste("Iteration: ", i))
  tmp_sum = tmp_sum + roll_dice()
}
tmp_sum/n_iter

# Bobo the amoeba

next_gen = function(n) {
  if (n > 500) {
    return(501)
  }
  if (n == 0) {
    0
  } else {
    n_children = 0
    for (i in 1:n) {
      r = runif(1)

      if (r < 0.25) {
        n_children = n_children + 1
      } else if (r < 0.5) {
        n_children = n_children + 2
      } else if (r < 0.75) {
        n_children = n_children + 3
      }
    }
    n_children
  }
}

n_lineages = 10000
n_gens = 30
pop = matrix(numeric(n_lineages * (n_gens + 1)), ncol=n_lineages)
pop[1, ] = 1
for (i in 1:n_gens) {
  print(paste("Iteration:", i))
  pop[i+1, ] = sapply(pop[i, ], next_gen)
}
alive = matrix(sapply(pop, function(x) ifelse(x > 0, 1, 0)), ncol=n_lineages)
probs = (n_lineages - rowSums(alive)) / n_lineages
qplot(1:(n_gens + 1), probs)
