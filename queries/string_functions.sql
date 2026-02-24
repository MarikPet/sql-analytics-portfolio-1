SELECT
	*
FROM transactions_text_demo
;

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT raw_phone) AS distinct_raw_phones,
  COUNT(DISTINCT category_raw) AS distinct_categories
FROM transactions_text_demo;

SELECT
  raw_phone,
  LENGTH(raw_phone) AS raw_phone_length,
  STRPOS(raw_phone, '-') AS has_hyphen,
  STRPOS(raw_phone, ')') AS has_paren,
  COUNT(*)
  
FROM transactions_text_demo
GROUP BY raw_phone
HAVING
	STRPOS(raw_phone, '-') != 0
	OR
	STRPOS(raw_phone, ')') != 0
;

SELECT
	category_raw,
	COUNT(*)
FROM transactions_text_demo
GROUP BY category_raw
ORDER BY COUNT(*) DESC
;

-- Business questions:

-- revenue by category
-- number of unique customers
-- average transaction value

-- NULL check
SELECT
	COUNT(*) AS count_of_rows,
	COUNT(DISTINCT category_raw) AS categories
FROM transactions_text_demo
GROUP BY category_raw
HAVING category_raw IS NULL
;
-- NULLs absent

-- profiling (inspection)
SELECT
	raw_phone,
	category_raw,
	LENGTH(raw_phone) AS raw_phone_length,
	LENGTH(category_raw) AS category_raw_length
FROM transactions_text_demo
GROUP BY
	raw_phone,
	category_raw
;

-- Clear raw_phone and category_raw. These are the essential cleaning steps.
-- Calculate revenue by transaction
SELECT
	transaction_id,
	raw_phone,
	category_raw,
	TRIM(
		RIGHT(
			regexp_replace(raw_phone, '[^0-9]', '', 'g'), 8
		) 
	) AS standardized_phone,

	TRIM(
		REGEXP_REPLACE(category_raw, '\([^()]*\)', '', 'g') 
	)AS standardized_category,

	quantity * price AS revenue

FROM transactions_text_demo
GROUP BY 
	transaction_id,
	raw_phone,
	category_raw,
	quantity * price
ORDER BY revenue DESC
;

-- KPI comparison

-- Revenue by raw category
-- shows three summary prices for three variants of Accessory 
-- and two summary prices for two variants of Electronics 
SELECT
	category_raw,
	SUM(quantity * price) AS revenue_by_raw_category

FROM transactions_text_demo
GROUP BY 
	category_raw
ORDER BY revenue_by_raw_category DESC
;

-- Revenue by clean category
-- shows one row for the revenue for the Accessory 
-- and one row for the revenue for the Electronics 
SELECT
	TRIM(
		REGEXP_REPLACE(category_raw, '\([^()]*\)', '', 'g') 
	)AS standardized_category,

	SUM(quantity * price) AS revenue_by_category

FROM transactions_text_demo
GROUP BY 
	TRIM(
		REGEXP_REPLACE(category_raw, '\([^()]*\)', '', 'g') 
	)
ORDER BY revenue_by_category DESC
;

-- Unique customers  by raw_phone
-- shows 6 different lines, though there are semantically alike phone numbers there.
SELECT
	raw_phone,
	COUNT(DISTINCT customer_id)	AS unique_customer
FROM transactions_text_demo
GROUP BY 
raw_phone
;

-- Unique customers by clean_phone
-- shows 2 different lines for really different numbers
SELECT
	TRIM(
		RIGHT(
			regexp_replace(raw_phone, '[^0-9]', '', 'g'), 8
		) 
	) AS standardized_phone,
	COUNT(DISTINCT customer_id)	AS unique_customer
FROM transactions_text_demo
GROUP BY 
	TRIM(
		RIGHT(
			regexp_replace(raw_phone, '[^0-9]', '', 'g'), 8
		) 
	)
;

-- I made an effort to avoid making any assumptions. I tried to find out the data problems 
-- by inspection and measurement.

-- Any data aggregation should not be done before inspection, measurement, and cleaning.

-- Violation of these rules can lead to wrong estimation of the categories' count, wrong result 
-- of revenue by category, and a wrong assessment of the customers' count. 
