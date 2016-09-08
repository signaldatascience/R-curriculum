def is_prime(n):
	if n in [2, 3]:
		return True
	elif n % 2 == 0:
		return False
	else:
		for i in range(3, int(n**0.5)+1, 2):
			if n % i == 0:
				return False
		return True

n = 600851475143
p = 2
while n > 1:
	if n % p == 0:
		print(p)
		n = n / p
	else:
		p += 1
		while not is_prime(p):
			p += 1