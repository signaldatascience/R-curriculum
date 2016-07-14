---
title: Notes on the Curriculum
author: Signal Data Science
---

The sections are ordered chronologically.

At the end of each day, students should be instructed to read the next day's assignment.

R curriculum
============

This portion of the curriculum takes approximately 1 week. It covers the basics of R and linear regression and is probably the most critical portion of the curriculum. Take special care to pair stronger students with weaker students, as a weak--weak pair is disastrous at this early stage.

Schedule
--------

Assignments should be done in this order:

1. *R: Basics*, *R: Atomic Vectors and Functions*, *Linear Regression: Infant Mortality*, and *Linear Regression: Galton's Height Data*
2. *R: Data Frames* and *Linear Regression: Simulated Data*
3. *R: Attributes, Factors, and Matrices*
4. *R: Functional Programming*

In the above list, each list item's contents should be assigned in the morning.

For buffer, use *R: Basic Algorithms*, which can be completed directly after *R: Data Frames*, and *R: Spellchecking*, which should be done after *R: Functional Programming*.

Give students *Self-Assessment 1* (SA1) after all the R basics have been introduced. SA1 will take 3--5 hours based on student strength, so allocate 4 hours for its completion with a lunch break in between. Afterward, go over solutions and give students a half-hour break. Time after completing SA1 can be used for catching up on old work. There is a theoretical solution to Part 1, which can be mentioned in the presentation of R code solutions and presented *only* to those students who are interested. (**Important:** Depending on how many days occur before the weekend, students or may not have had a chance to learn SQL, so the SQL questions on SA1 may have to be removed.)

Homework
--------

No special weekday homework aside from the assignment of completion of old work.

Over the weekend, assign the completion of old work along with [SQLZoo](http://sqlzoo.net/) tutorials. If SA1 takes place after the weekend, give advance notice of this.

Additional notes
----------------

It should be emphasized to students that they should make extra effort to wrap up any loose ends in the core R curriculum after SA1, as they will be moving on to more substantive data science material afterward.

Resampling and regularization
=============================

This portion of the curriculum takes approximately 4.5 days. It covers n-fold cross validation and elastic net regularization in the context of linear regression and also briefly touches upon bootstrapping.

Schedule
--------

The assignments in this section are:

1. *Linear Regression: Resampling*
2. *Linear Regression: Regularization*
3. *Linear Regression: Kaggle Africa Soil Challenge*

*Linear Regression: Resampling* takes around 1.5 days. Allocate the first day and the beginning of the second day for its completion. After lunchtime, present resampling solutions, allow a 10 minute break, and then give a presentation on regularized linear regression. (*Don't* assign the regularization assignment as reading beforehand; it assumes theoretical understanding of regularization.)

Afterward, assign *Linear Regression: Regularization*, which takes approximately 1 day. In the afternoon of the third day, present code solutions, allow a 10 minute break, and then present a brief exploratory analysis of the Kaggle African Soil Challenge data.

Finally, assign *Linear Regression: Kaggle Africa Soil Challenge*, taking through the morning of the fourth day. Any extra time can be used for completing old work or buffer assignments. **Note:** The afternoon of the fourth day is unallocated going by this schedule and should be used for the first logistic regression assignment (in the next section).

After *Linear Regression: Kaggle Africa Soil Challenge*, give students *Self-Assessment 2* (SA2). Allocate 4 hours for SA2 with a lunch break in between, present solutions at the end, and then have a half-hour break. After the break, students can work on finishing up old assignments, revising their self-assessment code, or working on buffer assignments. It may make sense to give students the first logistic regression assignment before SA2, especially if students seem mentally exhausted and might need a weekend to absorb resampling and regularization at a deeper level before doing SA2.

Homework
--------

Assign reading from Gelman and Hill, described in *Homework: Reading from Gelman and Hill*. The document portions out the homework into 3 different assignments over 3 nights. These can be assigned as soon as students start learning about resampling.

Additional notes
----------------

Students will find *Linear Regression: Resampling* challenging, particularly with regard to how they should fill in a predictions vector for $n$-fold cross-validation.

Logistic regression
===================

Dimensionality reduction
========================

Project: ???
============

Advanced topics
===============

1. Amazon Web Services