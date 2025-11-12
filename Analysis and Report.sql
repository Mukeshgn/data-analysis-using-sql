---EDA
---------------------------------------
-- Import datasets
------------------------------------------
SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM raiders;
SELECT * FROM deliveries;


-----------------------------------
--HANDLING NULL VALUES
-----------------------------------

-- Check NULL values in table (update or delete)
-- check customers
SELECT * FROM customers
WHERE 
	customer_id IS NULL
	OR
	customer_name IS NULL
	OR
	reg_date IS NULL;

UPDATE customers
SET reg_date = CURRENT_DATE
WHERE reg_date IS NULL


-- check deliveries
SELECT * FROM deliveries
WHERE 
	delivery_id IS NULL
	OR
	order_id IS NULL
	OR
	raider_id IS NULL
	OR
	delivery_status IS NULL
	OR
	delivery_time IS NULL;


-- check orders
SELECT * FROM orders
WHERE 
	customer_id IS NULL
	OR
	order_id IS NULL
	OR
	restaurant_id IS NULL
	OR
	order_item IS NULL
	OR
	order_time IS NULL
	OR
	order_date IS NULL
	OR
	total_amount IS NULL
	OR
	order_status IS NULL;


-- check raiders
SELECT * FROM raiders
WHERE 
	raider_id IS NULL
	OR
	raider_name IS NULL
	OR
	sign_up IS NULL;

-- check restaurants
SELECT * FROM restaurants
WHERE 
	restaurant_id IS NULL
	OR
	restaurant_name IS NULL
	OR
	city IS NULL
	OR
	rating IS NULL;


-------------------------------
-- Analysis & Reports
--------------------------------

-- Q.1 
-- WRITE A QUERY TO FIND THE TOP 5 MOST FREQUENTLY ORDERED DISHES BY CUSTOMER CALLED "Arjun Mehta" IN LAST 1 YEAR.


--- join customer and orders
--- filter arjun mehtha
--- filter 1 year
--- group ny customer_id,customer_name

SELECT 
	customer_name,
	order_item,
	total_orders
FROM
(
	SELECT 
		c.customer_id,
		c.customer_name,
		o.order_item,
		COUNT(*) AS total_orders,
		DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as rk
	FROM orders AS o
	JOIN customers AS c
	ON c.customer_id  = o.customer_id
	WHERE 
		o.order_date >= CURRENT_DATE - INTERVAL '1 Year'
		AND
		c.customer_name = 'Arjun Mehta'
	GROUP BY c.customer_id,c.customer_name,o.order_item
	ORDER BY total_orders DESC
) WHERE rk <= 5
;

--- OR

WITH details AS (
	SELECT 
		c.customer_id, 
		c.customer_name,
		o.order_item, 
		count(*) AS total_order
	FROM orders AS o
	JOIN
	customers AS c
	ON c.customer_id = o.customer_id
	WHERE 
		customer_name = 'Arjun Mehta'
		AND
		order_date >= CURRENT_DATE - INTERVAL '1 Year'
	GROUP BY
		o.order_item,c.customer_name,c.customer_id
)
SELECT  
		customer_name,
		order_item,
		total_order
FROM (
	SELECT *,
	DENSE_RANK() OVER (ORDER BY total_order DESC) AS rk
	FROM details
) t
WHERE rk <= 5
ORDER BY total_order DESC;





-- Q.2.FIND POPULAR TIME SLOTS
-- IDENTIFY THE TIME SLOTS DURING WHICH THE MOST ORDERS ARE PLACED. BASED ON 2 HOUR INTERVAL.

SELECT 
	CASE
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00 - 04:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00 - 06:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00 - 08:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00 - 10:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00 - 16:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN '22:00 - 00:00'
	END AS time_slots,
	COUNT(order_id) AS order_count 
FROM orders
GROUP BY time_slots
ORDER BY order_count DESC;

-- (OR)

SELECT 
	FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 as start_time,
	CASE
		WHEN (FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 +2) = 24 THEN 0
		ELSE (FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 +2)
	END as end_time,
	COUNT(order_id) AS order_count
FROM orders
GROUP BY start_time,end_time
ORDER BY order_count DESC;

