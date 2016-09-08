

`outer()`
---------

For *creating* matrices and arrays, we have `outer(x, y, func)`, which iterates over *every combination of values in `x` and `y`* and applies `func()` to both values. The `func` argument defaults to normal multiplication, so the functionality of [`outer()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/outer.html) can be easily demonstrated in the creation of a times table:

```r
> outer(1:3, 1:4)
     [,1] [,2] [,3] [,4]
[1,]    1    2    3    4
[2,]    2    4    6    8
[3,]    3    6    9   12
```

Some operations become very easy with [`outer()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/outer.html). However, its functionality is a little unintuitive. [Here's how it works:](http://stackoverflow.com/questions/5554305/simple-question-regarding-the-use-of-outer-and-user-defined-functions)

We take the input vectors `x` and `y` and create two new vectors `x2` and `y2`, both of length `length(x)*length(y)`, such that for every pair of one value in `x` with one value in `y` there exists some value `i` such that the pair is given by `(x2[i], y2[i])`. 