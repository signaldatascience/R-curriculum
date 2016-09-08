# Solution by Michael Beese II

library(stringr)

e = new.env()
e$my_key = 10
ls(e)
e[["my_key"]]
e[["something"]] = 1

e[["two words"]] = 1
e$`two words`


#go through file lines getting each line as string
#split each line into words (by non-character)
#add one to that word's value in word_dict

find_word_freq = function(){
  word_dict = new.env()
  text = file("big.txt")
  lines = readLines(text)
  
  for (line in lines) {
    words = str_extract_all(tolower(line),"[a-z]+")
    # print(words)
    for (word in unlist(words)) {
      # print(word)
      if (is.null(word_dict[[word]])) {
        word_dict[[word]] = 1
      } else {
        word_dict[[word]] = word_dict[[word]] + 1 
      }
    }
  }
  close(text)
  return(word_dict)
}

word_freq = find_word_freq()

word_edit = function(word) {
  word_n_char = nchar(word)
  
  begin_word = sapply(1:(word_n_char-1), function(i){substring(word,1,i)})
  end_word = sapply(1:(word_n_char-1), function(i){substring(word,i+1,word_n_char)})
  
  deletes = paste0(begin_word,sapply(end_word, function(x){ substring(x,2) }))
  
  transposes = paste0(begin_word, sapply(end_word, function(x) { paste0(substr(x,2,2),substr(x,1,1),substring(x,3)) }))
  transposes = transposes[-length(transposes)]
  replaces = c()
  for (i in 1:length(begin_word)) {
    prefix = begin_word[i]
    suffix = end_word[i]
    for (l in letters) {
      new = paste0(prefix, l, substring(suffix,2))
      replaces = c(replaces, new)
    }
  }
  
  inserts = c()
  for (i in 1:length(begin_word)) {
    prefix = begin_word[i]
    suffix = end_word[i]
    for (l in letters) {
      new = paste0(prefix, l, suffix)
      inserts = c(inserts, new)
    }
  }
  inserts = c(inserts,paste0(word,letters))
  return(c(deletes,transposes,replaces,inserts))
}

word_edit("hello")
length(word_edit("heys"))
word_edit("h")

known_edit_2("hello")

known_edit_2 = function(word){
  word2 = unlist(sapply(word_edit(word), word_edit))
  logi_vec = sapply(word2, function(w) { !is.null(word_freq[[w]]) })
  return(unique(word2[logi_vec]))
}

known = function(words) {
  logi_vec = sapply(words, function(w) { !is.null(word_freq[[w]]) })
  return(unique(words[logi_vec]))
}

correct = function(word){
  candidates = known(word)
  if (length(candidates) > 0) return(word)
  
  candidates = known(word_edit(word))
  if (length(candidates) > 0) {
    freqs = sapply(candidates, function(x) word_freq[[x]])
    index = arg_max(freqs)
    return(candidates[index])
    
    
    #max_val = (max(sapply(candidates, function(x)word_freq[x])))
    #logi_vec = (max_val == sapply(candidates, function(x)word_freq[x]))
    #return(candidates[logi_vec][1])
  }
}

arg_max = function(v) match(max(v), v)[1]
correct("hellp")