--(OR)

SELECT 
	LPAD((FLOOR(EXTRACT(HOUR from order_time)/2)*2)::int::text, 2, '0')|| ':00-' || 
	LPAD(
		(
			CASE 
				WHEN FLOOR(EXTRACT(HOUR FROM order_time)/2)*2+2 = 24 THEN 0
				ELSE FLOOR(EXTRACT(HOUR FROM order_time)/2)*2+2
			END
		)::int::text, 2, '0')
	|| ':00' AS time_interval,
	COUNT(order_id) AS order_count
FROM orders
GROUP BY time_interval
ORDER BY order_count DESC;




-- Q.3 ORDER VALUE ANALYSIS
-- FIND THE AVERAGE ORDER VALUE PER CUSTOMER WHO HAS 
--- PLACED MORE THAN 330 ORDERS.
-- RETURN CUSTOMER NAME AND AVERAGE ORDER VALUE
	

SELECT 
	c.customer_name, 
	ROUND(AVG(o.total_amount)::numeric,2) as average_order,
	COUNT(order_id) as total_orders
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id 
GROUP BY c.customer_name
HAVING COUNT(o.order_id) >= 330;




-- Q.4 HIGH VALUE CUSTOMERS
-- LIST THE CUSTOMERS WHO HAVE SPENT MORE THAN 175K IN TOTAL ON FOOD ORDERS.RETURN CUSTOMER NAME AND CUSTOMER ID

SELECT 
	c.customer_id, 
	c.customer_name, 
	SUM(o.total_amount) AS total_spent
FROM customers AS c
JOIN orders AS o
ON c.customer_id=o.customer_id
GROUP BY c.customer_name,c.customer_id
HAVING SUM(o.total_amount) > 175000;



--- Q.5 ORDERS WIHTOUT DELIVERY
-- WRITE A SQL QUERY TO FIND ALL THE DELIVERIES THAT FAILED
-- FOR EACH FAILED DELIVERY RETURN ORDER ID,CUSTOMER ID,RESTAURANT ID,RESTAURANT NAME
-- RAIDER ID, DELIVERY ID, DELIVERY STATUS.


select 
	o.order_id,o.customer_id,
	r.restaurant_id,r.restaurant_name,
	d.raider_id,d.delivery_status,d.delivery_id
FROM
	orders AS o
	JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
	JOIN deliveries AS d ON o.order_id = d.order_id
GROUP BY 
	o.order_id,o.customer_id,
	r.restaurant_id,r.restaurant_name,
	d.raider_id,d.delivery_status,d.delivery_id
HAVING
	d.delivery_status = 'Failed'
	
-- 	Q5. Order without Delivery
-- Question: Write a query to find orders that were placed but not delivered.
-- Return each restaurant name, city and number of not delivered orders

select 
	r.restaurant_name, 
	COUNT(o.order_id) as cnt_not_delivered_orders
FROM
	orders AS o
	JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
	JOIN deliveries AS d ON o.order_id = d.order_id
WHERE delivery_id IS NOT NULL
GROUP BY r.restaurant_name


-- Q.6 RESTAURANT REVENUE RANKING
-- RANK RESTAURANTS BY THEIR TOTAL REVENUE FROM THE LAST YEAR, INLCUDING THEIR NAME
-- TOTAL REVENUE, RANKING


SELECT
	r.city,
	r.restaurant_name,
	SUM(o.total_amount) as Total_amount,
	RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS ranking
FROM 
	restaurants AS r
JOIN 
	orders AS o
ON
	r.restaurant_id = o.restaurant_id
WHERE 
	o.order_date >= CURRENT_DATE - INTERVAL '1 Year'
GROUP BY
	r.restaurant_name,r.city
ORDER BY
	1,3 DESC




-- Q.7 MOST POPULAR DISH BY CITY
-- IDENTIFY THE MOST POPULAR DISH IN EACH CITY BASED ON NUMBER OF ORDERS

