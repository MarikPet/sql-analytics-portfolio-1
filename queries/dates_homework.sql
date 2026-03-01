SELECT 
	*
FROM sales_analysis
;

SELECT
  order_date_date,
  EXTRACT(YEAR FROM order_date_date)  AS year,
  EXTRACT(MONTH FROM order_date_date) AS month,
  EXTRACT(DAY FROM order_date_date)   AS day, 
  EXTRACT(DOW FROM order_date_date) as weekday
FROM sales_analysis
LIMIT 5
;


SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('month', order_date_date) 
ORDER BY month
;


SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('quarter', order_date_date) 
ORDER BY quarter
;

SELECT
	DATE_TRUNC('year', order_date_date) AS year,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('year', order_date_date) 
ORDER BY year
;

SELECT NOW();