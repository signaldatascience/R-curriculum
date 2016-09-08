def levenshtein(s, t):
	M = {}
	for i in range(len(s)+1):
		for j in range(len(t)+1):
			M[i, j] = 0
	for i in range(1, len(s)+1):
		M[i, 0] = i
	for j in range(1, len(t)+1):
		M[0, j] = j
	for i in range(1, len(s)+1):
		for j in range(1, len(t)+1):
			c = 1
			if s[i-1] == t[j-1]:
				c = 0
			M[i, j] = min(M[i-1, j]+1, M[i, j-1]+1, M[i-1, j-1]+c)
	return M[len(s), len(t)]

print(levenshtein("kitten", "sitting"))

def get_val(M, i, j, s, t):
	c = 1
	if s[i-1] == t[j-1]:
		c = 0
	return min(M[i-1, j]+1, M[i, j-1]+1, M[i-1, j-1]+c)

def levenshtein_fast(s, t, k):
	M = {}
	for i in range(len(s)+1):
		for j in range(len(t)+1):
			M[i, j] = 0
	for i in range(1, k+1):
		M[i, 0] = i
	for j in range(1, k+1):
		M[0, j] = j
	for i in range(1, min(len(s), len(t))+1):
		M[i, i] = get_val(M, i, i, s, t)
		for j in range(i+1, i+k+1):
			if j <= len(t):
				M[i, j] = get_val(M, i, j, s, t)
			if j <= len(s):
				M[j, i] = get_val(M, j, i, s, t)
	m = min(len(s), len(t))
	return min(M[m, m] + abs(len(s) - len(t)), k)

print(levenshtein_fast("kitten", "sitting", 5))
print(levenshtein_fast("kitten", "sitting", 2))

def damerau_levenshtein(s, t):
	M = {}
	for i in range(len(s)+1):
		for j in range(len(t)+1):
			M[i, j] = 0
	for i in range(1, len(s)+1):
		M[i, 0] = i
	for j in range(1, len(t)+1):
		M[0, j] = j
	for i in range(1, len(s)+1):
		for j in range(1, len(t)+1):
			c = 1
			if s[i-1] == t[j-1]:
				c = 0
			if i >= 2 and j >= 2 and s[i-1] == t[j-2] and s[i-2] == t[j-1]:
				M[i, j] = min(M[i-1, j]+1, M[i, j-1]+1, M[i-1, j-1]+c, M[i-2, j-2]+c)
			else:
				M[i, j] = min(M[i-1, j]+1, M[i, j-1]+1, M[i-1, j-1]+c)
	return M[len(s), len(t)]

print(damerau_levenshtein("teacup", "taecop"))