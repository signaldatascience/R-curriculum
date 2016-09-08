n = 1
for i in range(1, 21):
	norig = n
	while n % i > 0:
		n = n + norig
print(n)