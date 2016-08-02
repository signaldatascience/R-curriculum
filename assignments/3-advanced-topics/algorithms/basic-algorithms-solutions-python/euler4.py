def is_palin(n):
	n = str(n)
	while len(n) > 1:
		if n[0] != n[-1]:
			return False
		n = n[1:-1]
	return True

m = -1
for i in range(101, 1000):
	for j in range(i, 1000):
		k = i * j
		if is_palin(k):
			m = max(k, m)
print(m)