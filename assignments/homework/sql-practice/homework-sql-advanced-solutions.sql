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

-- shopping
with cart(list, last, budget) as (
  SELECT item, price, 60 - price FROM supermarket WHERE price <= 60 UNION
  SELECT list || ", " || item, price, budget - price FROM cart, supermarket
    WHERE price <= budget AND price >= last
)
SELECT list, budget FROM cart ORDER BY budget, list;

-- need solution for restricting to at most 2 of any item

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