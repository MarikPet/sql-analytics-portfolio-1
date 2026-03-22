-- Aggregation window functions
SELECT
	 o.order_id,
	 customer_id,
	 ROUND(AVG(quantity*price) OVER(PARTITION BY customer_id), 2) AS order_avg_value_per_customer 
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON oi.product_id = p.product_id
;

-- Rank Window functions
SELECT
	 o.order_id,
	 customer_id,
	 quantity,
	 price,
	 (quantity*price) AS order_revenue,
	 PERCENT_RANK() OVER(PARTITION BY customer_id ORDER BY quantity*price) AS order_percent_rank 
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON oi.product_id = p.product_id
;

-- Value from another row Window functions
SELECT
	 o.order_id,
	 customer_id,
	 (quantity*price) AS order_revenue,
	 LAG(quantity*price) OVER(PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_order,
	 (quantity*price) -
	 COALESCE(LAG(quantity*price) OVER(PARTITION BY customer_id ORDER BY order_date), quantity*price) AS diff_previous_order
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON oi.product_id = p.product_id
;

-- Rank customers within city by their total spent
SELECT
	city_name,
	c.customer_id,
	SUM(quantity*price) AS total_spent,
	DENSE_RANK() OVER (PARTITION BY c.city_id ORDER BY SUM(quantity*price)) 		
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.customers c ON o.customer_id = c.customer_id 
JOIN analytics.products p ON oi.product_id = p.product_id
JOIN analytics.cities ci ON c.city_id = ci.city_id
GROUP BY city_name, c.customer_id
;

-- String aggregation window
SELECT
	CONCAT(first_name, ' ', last_name) AS customer,
	order_date,
	STRING_AGG(category, ', ') 
		OVER (PARTITION BY c.customer_id ORDER BY order_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 		
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.customers c ON o.customer_id = c.customer_id 
JOIN analytics.products p ON oi.product_id = p.product_id
;


CREATE TEMP TABLE tmp_sales AS
SELECT *
FROM (
    VALUES
        
        (1,  'A', DATE '2024-01-01', 100, 'online'),
        (2,  'A', DATE '2024-01-02', 120, 'store'),
        (3,  'A', DATE '2024-01-03', 90,  'online'),
        (4,  'A', DATE '2024-01-04', 130, 'store'),
        (4,  'A', DATE '2024-01-05', 110, 'store'),

        
        (5,  'B', DATE '2024-01-01', 180, 'store'),
        (6,  'B', DATE '2024-01-02', 200, 'online'),
        (7,  'B', DATE '2024-01-03', 220, 'online'),
        (8,  'B', DATE '2024-01-04', 200, 'store'),

        
        (9,  'C', DATE '2024-01-01', 150, 'online'),
        (10, 'C', DATE '2024-01-02', 150, 'online'),
        (11, 'C', DATE '2024-01-03', 170, 'online'),

        
        (12, 'D', DATE '2024-01-01', 90,  'store'),
        (13, 'D', DATE '2024-01-02', 110, 'store'),

        
        (14, 'E', DATE '2024-01-01', 140, 'store'),
        (15, 'E', DATE '2024-01-02', 160, 'online'),
        (16, 'E', DATE '2024-01-03', 155, 'store')
) AS t(
    sale_id,
    customer_id,
    sale_date,
    amount,
    channel
);


WITH beh_patt AS (SELECT
	customer_id,
	sale_date,
	channel,
	STRING_AGG(channel, ' -> ') OVER (
				PARTITION BY customer_id ORDER BY sale_date
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
				) AS behav_pattern
FROM tmp_sales)
SELECT
	customer_id,
	behav_pattern
FROM beh_patt
GROUP BY
	customer_id,
	behav_pattern
;
