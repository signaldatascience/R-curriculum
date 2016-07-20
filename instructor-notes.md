---
title: Notes on the Curriculum
author: Signal Data Science
---

The sections are ordered chronologically.

At the end of each day, students should be instructed to read the next day's assignment.

Notation
========

In each section, DN refers to the Nth day of the block of time allocated to each section.

R and linear regression
=======================

**Time:** 1 week. **Material:** The basics of R and linear regression.

Take special care to pair stronger students with weaker students, as a weak--weak pair is disastrous at this early stage.

Schedule
--------

1. *R: Basics*, *R: Atomic Vectors and Functions*, *Linear Regression: Infant Mortality*, and *Linear Regression: Galton's Height Data* (1 day)
2. *R: Data Frames* and *Linear Regression: Simulated Data* (1 day)
3. *R: Attributes, Factors, and Matrices* (1 day)
4. *R: Functional Programming* (1 day)
5. *Self-Assessment 1* (4 hours)

For buffer, use *R: Basic Algorithms*, which can be completed directly after *R: Data Frames*, and *R: Spellchecking*, which should be done after *R: Functional Programming*.

Detailed schedule
-----------------

Send out each assignment in the morning. After (5), go over solutions and give students a half-hour break, instructing them to use the rest of the day as catch-up time. There is a theoretical solution to Part 1 of (5) which can be presented to interested students after their break. Depending on the timing of the weekend, the SQL questions in (5) may have to be removed.

Homework
--------

* **D1 through D5:** Completion of old work
* **Weekend:** *Homework: SQLZoo*

Additional notes
----------------

It should be emphasized to students that they should make extra effort to wrap up any loose ends in the core R curriculum after SA1, as they will be moving on to more substantive data science material afterward.

Regularization and logistic regression
======================================

**Time:** 1 week. **Material:** N-fold cross validation and elastic net regularization in the context of linear regression. Bootstrapping. Logistic regression.

Schedule
--------

1. *Linear Regression: Resampling* (1.5 days)
2. *Linear Regression: Regularization* (1 days)
3. *Linear Regression: Kaggle Africa Soil Challenge* (1 day)
4. *Logistic Regression: Speed Dating* (1 day)
5. *Self-Assessment 2* (5 hours)

Detailed schedule
-----------------

Allocate D1 and the morning of D2 for (1). After lunch on D2, present code solutions to (1), allow a 10 minute break, and lecture on regularized linear regression. (Don't assign (2) as reading beforehand, because it assumes theoretical understanding of regularization.) Tell them that the theoretical proofs in (2) can be skipped when doing the assignment but lecture on them at the end of the day. Present solutions to (2) in the afternoon of D3, allow a 30 minute break, and present a preliminary analysis of the data in (3). Finish up by lunchtime on D4. Give a lecture on logistic regression and assign (5). On D5, give (5) in the morning and allocate the remaining time to finishing up (4).

Homework
--------

* **D1 through D3**: *Homework: Reading from Gelman and Hill*
* **D4:** Zumel's "'I don't think that means what you think it means'" (`readings/misc/zumel-classification.pdf`)
* **D5:** Circles 1--6 of *R Inferno* (`readings/r-miscellanea/R Inferno`) and *Homework: Intermediate SQL Practice*

Additional notes
----------------

Students will find *Linear Regression: Resampling* challenging, particularly with regard to how they should fill in a predictions vector for $n$-fold cross-validation.

Dimensionality reduction
========================

1. *Introduction to Principal Component Analysis* (1 day)
2. *Introduction to Factor Analysis*
3. *Clustering*
4. *Collaborative Filtering with Movie Ratings*
5. *Self-Assessment 3*

Give a lecture on the theory of PCA followed by *Introduction to Principal Component Analysis*. Have students begin *Introduction to Factor Analysis* and give a lecture on the theory *after* students have completed at least some of the simulated data part of the assignment.

Homework
--------

After *Introduction to Principal Component Analysis*, assign as optional reading Shlens (2014) and Novembre and Stephens (2008). The former is a theoretical overview of PCA and the latter is a cautionary tale of PCA overinterpretation in population genetics.

Over the weekend, assign *Homework: Advanced SQL Practice*.

Advanced topics
===============

1. Amazon Web Services