---
title: Recommender Systems
author: Signal Data Science
---

In this assignment, we'll explore one way to make a [recommender system](https://en.wikipedia.org/wiki/Recommender_system), something which predicts the rating a user would give to some item. Specifically, we'll be using [collaborative filtering](https://en.wikipedia.org/wiki/Collaborative_filtering) on the [MovieLens 1M Dataset](http://grouplens.org/datasets/movielens/), a set of one million different movie ratings. Collaborative filtering operates on the assumption that if one person $A$ has the same opinion as another person $B$ on item $X$, A is *also* more likely to have the same opinion as $B$ on a *different* item $Y$ than to have the opinion of a randomly chosen person on $Y$.

Collaborative filtering is a type of [unsupervised learning](https://en.wikipedia.org/wiki/Unsupervised_learning) and can serve as a *prelude* to dimensionality reduction (*e.g.*, with PCA or factor analysis) because filling in missing values is typically required for such methods. Specifically, we will be working with an [imputation](https://en.wikipedia.org/wiki/Imputation_(statistics))-based method of collaborative filtering, which infers *all* of the missing values from the given data.

In the following, write up your work in an R Markdown file with elaboration about *what* you're doing at each step and *why* you're doing it. Include interpretation of results as well whenever appropriate. Your goal should be to produce, at the end, an HTML (or PDF) file from the R Markdown writeup that gives a coherent and reasonably accessible description of the process you followed, the reasoning behind each step, and the results attained at the end.

Getting started
===============

We'll first need to spend some time preparing the data before we can use any collaborative filtering methods.

* Download the [MovieLens 1M Dataset](http://grouplens.org/datasets/movielens/1m/). Read the associated [`README.txt`](http://files.grouplens.org/datasets/movielens/ml-1m-README.txt), which describes the contents of the dataset.

* The first 5 lines of `ratings.dat` are:

	```
	1::1193::5::978300760
	1::661::3::978302109
	1::914::3::978301968
	1::3408::4::978300275
	1::2355::5::978824291
	```

	Use [`read.csv()`](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/read.table.html) with the appropriate options to load the file into R. The resulting data frame should have **1000209 rows** and **7 columns**.

* Restrict to the columns containing user IDs, movie IDs, and movie ratings. Name the columns appropriately.

* Compute the sets of [`unique()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/unique.html) user IDs and movie IDs as well as the mean rating given. Compare the numbers of different user IDs and movie IDs with the *maximum* user ID and movie ID.

* Set the seed for consistency. Generate a training set using 80% of the data and a test set with the remaining 20%.

Because there are some movies which are rated by very few people and some people who rated very few movies, we have two corresponding problems: (1) there will be movies in the test set which were not rated by any people in the training set and (2) there will be people in the test set who do not show up in the training set. As such, we need to add to the training set a fake movie rated by every user and a fake user who rated every movie.

* Create two data frames corresponding to the above fake data using the previously calculated mean rating. (For the fake movie and user respectively, use a movie ID and user ID which are both 1 greater than their respective maximum values in the entire dataset.) When creating the fake user who has rated every movie, allow the movie IDs to range from 1 to the maximum movie ID in the dataset (which will include movie IDs not present in the dataset). The fake user should not have a rating for the fake movie.

* Perturb the ratings of the fake data slightly by adding a normally distributed noise term with mean 0 and standard deviation 0.01. Add your fake data to the training data frame, which should increase in size by **9994 rows**.

Next, we need to create a matrix containing rating data for (user, movie) pairs. We can store this as a *sparse* matrix, which is a special data structure designed for handling matrices where only a minority of the entries are filled in (because each user has only rated a small number of movies).

* Use `Incomplete()` to generate a sparse ratings matrix with one row per user ID and one column per movie ID. The resulting matrix should have **6041 rows** and **3953 columns**.

Alternating least squares imputation
====================================

We will proceed to use the method of alternating least squares (ALS) to impute the missing entries in the sparse ratings matrix.[^als]

[^als]: Hastie *et al.* (2014), [Matrix Completion and Low-Rank SVD via Fast Alternating Least Squares](http://arxiv.org/abs/1410.2596).

TODO: ADD THEORETICAL EXPOSITION OF ALS

First, we need to calculate what values of the regularization parameter $\lambda$ we'll search over.

* Use `biScale()` to scale both the columns and the rows of the sparse ratings matrix with `maxit=5` and `trace=TRUE`. You can ignore the resulting warnings (increasing the number of maximum iterations doesn't improve the outcome, which you can verify for yourself).

`lambda0()` will calculate the lowest value of the regularization parameter which gives a zero solution, *i.e.*, the largest value of $\lambda$ which we should test (because any more regularization drives all estimates to zero).

* Use `lambda0()` on the scaled matrix and store the returned value as `lam0`.

* Create a vector of $\lambda$ values to test by (1) generating a vector of 20 *decreasing* and uniformly spaced numbers from `log(lam0)` to 1 and then (2) calculating $e^x$ with each of the previously generated values as $x$. You should obtain a vector where entries 1 and 5 are respectively 103.21 and 38.89.

* Initialize a data frame `results` with three columns: `lambda`, `rank`, and `rmse`, where the `lambda` column is equal to the previously generated sequence of values of $\lambda$ to test. Initialize a list `fits` as well to store the results of alternating least squares for each value of $\lambda$.

* Write a RMSE function to calculate the [root-mean-square error](https://en.wikipedia.org/wiki/Root-mean-square_deviation) between two vectors.

Now, we're ready to try ALS for varying values of $\lambda$. The following code will take some time to run.

* Iterate through the calculated values of $\lambda$. For each one, do the following:

	* Use `softImpute()` with the current value of $\lambda$ to calculate a singular value decomposition of the scaled sparse ratings matrix. Set `rank.max=30` to restrict solutions to a maximum rank of 30 and `maxit=1000` to control the number of iterations allowed. For all but the first iteration, pass into the `warm.start` parameter the *previous* result of calling `softImpute()`. Read the documentation for details on what these parameters mean.

	* Calculate the *rank* of the solution by (1) rounding the values of the diagonal matrix of the resulting decomposition, stored in `$d`, to 4 decimal places and (2) calculating the number of nonzero entries.

	* Use `impute()` to fill in the entries of the test set with the calculated matrix decomposition decomposition. Calculate the corresponding RMSE between the predicted ratings and the actual ratings.

	* Store the calculated decomposition in the previously initialized list `fits` as well as the calculated rank and RMSE in the corresponding row of the `results` data frame. Print out the results of the current iteration as well.

You should find that the minimum RMSE is attained at approximately $\lambda \approx 20$ with an RMSE of approximately 0.858.

* Store the best-performing matrix decomposition into a variable called `best_svd`.

Analyzing the results
=====================

TODO: WRITE SOMETHING HERE

* As with the ratings dataset, load the movies dataset (in `movies.dat`) and name the columns appropriately.

