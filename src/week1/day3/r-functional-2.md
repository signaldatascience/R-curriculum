Functional Programming in R
===========================

We'll cover slightly more complex functions.

`Map`, `Filter`, `Reduce`, *et al.*
------------------------------------


`Map()`, `Filter()`, and `Reduce()`
-----------------------------------

Here's a brief overview of the functions we'll be learning about:

* `mapply()` applies a function (which accepts multiple parameters) over multiple vectors of arguments, calling the function on the first element of each list, then the second elements, and so on and so forth.

	* Precisely, it accepts as input a function `func` and `N` equivalently-sized lists of arguments `args1`, .., `argsN`, each of length `k`. It returns as output a list containing `func(args1[1], ..., argsN[1])`, `func(arg1[2], ..., argsN[2])`, ..., `func(args1[k], ..., argsN[k])`.

* `Map()` is a wrapper for `mapply()` that calls it with the parameter `simplify=FALSE`.
