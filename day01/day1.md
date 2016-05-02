Week 1 Day 1 Assignment
=======================

Here's the data science-focused assignment for day 1. No worries if you don't complete everything -- I'm front-loading the assignments with the most crucial material; the goal here is for nobody to be left without something to do. 

Remember to switch off typing between your partner(s) every 20 minutes.

Analysing infant mortality data
-------------------------------

Install the packages `car`, `Ecdat`, `HistData`, `ggplot2`, `dplyr`, and `GGally`. Load `day1Example-rev.R` in RStudio.

You'll go through the existing code, alternating between figuring out what it does, answering questions here, and writing your own code to supplement what's already there.

You should strive to **discuss the questions with your partner** and write down answers, either in a separate text file in the same directory or as comments in the R file directly.

* Load the packages `car`, `ggplot2`, and `GGally`. Set `df = UN`.

* You can print out `df` by just typing `df` into the console, but you can also get a nice GUI for looking at dataframes by running `View(df)` (case-sensitive). Does anything stand out to you? Think about three questions you'd like to answer with this data and write them down for later as comments in the R file.

* Packages in R are extensively documented online. Figure out where to look for official documentation in the `car` package to read about what the `UN` data actually is.

* We'd like to know the correlation between GDP and infant mortality, so use the `cor()` function on the dataframe. What's wrong, and why is this happening? Look in the documentation for `cor()` to figure out how to tell the function to ignore invalid entries.

* For readability, multiply the correlation matrix by 100 and `round()` it to whole numbers. Wrap all of this (including the above bullet point) into a function, `cor2`, which outputs a correlation matrix ignoring invalid entries with rounded whole numbers.

* Instead of making the functions we use all individually handle missing values (`NA`s), we can create a new dataframe with incomplete rows excluded. Type `?na.fail` and read the documentation on `NA`-related functions; find one appropriate for the job and use it to make `df2`, a new dataframe that only has the complete rows of `df`.

We'll now start doing some transformations of the data, leading up to statistical analysis!

* Use the `ggpairs()` function (from the `GGally` package). What do you notice about the distributions of GDP and infant mortality? Figure out how to take a log transformation of the data and assign it to `ldf`, and examine it with `ggpairs()`. Note the differences, and reflect on the appropriateness of a linear model for the untransformed vs. transformed data.

* Run the line starting with `ggplot...` to plot a scatterplot of the data in `ldf` along with a linear fit of infant mortality to GDP. What happens when you remove the `method` argument in `geom_smooth()`? Look at the documentation for `geom_smooth()` and determine what method it defaults to; find the documentation online, read about it, and explicitly call it in the `method` argument instead of `"lm"`. How good of an approximation is a linear model?

A [residual](https://en.wikipedia.org/wiki/Residual_(numerical_analysis)) is a fancy word for prediction error; it's basically the difference given by `actual - predicted`.

Why is this important? By fitting a model to our data and looking at the residuals, we can visually inspect the results for evidence of [heteroscedasticity](https://en.wikipedia.org/wiki/Heteroscedasticity#Fixes). One of the [assumptions of linear regression](https://en.wikipedia.org/wiki/Linear_regression#Assumptions) is that the variances of the distributions from which the response variables are drawn have the same variance. If that's the case, then we shouldn't really see much structure in the plot of the residuals, so seeing structure in the plot of residuals is a warning sign that our model isn't working. For example, compare the top and bottom plots [here](https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/Hsked_residual_compare.svg/630px-Hsked_residual_compare.svg.png) (top has structure, bottom doesn't).

Take a look at the linked pages---just skim the sections to which I've linked directly.

* Run the lines that use the `lm` command to generate linear fits of infant mortality against GDP. You can type e.g. `linear_fit` in the console to get a summary of the results.

* Run the first `qplot` command, which plots the residuals (`actual - predicted` values) of the simple linear fit. Is there evidence of heteroskedasticity? Run the second `qplot` command, which plots the residuals of the linear fit of the log-transformed data. Is the log-log transformation an improvement?

* Using the documentation and experimenting in the console, make sure you understand what `df$infant.mortality - exp(fitted(loglog_fit))` does.

* Generate and analyze a plot of residuals for the linear fit of log(infant mortality) vs. GDP.

Exploring the Galton height data
--------------------------------

With this dataset, you'll be getting more experience with basic operations on dataframes and linear regressions.

Don't worry if some of the ways in which R works seem opaque or confusing to you. R has a steep learning curve, and we don't expect you to be an expert in R after this single assignment. You'll study some important internal details of the language later, but first, it's important to get some intuition for the kind of stuff you can do with R and motivation, in the form of interesting datasets and questions, to learn the language at a deeper level.

* Load the `HistData` and `dplyr` packages and set `df = GaltonFamilies`. Take a look at it visually with `View(df)`.

* This time, the dataframe has a lot of different columns. You can use the `names()` function to show the column names of `df` (you'll note that the output of `names(df)` is the same as the output of `colnames(df)`), and for a specific column `col` you can access it with the `$` operator, like so: `df$childHeight`. You can access and modify columns just like any other variable (with some small exceptions).

* The `gender` variable is encoded as a **factor**, which we'll cover in greater depth later. For now, since we want to run linear regressions including gender, we want to turn it into a *binary numeric variable*, with values 0 and 1. Use a combination of arithmetic and `as.numeric()` to do so, and be sure to keep track of which gender you assign to each of 0 and 1.

* The `dplyr` package is 