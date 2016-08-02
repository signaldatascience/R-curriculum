# Sieve of Erastosthenes
m = 2000000
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

s = 0
for i in range(len(ms)):
	if ms[i] == 0:
		s += ns[i]
print(s)