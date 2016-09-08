def arg_max(v):
	if len(v) == 1:
		return v[0]
	mpos = 0
	mval = v[0]
	for i, x in enumerate(v):
		if x > mval:
			mpos = i
			mval = x
	return mpos

def longest_run(v):
	rval = [v[0]]
	rlen = [1]
	for i in range(1, len(v)):
		if v[i] != v[i-1]:
			rval.append(v[i])
			rlen.append(1)
		else:
			rlen[-1] += 1
	imax = arg_max(rlen)
	return [rval[imax]] * rlen[imax]

print(longest_run([1, 2, 3, 3, 2]))