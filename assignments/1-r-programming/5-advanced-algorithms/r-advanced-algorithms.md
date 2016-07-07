---
title: "R: Advanced Algorithms"
author: Signal Data Science
---

Now that you're acquainted with the basics of R's functional programming toolkit and have a strong grasp of the most important aspects of R's internals, we'll wrap up our R curriculum with some materials on a variety of useful and interesting numerical algorithms.

A mysterious matrix
===================

In the following exercises, you will analyze the output of the mystery function `mystery = function(x) matrix(c(cos(x), -sin(x), sin(x), cos(x)), nrow=2)`.

* Is the output of `mystery()` *periodic* in some sense with respect to its inputs? Check if this holds in practice; if there's a discrepancy, explain it. (*Hint:* If you aren't familiar with the behavior of the `sin()` and `cos()` functions, graph a scatterplot of their values against `seq(0, 10, 0.01)`.)[^rot]

[^rot]: We have `mystery(0) != mystery(2*pi)` because of floating-point imprecision.

* Write a function to turn lists of length 4 into 2-by-2 matrices, forming a list-matrix capable of holding different data types. (*Hint:* Use [`dim()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/dim.html).) Speculate on some use cases of list-matrices.

* On the 2D plane, we can identify the *point* $(x,y)$ with the *column vector* `matrix(c(x,y), nrow=2, ncol=1)`. First, write a function which takes in a list of column vectors, internally adds each one as a row of a two-column dataframe, and then uses [`ggplot()`](http://ggplot2.org/) to graph a *scatterplot* of all the points in the input list. Second, modify this function to accept an argument `x` and so that for every column vector `c` in its list of points, instead of putting the data in `c` directly into the data frame, it does so for the product `mystery(x) %*% c` (for the `mystery()` function defined in a previous exercise). Experiment with different values of `x` and come up with a geometric understanding of how the output graph changes as you modify `x`.[^interp]

[^interp]: Calling `mystery(x)` returns a 2-dimensional rotation matrix corresponding to rotation through the angle `x` (given in radians).

Fast modular exponentiation
===========================

Before we can implement more complex algorithms, we'll need a fast implementation of [modular exponentiation](https://en.wikipedia.org/wiki/Modular_exponentiation), consisting of the task of calculating $a^b \mathrm{\ mod\ } c$, *i.e.*, the remainder of dividing $a^b$ by $c$. In addition to being intrinsically useful, modular exponentiation through repeated squaring (which is the end goal of this section) is a common programming question in interviews.

* Write a function `pow(a, b, c)` that calculates $a^b \mathrm{\ mod\ } c$. Begin with a naive implementation that simply evaluates the calculation directly. Verify that $6^{17} \mathrm{\ mod\ } 7 = 6$ and that $50^{67} \mathrm{\ mod\ } 39 = 2$.

* To improve the runtime of `pow()`, start at 1 and repeatedly multiply an intermediate result by $a$, calculating the answer mod $c$ each time, until the $b$th power of $a$ is reached. Implement this as `pow2()`.

* Using the [`tictoc`](https://cran.r-project.org/web/packages/tictoc/index.html) package, quantify the resulting improvement in runtime. How does runtime improve as $a$ or $c$ increase in size? Is the runtime improvement merely a constant-factor scaling change (is the new runtime a constant multiple of the previous runtimes)?

In order to make our algorithm even faster, we'll want to write a short utility function:

* Write a function `decompose(n)` which takes as input an integer `n` and returns a vector of integers such that when you calculate 2 to the power of each element of the result and take the sum of those powers of 2, you obtain $n$. (*Hint:* First, calculate all powers of 2 less than or equal to $n$. After that, iteratively subtract off the highest power from $n$, keeping track of *which* power of 2 it was, until you get to 0.)

Now, we can implement a quite rapid algorithm for modular exponentiation with the trick of repeated squaring:

* You can improve the runtime of `pow()` further by decomposing $b$ into a sum of powers of 2, starting with $a$ and repeatedly squaring modulo $c$ (to calculate $a^1, a^2, a^4, a^8, \ldots \mathrm{\ mod\ } c$), and then forming the final answer as a *product* of those intermediate calculations. (For example, for $6^{17} \mathrm{\ mod\ } 7$, you are essentially calculating $17 = 2^0 + 2^4$ and $6^{17} \mathrm{\ mod\ } 7 = 6^{2^0} \cdot 6^{2^4} \mathrm{\ mod\ } 7$.) Using `decompose(n)`, implement this improvement as `pow3()`, making sure to calculate every intermediate result modulo $c$. Verify that `pow3()` is faster than `pow2()`.

Random number generation
========================

Random number generators are not truly random (unless you use quantum techniques!) and are in fact [pseudorandom](https://en.wikipedia.org/wiki/Pseudorandom_number_generator), meaning that their output only *approximates* true randomness. A pseudorandom number generator (pRNG) can take a starting point, known as a *seed*, as input; a pRNG, given the same seed twice, will produce the exact same output in the exact same order both times. R uses [inversion transform sampling](https://en.wikipedia.org/wiki/Inverse_transform_sampling) by default to generate random numbers.

First, we will

Afterward, we will undertake the implementation of a [xorshift](https://en.wikipedia.org/wiki/Xorshift) pRNG, one of the simplest and fastest classes of pRNGs which work by repeatedly taking the [bitwise XOR](https://en.wikipedia.org/wiki/Xorshift) of a number with [bit-shifted](https://en.wikipedia.org/wiki/Logical_shift) versions of itself. The speed of xorshift pRNGs results from the fact that the numerical operations involved are directly implemented by the CPU. (Regrettably, they do fail certain statistical tests for randomness because they are fundamentally based on [linear recurrences](https://en.wikipedia.org/wiki/Linear-feedback_shift_register).)

Linear congruential generators
------------------------------

Bitwise operations in R
-----------------------

In order to write a xorshift pRNG, we first need to implement [bitwise operations](https://en.wikipedia.org/wiki/Bitwise_operation) in R.

Instead of operating with bits directly, we'll store binary representations of numbers as strings and operate on those, which will be quite slow but will better illustrate how bit shifts work. R does have [native bitwise operation functions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/bitwise.html), but we'll implement our own versions for pedagogical purposes![^rbit]

[^rbit]: The behavior of base R's logical bit shift functions is a little annoying because they can end up changing the sign of a number; the numerical value is invariant modulo $2^{32}$ but having to correct for a shift of $2^{32}$ is too much complication for this present assignment.

Before we can even think of operating on bitwise representations of integers, we need functions which allow us to convert between [decimal](https://en.wikipedia.org/wiki/Decimal) and [binary](https://en.wikipedia.org/wiki/Binary_number) representations of integer! The binary representation of a number encodes it as sums of powers of 2; for example, the binary number "100101" is equal to $2^5 + 2^2 + 2^0$, because (counting from the right and starting at 0) the 0th, 2nd, and 5th positions in "100101" are 1s. Representations of integers as sums of powers of 2 are *unique*, meaning that no two numbers have the same binary representation.

* Write a function `to_binary(n)` which takes an integer `n` and returns its binary representation in a string with no leading zeroes (*e.g.*, "10100" instead of "0010100").

* Write a function `to_decimal(b)` which takes a binary representation `b` and returns the corresponding decimal integer. To handle large integers, return 

The bitwise XOR operation takes two binary numbers of equal length and outputs another number of the same length, where the $i$th position in the output is 1 if the $i$th positions in the two input numbers are different and 0 if they are the same. For example, $0101 \oplus 0011 = 0110$ and $0010 \oplus 1010 = 1000$.

* Implement bitwise XOR as `bitwise_xor(a, b)`. If the inputs are of different lengths, remember to pad the shorter binary number with zeroes on the left.

A logical left shift of $k$ bits can be thought of as discarding the leftmost $k$ digits of a binary number and appending $k$ zeroes to the right end. Similarly, a logical right shift of $k$ bits discards the $k$ rightmost digits and appends $k$ zeroes to the left end. (If $k$ is equal to or greater than the length of the binary number, then the entire number is placed with zeroes.)

![Illustration of a logical left shift by 1 bit.](left_shift.png){width=40%}

These operations are called *shifts* because of how they are carried out in the [CPU register](https://en.wikipedia.org/wiki/Processor_register).

* Implement left and right logical shifts of $k$ bits as `left_shift(b, k)` and `right_shift(b, k)`.

Implementing a xorshift pRNG
----------------------------

Now, we can implement an algorithm to generate a random positive 32-bit integer. In order for logical left shifting to work properly, our binary numbers must be long enough to encode 32 bits of information:

* Write a function `to_binary_len(n, k)` which converts an integer `n` to a binary representation and then pads it with 0s on the left until the length of the string is equal to `k`.

Finally, we are ready to implement a simple xorshift algorithm. It will take as input 4 *seed* values $x$, $y$, $z$, and $w$ which determine its initial state. In the following, let $x \ll n$ represent $x$ left logical shifted by $n$ bits, let $x \gg n$ represent $x$ right logical shifted by $n$ bits, and let $\oplus$ represent the bitwise XOR operation. The algorithm is as follows:

1. Set $t = x$.
2. Set $t = t \oplus (t \ll 11)$.
3. Set $t = t \oplus (t \gg 8)$.
4. Set $x = y$, $y = z$, and $z = w$.
5. Set $w = w \oplus (w \gg 19)$.
6. Set $w = w \oplus t$.
7. Return $w$.

At this point, you have everything you need to write a custom implementation of a xorshift pRNG!

* Fill in the following code template for a `xorshift()` function:

	```r
	xorshift = function(x, y, z, w) {
	  # Convert x, y, z, w to 32-bit binary representations.
	  function() {
	    # Implement the xorshift algorithm, using <<- for
	    # assignment to x, y, z, w.

	    # Call return() here on the output.
	  }
	}
	```

	`xorshift()` will return a xorshift pRNG seeded with the specified values which can then be repeatedly called to generate random values, *e.g.*, `r = xorshift(0, 3, 93, 59); r();`. Verify that with $(x, y, z, w) = (1, 2, 3, 4)$ as the seed, the first three generated numbers are 2061, 6175, and 4. Visualize 10,000 randomly generated numbers with a histogram of their values.

Saving and loading pRNG state in R
----------------------------------

It is occasionally important to be able to [save and load the pRNG state](http://www.cookbook-r.com/Numbers/Saving_the_state_of_the_random_number_generator/) in R. For example, you may want to be able to reproduce the output of two "interwoven" random sequences beginning from different seeds.

The state of R's built-in pRNG is simply saved in the `.Random.seed` variable in the global environment. It can be written to a different variable and restored via simple assignment. There is one caveat: attempting to set `.Random.seed` within a function call will *create a local variable* called `.Random.seed` instead of changing the value of the *global* `.Random.seed` variable. Thankfully, the seed variable corresponding to R's pRNG can always be accessed with `.GlobalEnv$.Random.seed`.

Fast primality testing
======================

Checking whether a number is [prime](https://en.wikipedia.org/wiki/Prime_number) or [composite](https://en.wikipedia.org/wiki/Composite_number) is a classic algorithmic task, stretching all the way back to 200 BC with the [Sieve of Erastosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) developed by [Erastosthenes of Cyrene](https://en.wikipedia.org/wiki/Eratosthenes). We will first implement the Sieve and then work toward writing an implementation of the [Miller--Rabin primality test](https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test), a modern test for primality known to be [very fast in practice](http://stackoverflow.com/questions/2586596/fastest-algorithm-for-primality-test) for reasonably small numbers.

The Sieve of Erastosthenes
--------------------------

The Miller--Rabin primality test
--------------------------------

In the Miller--Rabin primailty test, we test the primality of a number $n > 2$ as follows: Since $n$ is odd, $n-1$ must be even, so we can write $n-1 = 2^s \cdot d$, where $d$ is odd. (For example, if $n = 13$, then $n-1 = 12 = 2^2 \cdot 3$ with $s = 2$ and $d = 3$.) The Miller--Rabin primality test is based on the observation that if we can find a number $a$ such that $a^d \not\equiv 1 (\text{mod}\ n)$ *and* $a^{2^rd} \not\equiv -1 (\text{mod}\ n)$ for all integers $r$ in the range $0 \le r \le s-1$, then $n$ is not prime. Otherwise, $n$ is likely to be prime.

Note that the Miller--Rabin primality test, as formulated here for a specific value of $a$, is *probabilistic* rather than *deterministic* -- it cannot definitively establish that $n$ is prime. It can be made deteterministic by checking all $a \le 2 (\ln n)^2$. Better yet, when $n$ is sufficiently small, it [has been found](https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test#Deterministic_variants) that we only need to consider a couple different values of $a$; for example, for $n < 4,759,123,141$, we only have to check $a \in \{2, 7, 61\}$.

We have one more utility function to write:

* Write a function `decompose_even(n)` which takes as input an *even* integer `n` and returns a vector of two integers `c(s, d)` such that `n` is equal to `2^s * d` and `d` is odd.

With `decompose()`, `decompose_even()`, and `pow3()`, we are now ready to implement the entire primality test.

* Following the above description, implement the deterministic Miller--Rabin test as `miller_rabin(n)` for $n < 4,759,123,141$, returning `TRUE` for a prime number and `FALSE` otherwise. (Note that checking if $x \equiv -1 (\text{mod}\ n)$ is equivalent to checking if $x \equiv n-1 (\text{mod}\ n-1)$.)

* Write a function `simple_check(n)` that checks if `n` is a prime by checking if `n` is divisible by any integers from 2 up to `floor(sqrt(b))`. Verify that `miller_rabin()` and `simple_check()` produce the same output for the first 100 integers. Use `timeit` to compare the performance of the two functions as `n` grows.

A small primality problem
-------------------------

We can apply the Miller--Rabin primality test to solve a simple problem in computational number theory.

* Find a counterexample to the following statement: By changing at most a single digit of any positive integer, we can obtain a prime number. Use the [`memoise`](https://cran.r-project.org/web/packages/memoise/index.html) package to easily perform [memoization](https://en.wikipedia.org/wiki/Memoization) for the output of `miller_rabin()`. How much faster is your code with memoization compared to without memoization?