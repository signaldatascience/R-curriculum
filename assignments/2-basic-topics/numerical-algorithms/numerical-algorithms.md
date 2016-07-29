---
title: Numerical Algorithms
author: Signal Data Science
---

Finding maxima and minima
=========================

Gradient descent
----------------

Stochastic gradient descent
---------------------------

Newton's method
---------------

The expectation--maximization algorithm
=======================================

Markov chain Monte Carlo
========================

Iterative principal component extraction
========================================

The technique of [principal component analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) (PCA) can be conceptualized in the following manner: First, we find the direction along which the data varies the most (analogous to the [semi-major axis of an ellipse](https://en.wikipedia.org/wiki/Semi-major_and_semi-minor_axes)). That is the first principal component. We then 'subtract off' that dimension of variation from the data and then find the direction of greatest variation in the *reduced* data. This is the second principal component. Repeating this process, we end up with $p$ principal components for a dataset of dimension $p$ (containing $p$ variables).

With a matrix of data $\textbf{X}$, PCA is ordinarily calculated through the computation of the [singular value decomposition](https://en.wikipedia.org/wiki/Singular_value_decomposition) of $\textbf{X}$ or an eigendecomposition of the [covariance matrix](https://en.wikipedia.org/wiki/Covariance_matrix) of $\textbf{X}$. However, the procedure outlined above illustrates more of the *intuition* behind PCA. The first principal component (PC1) is the dimension which accounts for as much variation as possible, PC2 accounts for as much variation as possible after PC1 is removed, PC3 accounts for as much variation as possible after PC1 and PC2 are removed, and so on and so forth.

In the following, we will implement our own version of PCA using the method of iterative principal component extraction described above and compare our answer to the PCA method implemented in R's [`prcomp()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html) (which uses a SVD-based method).

* Initialize a random matrix with `set.seed(1); X = matrix(sample(0:1, 100, replace=TRUE), nrow=10); X = scale(X)`.

Extracting the first principal component
----------------------------------------

Given $\textbf{X}$, the vector representing the direction of greatest variation is given by the vector $\textbf{w}$ which *maximizes* the expression $\left( \textbf{w}^\intercal \textbf{X}^\intercal \textbf{X} \textbf{w} \right) / \left( \textbf{w}^\intercal \textbf{w} \right)$, where $\textbf{X}^\intercal$ represents the [transpose](https://en.wikipedia.org/wiki/Transpose) operation (calculated in R with [`t()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/t.html)). We call the expression which we wish to maximize our [objective function](https://en.wikipedia.org/wiki/Loss_function).

* Write a function `objective(w, X)` which calculates the value of the objective function for a given matrix `X` and vector `w`. Verify that `objective(1:10, X)` returns 19.023.

Instead of implementing our own numerical optimization algorithm, we will use R's [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html), which implements a variety of different optimization techniques.

* Write a function `vnorm(v)` which calculates the magnitude (*i.e.*, the $L^2$ norm) of `v`. Verify that `vnorm(1:10)` returns 19.621.

* Write a function `extract_pc(X, method)` which uses [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html) to maximize the objective function and calculate the first principal component of `X` using the optimization method specified by `method`. Keep the following in mind, referring to the documentation as necessary:

	* By default, [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html) tries to *minimize* the objective function. Modify the parameters as necessary for *maximization*.

	* Change the default behavior of [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html) so that the maximum number of iterations is 10,000.

	* For an initial starting point (the `par` parameter of [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html)), use a vector of all 1s with length equal to the dimensionality of `X`.

	* Passing in the matrix `X` to `objective()` can be accomplished by passing in `X=X` to [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html) (accomplished via the `...` parameter).

	* Return the calculated vector `w` which maximizes `objective(w, X)` *normalized* by dividing by its 

Moreover, we can use [`prcomp()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html) to verify that `extract_pc()` works as desired.

* Write a function `prcomp_pc(X)` which runs [`prcomp()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html) on `X` and returns the loadings of the first principal component.

In order to compare the outputs of `extract_pc()` and `prcomp_pc()`, we need to check if their output vectors point in the same direction. To determine if two vectors point in the same direction, we can't just compare the elements of the vectors; for example, $(1, 1)$ and $(10, 10)$ point in the same direction but are clearly quite different on an element-by-element basis.

The key is to look at the [dot product](https://en.wikipedia.org/wiki/Dot_product) of the two vectors, given by $\textbf{v} \cdot \textbf{w} = \sum_i v_i w_i$. We can use the identity $\textbf{v} \cdot \textbf{w} = \left\Vert \textbf{v} \right\Vert \left\Vert \textbf{w} \right\Vert \cos \theta$, where $\left\Vert \textbf{v} \right\Vert$ is the $L^2$ norm of $\textbf{v}$ and $\theta$ is the *angle* between the two vectors $\textbf{v}$ and $\textbf{w}$. If the angle between two vectors is close to either 0 or $180^\circ$, then they point along the same direction\ (an angle of $180^\circ$ indicates that one vector points in the *exact opposite* direction of the other, like $(1, 1)$ and $(-1, -1)$).

* Write a function `dot_prod(v, w)` which calculates the dot product of `v` and `w`.

* Write a function `angle(v, w)` which calculates the angle $\theta$ between `v` and `w` in degrees rather than [radians](https://en.wikipedia.org/wiki/Radian) and returns the smaller of $\theta$ and $180-\theta$. You may find the inverse cosine function [`acos()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Trig.html) useful. Verify that `angle(1:5, 6:10)` returns 15.214 and that `angle(1:5, -5:-1)` returns 50.479.

Finally, we're ready to compare the output of our home-grown `extract_pc()` with the R-based `prcomp_pc()`. We will use the [Nelder--Mead method](https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method) (also called the downhill simplex method or the amoeba method), a classic technique of numerical optimization developed in 1965, to perform our optimization.

* Use `extract_pc()` with `method="Nelder-Mead"` to estimate the first principal component of `X`. Calculate the angle between the output of `extract_pc()` and the output of `prcomp_pc()`. Your answer should be 6.065 degrees.

Unfortunately, the Nelder--Mead method does not perform well on more difficult optimization problems; indeed, it can often converge to suboptimal points. However, [`optim()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html) also implements the [Broyden--Fletcher--Goldfarb--Shanno algorithm](https://en.wikipedia.org/wiki/Broyden%E2%80%93Fletcher%E2%80%93Goldfarb%E2%80%93Shanno_algorithm) (BFGS), which is an approximation of Newton's method that does not need to directly calculate the second derivatives of the objective function. (Such methods are known as [Quasi-Newton methods](https://en.wikipedia.org/wiki/Quasi-Newton_methods); BFGS is one of the most popular.)

* How well does `extract_pc()` perform if you use BFGS for the optimization instead of Nelder--Mead?

Extracting every principal component
------------------------------------

After having calculated the *first* principal component of $\textbf{X}$, we need to remove all the information in $\textbf{X}$ which is captured by the direction of PC1 before we can extract the *second* principal component. In general, given an "intermediate" matrix of data $\textbf{X}^\star$ (which may be equal to $\textbf{X}$ but may also already have had multiple principal components "removed"), we can remove the information captured by the direction of the vector $\textbf{w}$ by computing $\textbf{X}^\star - \textbf{X} \textbf{W}$, where $\textbf{W} = \textbf{w} \textbf{w}^\intercal$ is the [outer product](https://en.wikipedia.org/wiki/Outer_product#Vector_multiplication) of $\textbf{w}$ with itself. ($\textbf{W}$ is a *matrix*, in contrast with $\textbf{w}^\intercal \textbf{w}$, which evaluates to a single number.)

* Write a function `remove_pc(Xorig, Xinit, pc)` which takes the *original* data matrix $\textbf{X}$ as `Xorig`, the *intermediate* data matrix $\textbf{X}^\star$ as `Xinit`, and a vector of weights `pc` corresponding to the principal component to be removed from $\textbf{X}^\star$. It should return the result of removing the information along the direction of `pc` from `Xinit` as described by the above explanation. Verify that `norm(remove_pc(X, X, 1:10))` returns 1475.395.

* Write a function `extract_all(X, method)` which combines `extract_pc()` and `remove_pc()` to calculate every principal component of `X` with the optimization method specified by `method`, returning a matrix where the $i$th column corresponds to the weights of the $i$th principal component. Write a function `prcomp_all(X)` analogously.

We're ready to see how well our method performs for extraction of *every* principal component.

* Write a function `angles_all(X, method)` which runs both `extract_all()` and `prcromp_all()` on `X` and returns a vector where the $i$th entry corresponds to the angle between the $i$th principal component as computed by our home-grown optimization method and the $i$th principal component as computed by R's [`prcomp()`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html).

* Use `angles_all()` to compare the performance of Nelder--Mead and BFGS for principal component extraction.

* Why is the last value of the output of `angles_all()` so much higher than the others? Provide an intuitive explanation for this phenomenon.