SELECT * 
from (
	SELECT 
		r.city,
		o.order_item AS dish,
		COUNT(o.order_id),
		RANK() OVER(PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) AS rc
	FROM orders AS o
	JOIN restaurants AS r
	ON r.restaurant_id = o.restaurant_id
	GROUP BY r.city,o.order_item
	ORDER BY COUNT(o.order_id) DESC
)
WHERE rc = 1;


-- Q.8 CUSTOMER CHURN
-- FIND THE CUSTOMERS WHO HAVEN'T placed an order in 2025 but did in 2024

-- BREAK DOWN
-- FIND CUSTOMERS WHO HAS DONE ORDERS IN 2023
-- FIND CUSTOMERS WHO HAS NOT DONE ORDERS IN 2024
-- COMPARE 1 AND 2 USING SUB QUERY

SELECT DISTINCT(customer_id) FROM orders
WHERE
	EXTRACT (YEAR FROM order_date) = 2024
	AND 
	customer_id NOT IN 
						(
						SELECT DISTINCT(customer_id) FROM orders
						WHERE 
							EXTRACT (YEAR FROM order_date) = 2025
						)





-- Q.9 CANCELLATION RATE COMPARISION
-- CALUCULATE AND COMPARE ORDER CANCELLATION RATE FOR EACH RESTAURANT 
-- BETWEEN THE CURRENT YEAR AND LAST YEAR

WITH cancel_ratio_24
AS
(
		SELECT
			restaurant_id,
			COUNT(order_id) AS total_orders,
			COUNT(CASE WHEN order_status ='Cancelled' THEN 1 END) AS cancelled_orders
		FROM orders
		WHERE EXTRACT (YEAR FROM order_date)=2024
		GROUP BY restaurant_id
),

cancel_ratio_25
AS
(
SELECT
	restaurant_id,
	COUNT(order_id) AS total_orders,
	COUNT(CASE WHEN order_status ='Cancelled' THEN 1 END) AS cancelled_orders
FROM orders
WHERE EXTRACT (YEAR FROM order_date)=2025
GROUP BY restaurant_id
),

last_year_data
AS
(
		SELECT 
				restaurant_id,
				total_orders,
				cancelled_orders,
				ROUND(cancelled_orders::numeric/total_orders::numeric * 100,2) AS cancelation_ratio
		FROM cancel_ratio_24
),

current_year_data
AS
(
SELECT 
		restaurant_id,
		total_orders,
		cancelled_orders,
		ROUND(cancelled_orders::numeric/total_orders::numeric * 100,2) AS cancelation_ratio
FROM cancel_ratio_25
)

SELECT
		current_year_data.restaurant_id AS rest_id,
		current_year_data.cancelation_ratio AS curr_cs_ratio,
		last_year_data.cancelation_ratio AS last_cs_ratio
FROM current_year_data
JOIN
last_year_data
ON  current_year_data.restaurant_id=last_year_data.restaurant_id



-- Q.10 RIDERS AVERAGE DELIVERY TIME
-- CALUCULATE EACH RIDERS'S AVERAGE DELIVERY TIME


SELECT 
		o.order_id,
		o.order_time,
		d.delivery_time,
		d.raider_id,
		d.delivery_time - o.order_time AS time_difference,
		EXTRACT(EPOCH FROM(d.delivery_time - o.order_time + 
		CASE WHEN delivery_time < order_time THEN INTERVAL '1 day' ELSE
		INTERVAL '0 day' END))/60 AS time_diff_in_min
FROM 
orders AS o
JOIN deliveries as d
ON o.order_id=d.order_id
WHERE d.delivery_status='Delivered'




-- Q.11 MONTHLY RESTAURANT GROWTH RATIO
-- CALUCULATE EACH RESTAURANT GROWTH RATIO BASED ON THE TOTAL NUMBER OF DELIVERED ORDERS


