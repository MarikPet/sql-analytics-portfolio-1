EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;

-- Sorting cost is high, because engine should scan total_sales for every row. 
-- So setting an index on total_sales will be no help, but burden the engine.  