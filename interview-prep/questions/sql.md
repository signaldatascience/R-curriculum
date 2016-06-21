---
title: "Interview Questions: SQL"
author: Signal Data Science
---

* What are the different types of joins? What are the differences between them?

* Why might a join on a subquery be slow? How might you speed it up?

* Describe the difference between primary keys and foreign keys in a SQL database.

	* [Microsoft MSDN reference](https://msdn.microsoft.com/en-us/library/ms179610.aspx)

	* "A table typically has a column or combination of columns that contain values that uniquely identify each row in the table. This column, or columns, is called the primary key (PK) of the table and enforces the entity integrity of the table. Because primary key constraints guarantee unique data, they are frequently defined on an identity column."

	* "A foreign key (FK) is a column or combination of columns that is used to establish and enforce a link between the data in two tables to control the data that can be stored in the foreign key table. In a foreign key reference, a link is created between two tables when the column or columns that hold the primary key value for one table are referenced by the column or columns in another table. This column becomes a foreign key in the second table."

* Given a `COURSES` table with columns `course_id` and `course_name`, a `FACULTY` table with columns `faculty_id` and `faculty_name`, and a `COURSE_FACULTY` table with columns `faculty_id` and `course_id`, how would you return a list of faculty who teach a course given the name of a course?

	* SELECT faculty_name WHERE course_name = "whatever" FROM COURSES INNER JOIN COURSE_FACULTY ON course_id INNER JOIN FACULTY ON faculty_id

* Given an `IMPRESSIONS` table with `ad_id`, `click` (an indicator that the ad was clicked), and `date`, write a SQL query that will tell me the clickthrough rate of each ad by month.

* Write a query that returns the name of each department and a count of the number of employees in each:

	`EMPLOYEES` containing: `Emp_ID` (Primary key) and `Emp_Name`

	`EMPLOYEE_DEPT` containing: `Emp_ID` (Foreign key) and `Dept_ID` (Foreign key)

	`DEPTS` containing: `Dept_ID` (Primary key) and `Dept_Name`