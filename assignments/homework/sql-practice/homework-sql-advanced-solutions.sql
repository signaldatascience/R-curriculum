-- Some questions have very specific solutions. Others give you the freedom to write the query however you wish. Use your judgment.

-- Conceptual questions

-- ROW_NUMBER() always generates a unique ranking; if the ORDER BY clause cannot distinguish between two rows, it will still give them different rankings (randomly). RANK() and DENSE_RANK() will give the same ranking to rows that cannot be distinguished by the ORDER BY clause, and DENSE_RANK() will always generate a contiguous sequence of ranks (1,2,3,...), whereas RANK() will leave gaps after two or more rows with the same rank (think "Olympic Games": if two athletes win the gold medal, there is no second place, only third). Answer from http://stackoverflow.com/a/16293996/3721976.

-- <> is the same as != (not equals).

-- By specifying `ORDER BY ... DESC`, because a more recent timestamp has a greater value.

-- The last query is basically (3 != 1) OR (3 != 2) OR (3 != NULL), and (3 != NULL) is of type UNKNOWN, and  TRUE OR TRUE OR UNKNOWN evaluates to UNKNOWN, so 'true' is not printed.

-- If the underlying database structure changes, the SELECT * query may still work but end up breaking something later on or just run very slowly. Naming columns explicitly means that a database structure change will break the SELECT query directly, and it'll be easy to fix the query. It also prevents optimization via covering indexes (but those aren't important to know about).

-- Normalization is the practice of decomposing a table into a series of smaller tables (with less redundant information) which can be joined together as necessary. "The objective is to isolate data so that additions, deletions, and modifications of an attribute can be made in just one table and then propagated through the rest of the database using the defined foreign keys." (Wikipedia) I.e., it helps to ensure the integrity of your data. Denormalization should be done in cases when you want very fast read speed.

-- "A table typically has a column or combination of columns that contain values that uniquely identify each row in the table. This column, or columns, is called the primary key (PK) of the table and enforces the entity integrity of the table. ... A foreign key (FK) is a column or combination of columns that is used to establish and enforce a link between the data in two tables to control the data that can be stored in the foreign key table. In a foreign key reference, a link is created between two tables when the column or columns that hold the primary key value for one table are referenced by the column or columns in another table. This column becomes a foreign key in the second table." (https://msdn.microsoft.com/en-us/library/ms179610.aspx)

-- Warming up with simple queries

-- FizzBuzz
WITH RECURSIVE nums(n) AS (
    SELECT 1 UNION
    SELECT n + 1
    FROM nums
    WHERE n < 100
)
SELECT CASE WHEN n % 15 == 0 THEN 'FizzBuzz'
            WHEN n % 3 == 0 THEN 'Fizz'
            WHEN n % 5 == 0 THEN 'Buzz'
            ELSE TO_CHAR(n, '999')
       END
FROM nums;

-- Second highest salary (1)
SELECT MAX(Salary)
FROM Employees
WHERE Salary NOT IN (
    SELECT MAX(Salary)
    FROM Employees
);

-- Second highest salary (2)
SELECT MAX(Salary)
FROM Employees
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees
);

-- Second highest salary (3)
SELECT Salary FROM (
    SELECT DISTINCT Salary
    FROM Employees
    ORDER BY Salary DESC
    LIMIT 2
) AS x
LIMIT 1;

-- Second highest salary (4)
SELECT DISTINCT Salary
FROM Employees
ORDER BY Salary DESC
LIMIT 1 OFFSET 1;

-- Second highest salary (5)
SELECT DISTINCT Salary
FROM (
    SELECT Salary
         , DENSE_RANK() OVER (ORDER BY Salary DESC) AS srank
    FROM Employeess
) AS x
WHERE srank = 2;

-- Employees with names beginning with "Adam", case-invariant
SELECT EmpName
FROM Employees
WHERE UPPER(EmpName) LIKE "ADAM %";

-- Listing each potentially incorrectly inserted row
SELECT *
FROM Employees
WHERE EmpName IN (
    SELECT EmpName
    FROM Employees
    GROUP BY EmpName
    HAVING COUNT(*) > 1
);

-- Fixed Employees table (1)
SELECT DISTINCT EmpID
     , EmpName
     , MAX(Salary) OVER (PARTITION BY EmpName) AS Salary
FROM Employees;

-- Fixed Employees table (2)
SELECT DISTINCT ON (EmpName)
FROM Employees x
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees y
    WHERE x.EmpName = y.EmpName
);

-- Cumulative sum of employee commissions
SELECT Day
     , SUM(DaySum) OVER (ORDER BY Day ASC) AS CumSum
FROM (
    SELECT Day
         , SUM(Amount) AS DaySum
    FROM Commissions
    GROUP BY Day
) AS x
ORDER BY Day ASC;

-- 99th percentile employees
WITH ag AS (
    SELECT e.EmpName AS EmpName
         , SUM(COALESCE(c.Amount, 0)) AS SumAmt
         , ROW_NUMBER() OVER (ORDER BY SumAmt) AS RowNum
    FROM Employees e
    LEFT JOIN Commissions c
    ON e.EmpName = c.EmpName
    GROUP BY e.EmpName
)
SELECT EmpName
FROM ag
WHERE RowNum >= FLOOR(0.99 * (
    SELECT COUNT(*)
    FROM ag
));

-- More complex problems

-- Roulette runs
WITH runs_tmp AS (
    SELECT *
         , ROW_NUMBER() OVER (ORDER BY Timestamp ASC) AS Row
         , LAG(Color) OVER (ORDER BY Timestamp ASC) AS PrevColor
         , LEAD(Color) OVER (ORDER BY Timestamp ASC) AS NextColor
    FROM Roulette
    ORDER BY Timestamp ASC
), run_start AS (
    SELECT *
         , ROW_NUMBER() OVER (ORDER BY Timestamp ASC) AS SubRow
    FROM (
        SELECT *
        FROM runs_tmp
        WHERE PrevColor IS NULL OR Color != PrevColor
    ) AS x
), run_end AS (
    SELECT *
         , ROW_NUMBER() OVER (ORDER BY Timestamp ASC) AS SubRow
    FROM (
        SELECT *
        FROM runs_tmp
        WHERE NextColor IS NULL OR Color != NextColor
    ) AS x
)
SELECT run_start.Time AS StartTime
FROM run_start
INNER JOIN run_end
ON run_start.SubRow = run_end.SubRow
ORDER BY run_end.Row - run_start.Row DESC
LIMIT 1;