WITH growth_ratio
AS
(
SELECT 
		o.restaurant_id,
		 DATE_TRUNC('month', o.order_date) AS order_month,
		 TO_CHAR(o.order_date, 'Mon-YY') AS month_label,
		COUNT(o.order_id) AS curr_month_orders,
		LAG(COUNT(o.order_id)) OVER (PARTITION BY o.restaurant_id ORDER BY DATE_TRUNC('month', o.order_date)) AS previous_orders

FROM orders AS o
JOIN
deliveries AS d
ON
o.order_id=d.order_id
WHERE d.delivery_status='Delivered'
GROUP BY o.restaurant_id, order_month, month_label
ORDER BY o.restaurant_id,order_month
)
SELECT 
		restaurant_id,
		order_month,
		month_label,
		previous_orders,
		curr_month_orders,
		ROUND((curr_month_orders::numeric - previous_orders::numeric) / previous_orders::numeric * 100,2) 
		AS monthly_growth_ratio
FROM growth_ratio




-- Q12.CUSTOMER SEGMENTATION
-- SEGMENT CUSTOMER INTO 'GOLD' OR 'SILVER' GROUPS BASED ON THEIR TOTAL SPENDING
-- COMPARED TO THE AVERAGE ORDER VALUE,IF THE CUSTOMER AOV INCREASES AOV,
-- LABEL THEM AS 'GOLD' OTHER WISE LABEL THEM AS 'SILVER' .WRITE AN SQL QUERY TO DETERMINE EACH
-- SEGMENTS TOTAL NUMBER OF ORDERS AND TOTAL REVENUE


-- BREAKDOWN
-- FIND EACH CUSTOMER TOTAL SPENDING
-- AVERAGE ORDER VALUE
-- GOLD
-- SILVER
-- EACH CATEGORY AND TOTAL ORDERS AND TOTAL REVENUE


SELECT 
		customer_category,
		SUM(total_orders) AS total_orders,
		SUM(total_spent) AS total_spent
FROM
(
		SELECT 
				customer_id,
				SUM(total_amount) AS total_spent,
				COUNT(order_id) AS total_orders,
				CASE WHEN SUM(total_amount) > (SELECT AVG(total_amount) FROM orders) THEN 'GOLD'
				ELSE 'SILVER'
				END AS customer_category
		
		FROM orders
		GROUP BY customer_id
		) AS t1

GROUP BY customer_category;


--SELECT AVG(total_amount) FROM orders --552



-- Q.13 RIDER MONTHLY EARNINGS
-- CALUCULATE EACH RIDER MONTHLY EARNINGS, ASSUMMING THEY EARN 8% FROM THE ORDER AMOUNT


SELECT 
		d.raider_id,
		DATE_TRUNC('month', o.order_date) AS order_month,
    	TO_CHAR(o.order_date, 'Mon-YY') AS month_label,
		SUM(total_amount) AS total_revenue, 
		SUM(total_amount) * 0.08 AS rides_monthly_revenue
FROM orders AS o
JOIN deliveries AS d
ON o.order_id=d.order_id
GROUP BY d.raider_id,order_month, month_label
ORDER BY d.raider_id,order_month,month_label DESC


-- Q.14 RIDER RATING ANALYSIS
-- FIND NUMBER OF 5-STAR, 4-STAR, 3-STAR RATINGS EACH HAVE
-- RIDERS RECEIVE THIS RATING BASED ON DELIVERY TIME
-- IF ORDERS DELIVERED BELOW 30-MINUTES OF ORDER RECIEVED TIME THE RIDER GET 5-STAR RATING
-- IF THEY DELIVER 30 AND 60 MINUTE THEY GOT 4-STAR RATING
-- IF THEY DELUVER AFTER 60 MINUTE THEY GET 3-STAR RATING


SELECT 
	raider_id,
	stars,
	COUNT(*) AS total_stars
FROM
(
		SELECT 
			raider_id,
			delivery_took_time,
			CASE
				WHEN delivery_took_time < 30 THEN '5 star'
				WHEN delivery_took_time BETWEEN 30 AND 60 THEN '4 star'
				ELSE '3 star'
				END AS stars
		FROM
(
		SELECT 
				o.order_id,
				o.order_time,
				d.delivery_time,
				EXTRACT(EPOCH FROM(d.delivery_time - o.order_time +
				CASE WHEN d.delivery_time < order_time THEN INTERVAL '1 day'
				ELSE INTERVAL '0 day' END 
				)) /60 AS delivery_took_time,
				d.raider_id
		FROM orders AS o
		JOIN deliveries AS d
		ON o.order_id=d.order_id
		WHERE delivery_status = 'Delivered'
) AS t1
) AS t2

