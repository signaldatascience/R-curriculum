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

# Implementation of next_permutation() from:
# https://www.nayuki.io/page/next-lexicographical-permutation-algorithm

def next_permutation(arr):
    # Find non-increasing suffix
    i = len(arr) - 1
    while i > 0 and arr[i - 1] >= arr[i]:
        i -= 1
    if i <= 0:
        return False
    
    # Find successor to pivot
    j = len(arr) - 1
    while arr[j] <= arr[i - 1]:
        j -= 1
    arr[i - 1], arr[j] = arr[j], arr[i - 1]
    
    # Reverse suffix
    arr[i : ] = arr[len(arr) - 1 : i - 1 : -1]
    return True

def perm_lexico(n):
	x = list(range(1, n+1))
	ps = [x]
	while next_permutation(x):
		ps.append(x)
	return ps

print(perm_lexico(3))