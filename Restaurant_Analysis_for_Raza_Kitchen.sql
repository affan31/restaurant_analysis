-- create database restaurant_analysis_db;
/*
ALTER TABLE menu_items 
rename COLUMN ï»¿menu_item_id to menu_item_id;
*/
use restaurant_analysis_db;
select item_name, count(menu_item_id) as most_selling_item from menu_items group by item_name order by most_selling_item desc;
select * from order_details oi;

select * from menu_items mi;

select count(*) as total_items from menu_items mi;

-- 1. Most frequently ordered items
SELECT m.item_name, COUNT(od.item_id) AS total_orders
FROM order_details od
JOIN menu_items m ON od.item_id = m.menu_item_id
GROUP BY m.item_name
ORDER BY total_orders DESC
LIMIT 5;

-- 2. Best-selling category
SELECT m.category, COUNT(od.item_id) AS total_orders
FROM order_details od
JOIN menu_items m ON od.item_id = m.menu_item_id
GROUP BY m.category
ORDER BY total_orders DESC;

-- 3. Top 5 items by revenue with their category
SELECT m.item_name,m.category, round(SUM(m.price),2) AS total_revenue
FROM order_details od
JOIN menu_items m ON od.item_id = m.menu_item_id
GROUP BY m.item_name,m.category
ORDER BY total_revenue DESC
LIMIT 5;

-- 6. Daily sales trend
SELECT od.order_date, COUNT(*) AS total_orders
FROM order_details od
GROUP BY od.order_date
ORDER BY od.order_date;

-- 5. Sales by time of day (Morning, Afternoon, Evening, Night)
SELECT 
    CASE 
        WHEN HOUR(od.order_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(od.order_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(od.order_time) BETWEEN 18 AND 22 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS total_orders
FROM order_details od
JOIN menu_items m ON od.item_id = m.menu_item_id
GROUP BY time_of_day
ORDER BY total_orders DESC;






-- Is Hamburger cheaper than average?
SELECT m.item_name, m.price, 
       (SELECT AVG(price) FROM menu_items) AS avg_price
FROM menu_items m
WHERE m.item_name = 'Hamburger';






-- When is Hamburger mostly ordered?
SELECT HOUR(od.order_time) AS hour_of_day, COUNT(*) AS total_orders
FROM order_details od
JOIN menu_items m ON od.item_id = m.menu_item_id
WHERE m.item_name = 'Hamburger'
GROUP BY hour_of_day
ORDER BY total_orders DESC;


-- Is Hamburger often paired with something else?
SELECT m2.item_name, COUNT(*) AS times_ordered_together
FROM order_details od1
JOIN order_details od2 ON od1.order_id = od2.order_id AND od1.item_id <> od2.item_id
JOIN menu_items m1 ON od1.item_id = m1.menu_item_id
JOIN menu_items m2 ON od2.item_id = m2.menu_item_id
WHERE m1.item_name = 'Hamburger'
GROUP BY m2.item_name
ORDER BY times_ordered_together DESC
LIMIT 5;

-- 8. Items with declining demand (month-wise trend)

SELECT m.item_name, 
       DATE_FORMAT(od.order_date, '%Y-%m') AS month, 
       COUNT(*) AS total_orders
FROM order_details od
JOIN menu_items m ON od.item_id = m.menu_item_id
GROUP BY m.item_name, month
ORDER BY m.item_name, month;


-- 6. Item combinations (items often ordered together)
SELECT 
    m1.item_name AS item1_name,
    m2.item_name AS item2_name,
    COUNT(*) AS times_ordered_together
FROM order_details od1
JOIN order_details od2 
    ON od1.order_id = od2.order_id AND od1.item_id < od2.item_id
JOIN menu_items m1 ON od1.item_id = m1.menu_item_id
JOIN menu_items m2 ON od2.item_id = m2.menu_item_id
GROUP BY m1.item_name, m2.item_name
ORDER BY times_ordered_together DESC
LIMIT 5;
