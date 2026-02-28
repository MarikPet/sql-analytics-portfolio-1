-- NULL and Duplicate transactions check
SELECT
	COUNT(*) AS row_count,
	COUNT(transaction_id) AS transaction_count,  -- check for existing NULL values
	COUNT(DISTINCT transaction_id)               -- check for existing NULL values and duplicates
FROM sales_analysis
;
-- As all three values are 5000, there are no NULL or Duplicate transactions by id. 


-- Check if there exist Duplicate rows describing 
-- the same purchase (the same timestamp, the same customer, the same product) 
SELECT
	product_name,
	order_date,
	customer_name,
	COUNT(*) AS occurrence_count
FROM sales_analysis
GROUP BY 
	product_name,
	order_date,
	customer_name
HAVING 
	COUNT(*) > 1
ORDER BY occurrence_count DESC
;
-- The result is an empty table, so there are no duplicate transactions.


-- Check for possible 0 value total sales and 0 value discounts
SELECT
	discount
FROM sales_analysis
-- WHERE discount = 0.0
WHERE discount IS NULL   -- 51 transactions have NULL discount (this line is added after UPDATE)
;
-- This reveals 51 transactions without discount (0.0) 


-- Replace 0.0 value discounts with NULL
UPDATE sales_analysis
SET discount = NULL 
WHERE discount = 0.0;


-- Compare average discounts derived differently, then calculate total sales 
SELECT                      
	-- category,
	COUNT(DISTINCT transaction_id) AS transactions_count,   -- check for existing NULL values and duplicates (if there are duplicates, rows < 5000)
	ROUND(AVG(discount), 3) AS default_avg_discount,   
	ROUND(AVG(total_sales)) AS avg_total_sales,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY discount))::numeric, 3) AS median_discount,
	ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_sales))::numeric, 3) AS median_total_sales,
	ROUND(AVG(COALESCE(discount, 0.0)), 3) AS null_to_0_avg_discount,
	ROUND(AVG(COALESCE(discount, 0.252)), 3) AS null_to_mean_avg_discount,
	ROUND(AVG(COALESCE(discount, 0,25)), 3) AS null_to_median_avg_discount,
	ROUND(AVG(total_sales) * (1 - 0.252), 3) AS avg_transaction_value,
	ROUND(
		(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_sales))::numeric * (1 - 0.249), 3
		) AS median_transaction_value,
	SUM(total_sales * (1 - 0.252)) AS total_revenue,
	CEILING((total_sales * (1 - 0.252)) / 50) * 50 AS revenue_range_50,
	COUNT(DISTINCT (employee_first_name || ' ' || employee_last_name)) AS employee_count,
	COUNT(employee_salary) AS salary_records_count,
	COUNT(DISTINCT employee_first_name) AS name_count,
	COUNT(DISTINCT employee_last_name) AS last_name_count
FROM sales_analysis
GROUP BY 
	-- category
	CEILING((total_sales * (1 - 0.252)) / 50) * 50
ORDER BY 
	-- revenue_range_50 DESC
	total_revenue DESC
;

-- Total revenue is 941245.39608 (The sum of (total_sales * null_to_mean_avg_discount)),
-- and it descends by category this way: Electronics, Toys, Home & Garden, Books, Clothing.
-- Analysis reveals that the largest revenue share is in the category 'Electronics': 79715.18016.

-- Based on the comparison of default_avg_discount(0.252), median_discount(0.25), 
-- and also of null replacement with 0/mean/median values, we can see that the difference 
-- between them is quite small (they are almost equal), and so we can consider the discount data 
-- as distributed normally. 
-- avg_transaction_value(188.249) and median_transaction_value(188.602) differ by ≈ 0.4, 
-- which is small enough in 188 to consider the data as not skewed.  
-- Therefore, we can safely replace NULL values with the mean (avg) value and use null_to_mean_avg_discount
-- for further computations.

-- Transaction duplicate check reveals that there are no duplicate transactions_id

-- Revenue distribution analysis 
-- when grouped by revenue range, shows transactions_count by range and total_revenue by range,
-- when ordered by total revenue, shows that the dominant revenue range is 350 (300 < x <= 350)

-- Comparison of the distinct empolyees count and the salary records count shows that one employee 
-- has more than one salary record, so we can not do aggregation directly by employee_salary. 
-- It will not be realistic. 

-- Another problem with the sales_analysis table is the employee_first_name and employee_last_name column: 
-- while the employee count per range is 100 or 95, the employee_first_name count is 84 or 80, 
-- that means there are several name-surname permutations whit, at least, repeating names. 
-- So aggregations by the first_name rather will be misleading. 
