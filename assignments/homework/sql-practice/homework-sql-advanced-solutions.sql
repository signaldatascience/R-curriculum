-- Thanksgiving questions

-- Question 1
with flights(day, cur, prev, prev2) as (
  SELECT 1, 20, 0, 0 UNION
  SELECT 2, 30, 20, 0 UNION
  SELECT 3, 40, 30, 20 UNION
  SELECT day + 1, (cur + prev)/2 + (5 * ((day+1) % 7)), cur, prev FROM flights
    WHERE day >= 3 and day < 25
)
SELECT day as Day, cur as Price FROM flights;

-- Question 2
with trips(path, ending, flights, cost) as (
  SELECT departure || ", " || arrival, arrival, 1, price FROM flights
    WHERE departure = "SFO" UNION
  SELECT path || ", " || arrival, arrival, flights + 1, cost + price
    FROM trips, flights
    WHERE ending = departure AND flights < 2
)
SELECT path, cost FROM trips WHERE ending = "PDX" ORDER BY cost;

-- Question 3
with cart(list, last, budget) as (
  SELECT item, price, 60 - price FROM supermarket WHERE price <= 60 UNION
  SELECT list || ", " || item, price, budget - price FROM cart, supermarket
    WHERE price <= budget AND price >= last
)
SELECT list, budget FROM cart ORDER BY budget, list;

-- Question 4
SELECT COUNT(DISTINCT meat) from main_course;


-- Question 5
SELECT COUNT(*) FROM main_course as m, pies as p
  WHERE m.calories + p.calories < 2500;

-- Question 6
SELECT meat, MIN(m.calories + p.calories) as calories
  FROM main_course as m, pies as p
  GROUP BY meat HAVING MAX(m.calories + p.calories) < 3000;

-- Question 7
SELECT category, AVG(MSRP) FROM products GROUP BY category;
-- alternate solution
-- SELECT category, SUM(MSRP)/COUNT(*) FROM products GROUP BY category;

-- Question 8
SELECT item, store, MIN(price) FROM inventory GROUP BY item;

-- Question 9
with shopping_list_helper (name, price) as (
  SELECT name, min(MSRP/rating) FROM products GROUP BY category
)
SELECT s.name as item, l.store as store
  FROM lowest_prices as l, shopping_list_helper as s
  WHERE l.item = s.name;

-- Question 10
SELECT SUM(s.MiBs) FROM stores as s, shopping_list as sl WHERE s.store = sl.store;