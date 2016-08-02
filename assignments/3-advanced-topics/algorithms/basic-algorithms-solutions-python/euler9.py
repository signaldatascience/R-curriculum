m = 1000
d = {}
for i in range(1, m):
	for j in range(i, m):
		k = i**2 + j**2
		k = k**0.5
		if abs(k - int(k)) < 0.0001:
			k = int(k)
			if i + j + k == 1000:
				print(i*j*k)