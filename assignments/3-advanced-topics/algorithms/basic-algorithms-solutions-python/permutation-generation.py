def perm_naive(n):
	if n == 1:
		return [[1]]
	x = perm_naive(n-1)
	ps = []
	for y in x:
		z = [n]
		z.extend(y)
		if z not in ps:
			ps.append(z)
		for i in range(1, n):
			z = y[:i]
			z.append(n)
			z.extend(y[i:])
			if z not in ps:
				ps.append(z)
	return ps

print(perm_naive(3))

def perm_lexico(n):
	