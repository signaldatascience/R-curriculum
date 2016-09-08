i = 1
j = 2
s = 0
while j < 4000000:
	if j % 2 == 0:
		s += j
	k = i + j
	i = j
	j = k
print(s)