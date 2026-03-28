-- NYC-based coffee shop transaction data


-- THE GOAL

-- What is the general statistic schema of coffee shop condition?
-- What is the geographical distribution of coffee shops?
-- Which categories/products are the top best sellers?
-- Which days of week bring the most revenue?
-- Which time of the day is the pick-time, which products are best sellers at that time?
-- Which area brings the most revenue?
-- The operational load of each shop (quantity sold).
-- Distances between the shops. Is there need to establish a shop somewhere else?


-- -- Exploring coffee_shop_raw table

-- The raw data
SELECT 
	*
FROM analytics.coffee_shop_raw
LIMIT 160
;


SELECT 
	COUNT (DISTINCT store_id) AS distinct_stores,
	COUNT (DISTINCT category) AS distinct_categories,
	COUNT (DISTINCT product_id) AS distinct_product_ids,
	COUNT (DISTINCT product_name) AS distinct_product_names,
	COUNT (DISTINCT product_detail) AS distinct_product_details
FROM analytics.coffee_shop_raw
;

-- We have: 
-- 	transaction information
-- 	date-time information
-- 	store data 
--  geographic data
--  product data 
--  product metadata

-- Columns: 
-- transaction_id, date, time, quantity, store_id, store_location, product_id, unit_price, category, product_name, product_detail
    

-- One row represents:
-- 	one transaction
-- 	one store
-- 	one product with metadata

--- Having one store and one product in one row results in repetition of stores, products, their categories, and metadata 
--- in the corresponding columns.

-- The coffee_shop_raw table isn't normalized

-- store_id uniquely identifies a store
-- store_location is store attribute,
-- So, store attributes should be separated 
-- Also, I intent to add GEOMETRY data for store_location in a separate table (related with stores table by store_id) 

-- One category tied to many transactions, and has many products, 
-- So, it should be separated from transactions and products

-- product_id uniquely identifies a product
-- product_detail tied to product_id, product_detail doesn't determine product_name, so it is transitive dependency
-- unit_price uniquely tied with product_id and product_detail
-- one product_name contains many product_detail, so these two should be separated

-- transaction date, time, and quantity are transactions properties. 
-- these should remain in transactions table
