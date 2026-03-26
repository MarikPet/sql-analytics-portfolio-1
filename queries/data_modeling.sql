-- NYC-based coffee shop transaction data
SELECT 
	*
FROM analytics.coffee_shop_raw
LIMIT 160;

-- -- Exploring coffee_shop_raw table

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
