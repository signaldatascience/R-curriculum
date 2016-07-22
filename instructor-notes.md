---
title: Notes on the Curriculum
author: Signal Data Science
---

The sections are ordered chronologically.

At the end of each day, students should be instructed to read the next day's assignment.

**Notation:** In each section, DN refers to the Nth day of the block of time allocated to each section.

R and linear regression
=======================

**Time:** 1 week.

Take special care to pair stronger students with weaker students, as a weak--weak pair is disastrous at this early stage.

Schedule
--------

1. *R: Basics*, *R: Atomic Vectors and Functions*, *Linear Regression: Introduction* (1 day)
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

* **D1:** *Advanced R, Day 1* (`readings/r/adv-r-day1.pdf`), on data structures and functions
* **D2:** *Advanced R, Day 2* (`readings/r/adv-r-day2.pdf`), on subsetting
* **D3:** *Advanced R, Day 3* (`readings/r/adv-r-day3.pdf`), on attributes, factors, matrices, and basic functional programming
* **D4:** *Advanced R, Day 4* (`readings/r/adv-r-day4.pdf`), on function operators
* **D5:** *Advanced R, Day 5* (`readings/r/adv-r-day5.pdf`), on optimization; revise work on (5) if code review is desired
* **Weekend:** *Homework: SQLZoo*

Additional notes
----------------

It should be emphasized to students that they should make extra effort to wrap up any loose ends in the core R curriculum after (5), as they will be moving on to more substantive data science material afterward.

Regularization and logistic regression
======================================

**Time:** 1 week.

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
* **D4:** Zumel, *"I don't think that means what you think it means"* (`readings/misc/zumel-classification.pdf`)
* **D5:** Review solutions to (5); revise work on (5) if code review is desired
* **Weekend:** *R Inferno* (`readings/r-miscellanea/R Inferno/`) and *Homework: Intermediate SQL Practice*

Additional notes
----------------

Students will find (1) challenging, particularly with regard to how they should fill in a predictions vector for n-fold cross-validation.

Dimensionality reduction
========================

**Time:** 1 week.

Schedule
--------

1. *Principal Component Analysis* (1 day)
2. *Factor Analysis* (1 day)
3. *Clustering* (1 day)
4. *Recommender Systems* (1 day)
5. *Self-Assessment 3*

Detailed schedule
-----------------

On the morning of D1--D4 and the afternoon of D5, link students solutions to the previous day's assignment.

On D1, lecture on PCA and then assign (1). Students should start (2) in the morning of D2; after lunch, lecture on factor analysis before students resume work. After lunch on D3, lecture on clustering and assign (3). Assign (4) in the morning of D4.

Homework
--------

* **D1:** Shlens (2014), *A Tutorial on Principal Component Analysis* (`readings/misc/shlens-pca-tutorial.pdf`) and Novembre and Stephens (2008), *Interpreting principal component analyses of spatial population genetic variation* (`readings/misc/novembre-2008-pca.pdf`) -- both optional, with former strongly recommended
* **D2:** Abdi, *Factor Rotations in Factor Analyses* (`readings/misc/abdi-factor-rotations.pdf`)
* **D3:** Sections 2--3 of Steinbach *et al.* (2004), *The Challenges of Clustering High Dimensional Data* (`readings/misc/high-dim-clustering.pdf`) and *Notes on Alternating Least Squares*, the latter being preparation for D4
* **D4:** 
* **D5:** 
* **Weekend:** *Homework: Advanced SQL Practice*

