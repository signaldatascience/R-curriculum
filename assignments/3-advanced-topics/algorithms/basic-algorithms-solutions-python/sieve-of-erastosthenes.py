def sieve(m):
	ns = list(range(2, m))
	ms = [0] * len(ns)
	i = 0
	while i < m-2:
		if ms[i] == 1:
			i += 1
		else:
			p = ns[i]
			j = i + p
			while j < m-2:
				ms[j] = 1
				j += p
			i += 1

	s = []
	for i in range(len(ms)):
		if ms[i] == 0:
			s.append(ns[i])
	return s

x = sieve(100)
print(x)
print(len(x))