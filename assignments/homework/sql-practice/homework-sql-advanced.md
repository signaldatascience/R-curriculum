---
title: "Homework: Advanced SQL Practice"
author: Signal Data Science
---

For the following problems, take out multiple sheets of paper and write down your answer to each one *by hand*. At *no* point in the process should you be typing *any* SQL code *at all*. Strive to get the answer right on the very first try. 

Write SQL in *either* the [MySQL](https://en.wikipedia.org/wiki/MySQL) or the [Oracle Database PL/SQL](https://en.wikipedia.org/wiki/PL/SQL) variants. Aside from the generic SQL clauses available in both, note the following:

* From MySQL, you are allowed to use `LIMIT`.
* From PL/SQL, you are allowed to use [analytic (window) functions](http://docs.oracle.com/database/121/SQLRF/functions004.htm#SQLRF06174) like `ROW_NUMBER()` and `DENSE_RANK()`.
* You may *not* write in a *combination* of MySQL and PL/SQL.

**Do not collaborate on these problems.** You are allowed to refer to online documentation, but *only* the [MySQL 5.7 Reference Manual](http://dev.mysql.com/doc/refman/5.7/en/) and the [Oracle Database Online Documentation 12*c* Release](http://docs.oracle.com/database/121/index.htm). Use them often and use them well.

When finished, check your answers against the solutions. Mark every part of every problem which was answered incorrectly and understand your error. Next week, you will redo the marked problems.

Each substantive error you find in the solutions entitles you to a $1 prize and public recognition.

Warming up
==========

Suppose we have an `Employee` table where each row corresponds to a single employee with columns `EmpID` for the employee's ID, `EmpName` for the employee's name, `DeptID` indicating which department the employee belongs to, and `Salary` for the employee's salary.

* Write a SQL query to find the second highest *distinct* salary in `Employee`. Do so in each of these different ways: (1) with a `NOT IN` clause, (2) with the `<` operator, (3) with `LIMIT` and `ORDER BY`, (4) with `LIMIT` and `ORDER BY` but without any subqueries, and (5) with `RANK()`.

* 