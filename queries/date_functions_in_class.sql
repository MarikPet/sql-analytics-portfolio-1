-- The top quarter by revenue
SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('quarter', order_date_date)
ORDER BY total_revenue DESC
LIMIT 1
;

--The top 3 months by revenue
SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('month', order_date_date)
ORDER BY total_revenue DESC
LIMIT 3
;

--Transactions from the last 60 days
SELECT
  order_date_date,
  CURRENT_DATE - order_date_date AS days_since_order
FROM sales_analysis
WHERE CURRENT_DATE - order_date_date < 60
;