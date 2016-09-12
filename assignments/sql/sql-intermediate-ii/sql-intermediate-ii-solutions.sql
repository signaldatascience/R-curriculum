-- Thanksgiving questions

-- going home
with flights(day, cur, prev, prev2) as (
  SELECT 1, 20, 0, 0 UNION
  SELECT 2, 30, 20, 0 UNION
  SELECT 3, 40, 30, 20 UNION
  SELECT day + 1, (cur + prev)/2 + (5 * ((day+1) % 7)), cur, prev FROM flights
    WHERE day >= 3 and day < 25
)
SELECT day as Day, cur as Price FROM flights;

-- friend's flight
with trips(path, ending, flights, cost) as (
  SELECT departure || ", " || arrival, arrival, 1, price FROM flights
    WHERE departure = "SFO" UNION
  SELECT path || ", " || arrival, arrival, flights + 1, cost + price
    FROM trips, flights
    WHERE ending = departure AND flights < 2
)
SELECT path, cost FROM trips WHERE ending = "PDX" ORDER BY cost;

-- Should output:
-- SFO, SLC, PDX|176
-- SFO, LAX, PDX|186
-- SFO, PDX|192

-- all possible shopping lists
with cart(list, last, budget) as (
  SELECT item, price, 60 - price FROM supermarket WHERE price <= 60 UNION
  SELECT list || ", " || item, price, budget - price FROM cart, supermarket
    WHERE price <= budget AND price >= last
)
SELECT list, budget FROM cart ORDER BY budget, list;

-- TODO: add solution for restricting to at most 2 of any item
-- Whoever finishes this question first can email me with their solution and I'll add it :-)

-- different types of meats
SELECT COUNT(DISTINCT meat) from main_course;

-- number of full meals
SELECT COUNT(*) FROM main_course as m, pies as p
  WHERE m.calories + p.calories < 2500;

-- healthiest meal involving particular meat
SELECT meat, MIN(m.calories + p.calories) as calories
  FROM main_course as m, pies as p
  GROUP BY meat HAVING MAX(m.calories + p.calories) < 3000;

-- average price in each category
SELECT category, AVG(MSRP) FROM products GROUP BY category;
-- alternate solution
-- SELECT category, SUM(MSRP)/COUNT(*) FROM products GROUP BY category;

-- figuring out where items are sold for lowest price
SELECT item, store, MIN(price) FROM inventory GROUP BY item;

-- making the shopping list table
with shopping_list_helper (name, price) as (
  SELECT name, min(MSRP/rating) FROM products GROUP BY category
)
SELECT s.name as item, l.store as store
  FROM lowest_prices as l, shopping_list_helper as s
  WHERE l.item = s.name;

-- total amount of bandwidth necessary
SELECT SUM(s.MiBs) FROM stores as s, shopping_list as sl WHERE s.store = sl.store;

-- MovieLens questions
-- There may be multiple ways to do these questions depending on how you
-- created your database, what you name your tables and columns, etc. Use
-- the below as a guide, not as exact solutions.

-- number of movies released in each year
SELECT date, COUNT(mid) FROM movie WHERE date IS NOT NULL GROUP BY date;

-- ALTERNATE SOLUTION
SELECT SUBSTR(SUBSTR(Name, -5), 1, 4) AS Year, COUNT(*) AS numMovies FROM Movies GROUP BY Year;

-- percent of movies each year which are dramas
SELECT a.Year, 100*numDrama*1.0 / numMovies percentDrama FROM (
  SELECT COUNT(*) AS numMovies, SUBSTR(SUBSTR(Name, -5), 1, 4) AS Year
    FROM Movies GROUP BY Year
  ) a LEFT JOIN (
  SELECT COUNT(*) AS numDrama, SUBSTR(SUBSTR(Name, -5), 1, 4) AS Year
    FROM Movies WHERE genrePipe LIKE '%Drama%' GROUP BY Year
  ) b ON (b.Year=a.Year);

-- percent of users with titles beginning with same first letter
SELECT SUBSTR(Name, 1, 1) AS firstLetter, COUNT(*) AS numMovies
  FROM Movies GROUP BY firstLetter ORDER BY numMovies DESC LIMIT 5;

-- percent of users in each zip code region
SELECT ROUND(zipcode/10000) AS first, CAST(COUNT(uid) AS FLOAT)/CAST(6040 AS FLOAT) AS num
  FROM user GROUP BY first ORDER BY num DESC;
-- ALTERNATE SOLUTION
SELECT SUBSTR(zipcode, 1, 1) AS zipFirst, 100*COUNT(*)*1.0 / (SELECT COUNT(*) FROM Users) AS percentUsers
  FROM users GROUP BY zipFirst ORDER BY zipFirst DESC;

-- average movie rating in each category
SELECT Age, AVG(rating) AS avgRating, COUNT(*) as numRatings
  FROM Users LEFT JOIN Ratings ON (Users.userID=Ratings.userID)
  GROUP BY Age ORDER BY numRatings DESC;
SELECT Sex, AVG(rating) AS avgRating, COUNT(*) as numRatings
  FROM Users LEFT JOIN Ratings ON (Users.userID=Ratings.userID)
  GROUP BY Sex ORDER BY numRatings DESC;
SELECT occupationCode, AVG(rating) as avgRating, COUNT(*) as numRatings
  FROM Users LEFT JOIN Ratings ON (Users.userID=Ratings.userID)
  GROUP BY occupationCode ORDER BY numRatings DESC;

-- which movies are rated highest for each category
-- below query can be modified for various analyses, e.g., adding "HAVING avgRating < 5"
SELECT Sex, Name, AVG(rating) as avgRating, COUNT(*) as numRatings
  FROM Users LEFT JOIN Ratings ON (Users.userID=Ratings.userID)
    LEFT JOIN Movies ON (Ratings.movieID=Movies.movieID)
  GROUP BY Name, Sex ORDER BY avgRating DESC LIMIT 20;