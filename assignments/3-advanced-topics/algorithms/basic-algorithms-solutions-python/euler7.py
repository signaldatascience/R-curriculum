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

i = 0
p = 2
while i < 10001:
	i += is_prime(p)
	p += 1
print(p-1)