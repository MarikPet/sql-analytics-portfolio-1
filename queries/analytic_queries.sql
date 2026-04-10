-- 1. Sales by Store per Day
SELECT 
	tr.store_id, 
	date, 
	SUM(quantity*unit_price) AS revenue_by_store_per_day
FROM analytics.transactions tr
GROUP BY tr.store_id, date
;

-- 2. Sales by Category per Store
SELECT 
	c.category, 
	t.store_id, 
	location_name,
	SUM(t.quantity*t.unit_price) AS revenue_per_category
FROM analytics.transactions t
JOIN analytics.stores s ON t.store_id = s.store_id
JOIN analytics.store_locations sl ON sl.location_id = s.location_id
JOIN analytics.products_variants pv ON t.product_variant_id = pv.product_variant_id
JOIN analytics.products p ON pv.product_id = p.product_id
JOIN analytics.categories c ON p.category_id = c.category_id
GROUP BY t.store_id, c.category, location_name 
;


-- 3. Category Trends Over Time
SELECT 
	c.category, 
	t.date, 
	SUM(t.quantity*t.unit_price) AS revenue_by_category_and_date
FROM analytics.transactions t
JOIN analytics.products_variants pv ON t.product_variant_id = pv.product_variant_id
JOIN analytics.products p ON pv.product_id = p.product_id
JOIN analytics.categories c ON p.category_id = c.category_id
GROUP BY c.category, t.date
;


-- 4. Store Location + Date        
EXPLAIN ANALYZE
SELECT 
	sl.location_name, 
	t.date, 
	SUM(t.quantity * t.unit_price) AS total_revenue
FROM analytics.transactions t
JOIN analytics.stores s ON t.store_id = s.store_id
JOIN analytics.store_locations sl ON s.location_id = sl.location_id
-- WHERE t.date BETWEEN '2026-01-01' AND '2026-01-31'
WHERE t.date BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY sl.location_name, t.date
ORDER BY sl.location_name
;

SELECT 
	t.date, 
	SUM(t.quantity * t.unit_price) AS total_revenue
FROM analytics.transactions t
JOIN analytics.stores s ON t.store_id = s.store_id
JOIN analytics.store_locations sl ON s.location_id = sl.location_id
-- WHERE t.date BETWEEN '2026-01-01' AND '2026-01-31'
-- WHERE t.date BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY t.date
-- ORDER BY sl.location_name
;

-- Without index: Sequential scan + spatial join.

-- With idx_transactions_store_date + GIST index on geom: PostgreSQL uses both indexes to filter by date and spatial boundaries efficiently.


-- 5. Product Variant Trends    
SELECT
    t.date,
    pv.product_variant,
    SUM(t.quantity) AS total_units_sold,
    SUM(t.quantity * t.unit_price) AS total_revenue_per_product
FROM analytics.transactions t
JOIN analytics.products_variants pv ON t.product_variant_id = pv.product_variant_id
GROUP BY t.date, pv.product_variant 
ORDER BY t.date, pv.product_variant;

SELECT
    pv.product_variant,
    SUM(t.quantity) AS total_units_sold,
    SUM(t.quantity * t.unit_price) AS total_revenue_per_product
FROM analytics.transactions t
JOIN analytics.products_variants pv ON t.product_variant_id = pv.product_variant_id
GROUP BY  pv.product_variant 
ORDER BY  pv.product_variant;


-- 6. Store + Product Variant    
EXPLAIN ANALYZE
SELECT 
	t.store_id, 
	pv.product_variant, 
	SUM(t.quantity) AS units_sold
FROM analytics.transactions t
JOIN analytics.products_variants pv ON t.product_variant_id = pv.product_variant_id
GROUP BY t.store_id, pv.product_variant
ORDER BY units_sold DESC;


-- ------------- ------------ ------- EXPLORE-ner anel nkarel presentaciayi hamar  --------- ------------ ----------- ------------- --------------

SELECT 
*
FROM analytics.stores;

SELECT 
	*
FROM analytics._stg_store_location_boundaries;

SELECT 
	*
FROM analytics.store_locations;

SELECT 
	*
FROM analytics.stores;

SELECT 
	*
FROM analytics.categories;

SELECT 
	*
FROM analytics.products;

SELECT 
	*
FROM analytics.products_variants
;

SELECT
	*
FROM analytics.transactions
LIMIT 10;
