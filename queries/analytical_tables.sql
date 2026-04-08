-- What is the general statistical summary of coffee shop condition?
SELECT
	MAX(date) AS max_date,                                                    
	MIN(date) AS min_date,                                                    
	MAX(date) - MIN(date) AS date_interval,                                   
	SUM(quantity) AS total_quantity,
	ROUND(AVG(quantity), 2) AS avg_quantity,
	MAX(quantity) AS max_quantity,
	MIN(quantity) AS min_quantity,
	MAX(quantity) - MIN(quantity) AS quantity_range,
	SUM(quantity*unit_price) AS total_revenue,
	ROUND(AVG(quantity*unit_price), 2) AS avg_revenue,
	MAX(quantity*unit_price) AS max_revenue,
	MIN(quantity*unit_price) AS min_revenue,
	MAX(quantity*unit_price) - MIN(quantity*unit_price) AS revenue_range
FROM analytics.transactions
;


-- The data is about the sales for 180 days 
-- The quantity of products is likely centered around the 1-3 range 
-- The revenue is likely centered around the 3.99 -5.5 range 