SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 
	DATE_TRUNC('quarter', order_date_date)
ORDER BY total_revenue DESC
LIMIT 1
;

SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY DATE_TRUNC('quarter', order_date_date),
DATE_TRUNC('month', order_date_date)
ORDER BY total_revenue DESC
LIMIT 3
;

SELECT
  order_date_date,
  CURRENT_DATE - order_date_date AS days_since_order
FROM sales_analysis
WHERE CURRENT_DATE - order_date_date < 60
;