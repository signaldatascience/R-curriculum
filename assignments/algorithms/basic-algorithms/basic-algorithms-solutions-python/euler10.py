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

s = 0
for i in range(2, 2000000):
	if is_prime(i):
		s += i
print(s)