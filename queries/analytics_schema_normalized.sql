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
