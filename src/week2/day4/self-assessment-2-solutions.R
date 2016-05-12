num_children_memo = list()
num_children = function(num_amoebas) {
  if (as.character(num_amoebas) %in% names(num_children_memo)) {
    num_children_memo[[as.character(num_amoebas)]]
  } else {
    children_count = 0
    for (i in 1:num_amoebas) {
      r = runif(1)
      if (r < 0.25) {
        children_count = children_count + 1
      } else if (r < 0.75) {
        children_count = children_count + 2
      }
    }
    num_children_memo[[as.character(num_amoebas)]] <<- children_count
    children_count
  }
}

simulate_n_generations = function(n) {
  num_amoebas = 1
  num_children = 0
  for (g in 1:n) {
    num_children = 0
    for (i in 1:num_amoebas) {
      r = runif(1)
      if (r > 0.25 & r < 0.5) {
        num_children = num_children + 1
      } else if (r > 0.5) {
        num_children = num_children + 2
      }
    }
    num_amoebas = num_children
  }
  num_amoebas
}
