-- The top quarter by revenue
SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('quarter', order_date_date)
ORDER BY 
	quarter
	-- total_revenue DESC
-- LIMIT 1
;

-- Quarterly aggregation of revenue didn't reveal any common trend.
-- The strongest growth period is the second quarter of 2023, and the lowest is the third quarter of 2023


-- Monthly aggregation of revenue
SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('month', order_date_date)
ORDER BY 
	month
	-- total_revenue DESC
;

-- Monthly aggregation of revenue shows that while in 2020 its value was relatively low, it was stable across months. 
-- During the next two years, revenue flow was quite unstable and stabilized in the last year.  
-- The highest levels of revenue are observed in spring-end and summer months, and in December mostly. 
-- The strongest growth month is December 2021. The lowest growth month is September 2023. 


-- Yearly aggregation of revenue
SELECT
	DATE_TRUNC('year', order_date_date) AS year,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('year', order_date_date)
ORDER BY 
	year
	-- total_revenue DESC
-- LIMIT 1
;

-- Yearly aggregation of revenue shows wave-shaped behavior, 
-- growing in one year and decreasing in the next, and
-- having the highest value in 2021, and the lowest in 2022.


-- So different grains show different aspects of the same phenomenon.


--The time passed since the last transaction. The last transaction's age.
SELECT
	customer_name,
 	order_date_date,
  	CURRENT_DATE - order_date_date AS days_since_order,
  	AGE(CURRENT_DATE, order_date_date) AS order_age
FROM sales_analysis
GROUP BY 
	customer_name,
	order_date_date
;