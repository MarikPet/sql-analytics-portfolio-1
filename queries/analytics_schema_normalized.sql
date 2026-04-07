-- PostGis extension for GEOMETRY
DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis;
SELECT PostGIS_Version();

-- Change columns' types from numeric to INT to save the space
ALTER TABLE analytics.coffee_shop_raw
ALTER COLUMN store_id TYPE INT,
ALTER COLUMN product_id TYPE INT;
    

--     Creating Store Locations (Geographic hierarchy)  and Stores tables
-----------------------------------------------------------------------------------------

-- Tables for stores' locations

-- Spatial table (geometry type in EPSG:4326)
DROP TABLE IF EXISTS analytics.store_locations CASCADE;

CREATE TABLE analytics.store_locations (
    location_id INT PRIMARY KEY,
	location_name VARCHAR(100) NOT NULL,
    geom GEOMETRY(Polygon, 4326)
);

-- Staging table for raw WKT imports
DROP TABLE IF EXISTS analytics._stg_store_location_boundaries CASCADE;

CREATE TABLE IF NOT EXISTS analytics._stg_store_location_boundaries (
   	location_id INT,
	location_name VARCHAR(100) NOT NULL,
    wkt TEXT
);

-- Store table
DROP TABLE IF EXISTS analytics.stores CASCADE;

CREATE TABLE analytics.stores (
	store_id INT PRIMARY KEY,
	location_id INT REFERENCES analytics.store_locations(location_id)
);

SELECT 
*
FROM analytics.stores;

--     Populating Store Locations (Geographical hierarchy)  and Stores tables
-----------------------------------------------------------------------------------------
TRUNCATE TABLE analytics._stg_store_location_boundaries;

COPY analytics._stg_store_location_boundaries
FROM '/docker-entrypoint-initdb.d/data/analytics_schema/store_location_boundaries.csv'
CSV HEADER;

-- Convert WKT to geometry and populate spatial table
INSERT INTO analytics.store_locations (location_id, location_name, geom)
SELECT
  location_id,
  location_name,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_store_location_boundaries;


INSERT INTO analytics.stores (store_id, location_id)
SELECT
	DISTINCT
	store_id,
  	location_id
FROM analytics.coffee_shop_raw raw
JOIN analytics.store_locations sl ON raw.store_location = sl.location_name;





SELECT 
	*
FROM analytics._stg_store_location_boundaries;

SELECT 
	*
FROM analytics.store_locations;

SELECT 
	*
FROM analytics.stores;

--     Creating Category table
-----------------------------------------------------------------------------------------
DROP TABLE IF EXISTS analytics.categories CASCADE;

CREATE TABLE analytics.categories (
	category_id SERIAL PRIMARY KEY,
	category VARCHAR(50)
);

INSERT INTO analytics.categories (category)
SELECT DISTINCT
	category
FROM analytics.coffee_shop_raw raw;

SELECT 
	*
FROM analytics.categories;

-- Creating Products table
---------------------------------------------

DROP TABLE IF EXISTS analytics.products CASCADE;

CREATE TABLE analytics.products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100),
	category_id INT REFERENCES analytics.categories(category_id)
);

INSERT INTO analytics.products (product_name, category_id)
SELECT DISTINCT
	product_name,
	category_id
FROM analytics.coffee_shop_raw raw
LEFT JOIN analytics.categories c ON raw.category = c.category;

SELECT 
	*
FROM analytics.products;

-- Creating product Variants table
----------------------------------------------
DROP TABLE IF EXISTS analytics.products_variants CASCADE;

CREATE TABLE analytics.products_variants (
	product_variant_id INT PRIMARY KEY,
	product_variant VARCHAR(100),
	product_id INT REFERENCES analytics.products(product_id)
);

-- TRUNCATE TABLE analytics.products_variants;
 
INSERT INTO analytics.products_variants (product_variant_id, product_variant, product_id)
SELECT DISTINCT
	raw.product_id,
 	product_detail,
	p.product_id
FROM analytics.coffee_shop_raw raw
LEFT JOIN analytics.products p ON raw.product_name = p.product_name
;

SELECT 
	*
FROM analytics.products_variants
;

-- Creating Transactions table
------------------------------------------------------------
DROP TABLE IF EXISTS analytics.transactions CASCADE;

CREATE TABLE analytics.transactions (
	transaction_id VARCHAR(20) PRIMARY KEY,
	date DATE,
	time TIME,
    quantity INT,
	unit_price NUMERIC(10,2),
	store_id INT REFERENCES analytics.stores(store_id),
	category_id INT REFERENCES analytics.categories(category_id),
	product_id INT REFERENCES analytics.products(product_id),
	product_variant_id INT REFERENCES analytics.products_variants(product_variant_id)
);

INSERT INTO analytics.transactions (transaction_id, date, time, quantity, unit_price, store_id, category_id, product_id, product_variant_id)
SELECT DISTINCT
	raw.transaction_id,
	date,
	time,
	quantity,
	unit_price,
	s.store_id,
	c.category_id,
	p.product_id,
	pv.product_variant_id
FROM analytics.coffee_shop_raw raw 
JOIN analytics.stores s             ON raw.store_id = s.store_id
JOIN analytics.categories c 		ON raw.category = c.category
JOIN analytics.products p 			ON raw.product_name = p.product_name
JOIN analytics.products_variants pv ON raw.product_detail = pv.product_variant
;

SELECT
	*
FROM analytics.transactions
LIMIT 10;
