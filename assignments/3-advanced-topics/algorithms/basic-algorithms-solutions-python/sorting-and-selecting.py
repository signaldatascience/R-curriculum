from random import randint

def merge(x, y):
    m = []
    while len(x) > 0 and len(y) > 0:
        if x[0] < y[0]:
            m.append(x[0])
            x = x[1:]
        else:
            m.append(y[0])
            y = y[1:]
    m.extend(x)
    m.extend(y)
    return m

def merge_sort(l):
    if len(l) <= 1:
        return l
    s = int(len(l)/2)
    x = merge_sort(l[:s])
    y = merge_sort(l[s:])
    return merge(x, y)

print(merge_sort([2, 4, 1, 2, 3]))

def quicksort(l):
    if len(l) <= 1:
        return l
    p = randint(0, len(l) - 1)
    pitem = l[p]
    small = []
    big = []
    for i in range(len(l)):
        if i != p:
            item = l[i]
            if item <= pitem:
                small.append(item)
            else:
                big.append(item)
    result = quicksort(small)
    result.extend([pitem])
    result.extend(quicksort(big))
    return result

print(quicksort([2, 4, 1, 2, 3]))

def quickselect(l, k):
    if len(l) == 1:
        return l[0]
    p = randint(0, len(l) - 1)
    pitem = l[p]
    small = []
    big = []
    for i in range(len(l)):
        if i != p:
            item = l[i]
            if item <= pitem:
                small.append(item)
            else:
                big.append(item)
    if len(small) > k-1:
        return quickselect(small, k)
    elif len(small) < k-1:
        return quickselect(big, k-len(small)-1)
    else:
        return pitem

print(quickselect([4, 1, 5, 9], 3))