from random import randint

def reservoir(v, k):
	res = v[:k]
	for i in range(k, len(v)):
		j = randint(1, i+1)
		if j <= k:
			res[j-1] = v[i]
	return res

n = 20
v = list(range(n))
p = [0] * n
niter = 10000
for i in range(niter):
	res = reservoir(v, 5)
	for r in res:
		p[r] += 1
p = [x/niter for x in p]
print(p)