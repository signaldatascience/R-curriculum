Week 1 Day 1 Assignment
=======================

Install the packages `car`, `Ecdat`, `HistData`, `ggplot2`, and `GGally`. Load `day1Example-rev.R` in RStudio.

You'll go through the existing code, alternating between figuring out what it does, answering questions here, and writing your own code to supplement what's already there.

You should strive to **discuss the questions with your partner** and 

* Load `car`, `ggplot2`, and `GGally`. Set `df = UN`.

* You can print out `df` by just typing `df` into the console, but you can also get a nice GUI for looking at dataframes by running `View(df)` (case-sensitive). Does anything stand out to you? Think about three questions you'd like to answer with this data and write them down for later as comments in the R file.

* Packages in R are extensively documented online. Figure out where to look for official documentation in the `car` package to read about what the `UN` data actually is.

* We'd like to know the correlation between GDP and infant mortality, so use the `cor()` function on the dataframe. What's wrong, and why is this happening? Look in the documentation for `cor()` to figure out how to tell the function to ignore invalid entries.

* For readability, multiply the correlation matrix by 100 and `round` it to whole numbers. Consider wrapping all of this (including the above bullet point) into a function, `cor2`, which outputs a correlation matrix ignoring invalid entries with rounded whole numbers.

* Instead of making the functions we use all individually handle missing values (`NA`s), we can try to create a new dataframe with incomplete rows excluded. Type `?na.fail` and read the documentation on `NA`-related functions; find one appropriate for the job and use it to make `df2`, a new dataframe that only has the complete rows of `df`.

We'll now start doing some transformations of the data, leading up to statistical analysis!

* Use the `ggpairs()` function (from the `GGally` package). What do you notice about the distributions of GDP and infant mortality? Figure out how to take a log transformation of the data and assign it to `ldf`, and examine it with `ggpairs()`. Note the differences, and reflect on the appropriateness of a linear model for the untransformed vs. transformed data.

* Run the line starting with `ggplot...` to plot a scatterplot of the data in `ldf` along with a linear fit of infant mortality to GDP. What happens when you remove the `method` argument in `geom_smooth()`? Look at the documentation for `geom_smooth()` and determine what method it defaults to; find the documentation online, read about it, and explicitly call it in the `method` argument instead of `"lm"`. How good of an approximation is a linear model?