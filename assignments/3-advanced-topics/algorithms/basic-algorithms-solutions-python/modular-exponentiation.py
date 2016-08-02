from math import log

# pow() and pow2() are straightforward

def decompose(n):
	m = int(log(n, 2))
	ret = []
	es = list(range(m+1))
	es.reverse()
	for e in es:
		x = 2**e
		if x <= n:
			n -= x
			ret.append(e)
	return ret

def pow3(a, b, c):
	d = decompose(b)
	tmp = a
	if 0 in d:
		p = a
	else:
		p = 1
	for i in range(1, max(d)+1):
		tmp = (tmp * tmp) % c
		if i in d:
			p = (p * tmp) % c
	return  p

print(pow3(6, 17, 7))
print(pow3(50, 67, 39))