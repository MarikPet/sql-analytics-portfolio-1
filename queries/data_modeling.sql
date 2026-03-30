-- NYC-based coffee shop transaction data
-- Fully denormalized table
-- NO primary keys
-- NO foreign keys
-- For every product_name multiple product_details


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

-- product_id uniquely identifies a product_detail
-- unit_price uniquely tied with product_id and product_detail
-- so these should be in a separate table

-- product_name doesn't determine product_detail, so it is transitive dependency
-- one product_name tied to many product_detail, so these two should be separated 

-- transaction date, time, and quantity are transactions properties. 
-- these should remain in transactions table


-- Total rows       
SELECT 
	COUNT(*)      --149116              
FROM analytics.coffee_shop_raw
;

SELECT 
	COUNT(transaction_id),         --149116
	COUNT(DISTINCT transaction_id) --149116
FROM analytics.coffee_shop_raw
;
-- So there aren't NULL transaction_id-s,
-- and there aren't duplicate rows.


SELECT 
	COUNT (DISTINCT store_id) AS distinct_stores,                   -- 3
	COUNT (DISTINCT store_location) AS distinct_stores,             -- 3
	COUNT (DISTINCT category) AS distinct_categories,               -- 9
	COUNT (DISTINCT product_id) AS distinct_product_ids,            -- 80
	COUNT (DISTINCT product_name) AS distinct_product_names,        -- 29
	COUNT (DISTINCT product_detail) AS distinct_product_details     -- 80
FROM analytics.coffee_shop_raw
;
 -- The difference between the total row count and store, category, and product data shows that those are repeated multiple times,
 -- and that the table mixes multiple entity types 


-- The entities:
 -- Transactions
 -- Stores
 -- Store Locations
 -- Categories
 -- Products
 -- Product Flavours