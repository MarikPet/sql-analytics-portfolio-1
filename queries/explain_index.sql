EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;

-- Sequential scan used on the sales table
-- grouping by product_id is low in cost: 0.00-139.00 on 5000 rows, due to the index set 