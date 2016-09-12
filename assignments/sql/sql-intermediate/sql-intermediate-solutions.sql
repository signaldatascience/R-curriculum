/* 
Solutions to company.sql and dogs.sql homework exercises
Sven Chilton
Signal Data Science Cohort 3
July 18, 2016
*/

.read company.sql

select '';
select 'The following tables are contained in company.sql:';
.tables

select '';
select 'Table "records" contains the following columns:';
pragma table_info(records);

select '';
select 'Table "records" contains '||count(*)||' rows' 
from records; 

select '';
select 'Table "meetings" contains the following columns:';
pragma table_info(meetings);

select '';
select 'Table "meetings" contains '||count(*)||' rows' 
from meetings; 

select '';
select 'All the data in the "records" table:';
select * from records;

select '';
select 'Oliver Warbucks manages the following employees directly:';
select Name from records where Supervisor = 'Oliver Warbucks';

select '';
select 'All information about self-supervising employees:';
select * from records where Name = Supervisor;

select '';
select 'All employees with salary greater than 50000, in alphabetical order';
select Name from records where Salary > 50000 order by Name;

select '';
select 'Employee, salary, supervisor and supervisor’s salary, containing ';
select 'all supervisors who earn more than twice as much as the employee:';
select x.Name as Employee, 
       x.Salary, 
       x.Supervisor, 
       y.Salary as Supervisor_Salary
from records x
     join records y on x.Supervisor = y.Name
where Supervisor_Salary > 2*x.Salary;

select '';
select 'Each employee whose manager is in a different division:';
select x.Name
from records x
     join records y on x.Supervisor = y.Name
where x.Division != y.Division;

select '';
select 'Meeting days and times of all employees directly supervised ';
select 'by Oliver Warbucks:';
select x.Name, y.Day, y.Time
from records x
     join meetings y on x.Division = y.Division
where x.Supervisor = 'Oliver Warbucks';

select '';
select 'The following employees are middle managers; they each ';
select 'supervise someone and a different someone supervises them:';
select distinct y.Name
from records x
     join records y on x.Supervisor = y.Name
     join records z on y.Supervisor = z.Name
where x.Name != y.Name and y.Name != z.Name;

select '';
select 'The following employees meet on the same day as their supervisor, ';
select 'not including Oliver Warbucks, who is his own supervisor:';
select distinct x.Name
from records x
     join records y on x.Supervisor = y.Name
     join meetings xx on x.Division = xx.Division
     join meetings yy on y.Division = yy.Division
where xx.Day = yy.Day and x.Name != x.Supervisor;

select '';
select 'Each supervisor and the some of the salaries of the employees ';
select 'whom s/he supervises directly, including self-supervisors:';
select Supervisor, sum(Salary)
from records
group by Supervisor;

select '';
select 'All salaries which appear more than once in "records" table:';
select Salary 
from records 
group by Salary 
having count(Salary) > 1;

.read dogs.sql

select '';
select 'The following tables are contained in dogs.sql:';
.tables

select '';
select 'Table "dogs" contains the following columns:';
pragma table_info(dogs);

select '';
select 'Table "dogs" contains '||count(*)||' rows' 
from dogs; 

select '';
select 'Table "parents" contains the following columns:';
pragma table_info(parents);

select '';
select 'Table "parents" contains '||count(*)||' rows' 
from parents; 

select '';
select 'Table "sizes" contains the following columns:';
pragma table_info(sizes);

select '';
select 'Table "sizes" contains '||count(*)||' rows' 
from sizes;

select '';
select 'Practice with creating and extracting information ';
select 'from local tables:';

select '';
select 'Integers 0 through 10, inclusive, and their factorials:';
with factorials(n, f) as (
     select 0, 1 union
     select n+1, f*(n+1) from factorials where n < 10
)
select * from factorials;

select '';
select '3-number-long sequences for integers 0 through 14, inclusive:';
with seq3(x, y, z) as (
     select 0, 1, 2 union
     select x+3, y+3, z+3 from seq3 where x < 12
)
select * from seq3;

select '';
select 'All dogs that have a parent, ordered by descending parent height:';
select x.name
from dogs x
     join parents y on x.name = y.child
     join dogs z on y.parent = z.name
order by z.height desc;

select '';
select 'Each pair of siblings in the same size category:';
with sibling_pairs(sib1, sib2) as (
     select x.child as sib1, y.child as sib2
     from parents x
          join parents y on x.parent = y.parent
     where sib1 < sib2
)
select sib1 || ' and ' || sib2 || ' are ' || s1.size || ' siblings'
from sibling_pairs
     join dogs d1 on sib1 = d1.name
     join dogs d2 on sib2 = d2.name
     join sizes s1 on (d1.height > s1.min) and (d1.height <= s1.max)
     join sizes s2 on (d2.height > s2.min) and (d2.height <= s2.max)
     where s1.size = s2.size;

select '';
select 'Each stack of dogs, consisting of 4 distinct dogs, with a stack ';
select 'height of at least 170, arranged by ascending dog and stack height:'
select a.name || ', ' || 
       b.name || ', ' || 
       c.name || ', ' ||
       d.name, 
       a.height + b.height + c.height + d.height as stack_height
from dogs a
     join dogs b on a.height < b.height
     join dogs c on b.height < c.height
     join dogs d on c.height < d.height
where stack_height > 170
order by stack_height;

select '';
select 'Height and name of every dog that shares the 10s digit of its ';
select 'height with at least one other dog and has the highest 1s digit ';
select 'of all dogs with heights of the same 10s digit:';
select height, name
from dogs
group by (height/10)
having (height%10) = max(height%10)
and count(height/10) > 1;

select '';
select 'All pairs of dogs related as grandparents/children or great-';
select 'grandparents/children, ordered by descending height difference:';
with gparents(gparent, gchild) as (
     select x.parent as gparent, y.child as gchild
     from parents x
          join parents y on x.child = y.parent
),  
ggparents(ggparent, ggchild) as (
     select x.parent as ggparent, z.child as ggchild
     from parents x
          join parents y on x.child = y.parent
          join parents z on y.child = z.parent
)
select x.name, y.name
from dogs x
     join dogs y
     left join gparents gcx on x.name = gcx.gchild
     left join gparents gcy on y.name = gcy.gchild
     left join ggparents ggcx on x.name = ggcx.ggchild
     left join ggparents ggcy on y.name = ggcy.ggchild
where x.height <= y.height
      and gcx.gparent = y.name
      or gcy.gparent = x.name
      or ggcx.ggparent = y.name
      or ggcy.ggparent = x.name 
order by (y.height - x.height) desc;
