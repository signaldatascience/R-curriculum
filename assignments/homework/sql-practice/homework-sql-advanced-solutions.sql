-- Second highest salary
SELECT MAX(Salary) FROM Employee WHERE Salary NOT IN (SELECT MAX(Salary) FROM Employee);
SELECT MAX(Salary) FROM Employee WHERE Salary < (SELECT MAX(Salary) FROM Employee);
SELECT DISTINCT(Salary) FROM (SELECT DISTINCT(Salary) FROM Employee ORDER BY Salary DESC LIMIT 2) AS x ORDER BY Salary LIMIT 1;
SELECT DISTINCT(Salary) FROM Employee ORDER BY Salary DESC LIMIT 2,1;
SELECT DISTINCT(Salary) FROM (SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS srank FROM Employees) AS x WHERE srank = 2;

-- 