GROUP BY raider_id, stars
ORDER BY raider_id, total_stars



-- Q.15 IDENTIFY THE ORDER FREQUENCY BY DAY
-- ANALYZE ORDER FREQUENCY PER DAY OF WEEK AND IDENTIFY THE PEAK DAY FOR EACH RESTAURANT


SELECT *
FROM
(
		SELECT 
			r.restaurant_name,
			-- o.order_date,
			TO_CHAR(o.order_date, 'Day') As Day,
			COUNT(o.order_id) AS total_orders,
			RANK() OVER(PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id) DESC) AS rank
		FROM orders AS o
		JOIN
		restaurantS AS r
		ON o.restaurant_id = r.restaurant_id
		GROUP BY r.restaurant_name, Day
		ORDER BY r.restaurant_name, total_orders DESC
		
)AS t1
WHERE rank = 1



-- Q.16 CUSTOMER LIFETIME VALUE (CLV)
-- CALUCULATE THE TOTAL REVENUE GENERATED BY EACH CUSTOMER OVER ALL THEIR ORDERS

SELECT 
		customer_id,
		SUM(total_amount)
FROM orders
GROUP BY customer_id
ORDER BY customer_id



-- Q.17  MONTHLY SLARY TRENDS
-- IDENTIFY SALES TRENDS BY COMPARING EACH MONTH'S TOTAL SALES TO PREVIOUS MONTH

SELECT 
		EXTRACT(YEAR FROM order_date) AS year,
		EXTRACT(MONTH FROM order_date) AS month,
		LAG(SUM(total_amount), 1) 
		OVER(ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) 
		AS prev_month_sale,
		SUM(total_amount) AS total_sale
FROM ORDERS
GROUP BY year,month
ORDER BY year,month


-- Q.18 RIDER EFFICIENCY
-- EVALUATE RIDER EFFICIENCY  BY DETERMINING AVERAGE DELIVERY TIMES 
-- IDENTIFYING THOSE WITH THE LOWEST AND HIGHEST AVERAGES


WITH new_table
AS
(
		SELECT 
				*,
				d.raider_id AS raiders_id,
				EXTRACT(EPOCH FROM(d.delivery_time - o.order_time +
				CASE WHEN d.delivery_time < order_time THEN INTERVAL '1 day'
				ELSE INTERVAL '0 day' END 
				)) /60 AS delivery_took_time
		FROM orders AS o
		JOIN
		deliverieS AS d
		ON o.order_id=d.order_id
		WHERE d.delivery_status='Delivered'
),

raiders_time
AS
(
		SELECT 
				raiders_id,
				AVG(delivery_took_time) AS avg_time
		FROM new_table
		GROUP BY raiders_id
)

SELECT 
		MIN(avg_time),
		MAX(avg_time)
FROM raiders_time
		


-- Q.19 ORDER ITEM POPULARITY
-- TRACK THE POPULARITY OF SPECIFIC ORDER ITEMS OVER TIME AND IDENTIFY SEASONAL DEMAND SPIKES.

SELECT
		order_item,
		seasons,
		COUNT(order_id) AS total_orders
FROM
(
		SELECT *,
				EXTRACT(MONTH FROM order_date) AS month,
				CASE 
					WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 'spring'
					WHEN EXTRACT(MONTH FROM order_date) > 6 AND
					EXTRACT(MONTH FROM order_date) < 9 THEN 'summer'
					ELSE 'winter' END AS seasons
		FROM orders
) AS t1
GROUP BY order_item, seasons
ORDER BY order_item, total_orders DESC



-- Q.20 RANK EACH CITY BASED ON THE TOTAL REVENUE FRO LAST YEAR 2023

SELECT 
		r.city,
		SUM(total_amount) AS total_revenue,
		RANK() OVER(ORDER BY SUM(total_amount) DESC) AS city_rank
FROM orders AS o
JOIN
restaurantS AS r
ON o.restaurant_id = r.restaurant_id
GROUP BY r.city


------------------------------------------------------------
-- END OF REPORTS
------------------------------------------------------------