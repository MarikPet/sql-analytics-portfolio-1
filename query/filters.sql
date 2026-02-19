-- Classified by sales value
SELECT
	transaction_id,
	category,
	city,

	CASE 
		WHEN total_sales > (SELECT
								AVG(total_sales) 
							FROM sales_analysis) + 100 
					AND discount < 0.1
				THEN 'High value'
		WHEN total_sales > (SELECT
								AVG(total_sales) 
							FROM sales_analysis) - 150
					AND discount BETWEEN 0.1 AND 0.19
				THEN 'Medium value'
		ELSE 'Too low value'
	END AS sales_value,

	SUM(quantity) AS total_quantity, 

	CASE
		WHEN quarter IN (1, 2) THEN 'First semester'
		ELSE 'Second semester'
	END AS year_period
	
FROM sales_analysis
WHERE 
	year = 2023
GROUP BY
	transaction_id,
	category,
	city,
	total_sales,
	discount,
	quarter
ORDER BY 
	sales_value, 
	total_quantity DESC
;


-- Categories with better sales performance
SELECT
	category,
	SUM(total_sales) AS sales_by_category,  
	COUNT(transaction_id) AS transaction_count,
	ROUND(AVG(discount), 4) AS avg_discount,
	CASE
		WHEN 
			SUM(total_sales) > 80000 
			AND COUNT(transaction_id) > 300
		THEN 'Strong performer'
			
		WHEN 
			SUM(total_sales) BETWEEN 60000 AND 80000
			AND COUNT(transaction_id) BETWEEN 230 AND 300
		THEN 'Awerage performer'
		ELSE 'Underperformer'
	END AS performer_level
FROM sales_analysis
WHERE year = 2023
GROUP BY 
	category
HAVING 
	CASE
		WHEN 
			SUM(total_sales) > 80000 
			AND COUNT(transaction_id) > 300
		THEN 'Strong performer'
			
		WHEN 
			SUM(total_sales) BETWEEN 60000 AND 80000
			AND COUNT(transaction_id) BETWEEN 230 AND 300
		THEN 'Awerage performer'
		
		ELSE 'Underperformer'
	END 
	IN ('Strong performer', 'Awerage performer')
ORDER BY sales_by_category DESC
;


-- Customer activity patterns by city
SELECT
	city,
	COUNT(*) AS transaction_per_city,
	CASE
		WHEN COUNT(*) > 3  THEN 'High Activity'
		WHEN COUNT(*) > 1 THEN 'Medium Activity'
		Else 'Low Activity'
	END AS customer_activity 
FROM sales_analysis
WHERE year = 2023
GROUP BY city
HAVING 
	CASE
		WHEN COUNT(*) > 3 THEN 'High Activity'
		WHEN COUNT(*) > 1 THEN 'Medium Activity'
		Else 'Low Activity'
	END IN ('High Activity', 'Medium Activity')
ORDER BY transaction_per_city DESC, customer_activity 
;


-- Discount level by categories
SELECT
	category,
	SUM(total_sales) AS sales_by_category,  
	discount,

	CASE
		WHEN discount >= (SELECT
							ROUND(AVG(discount), 2)-- 0.25
							FROM sales_analysis) 
						THEN 'Discount-Heavy'
		WHEN discount >= (SELECT
							ROUND(AVG(discount), 2)-- 0.25
							FROM sales_analysis) - 0.15
						THEN 'Moderate Discount'
		ELSE 'Low or No Discount'
	END AS discount_level
FROM sales_analysis
GROUP BY 
	category,
	discount
HAVING 
	category IS NOT NULL
	OR category != ''
ORDER BY discount DESC
;
