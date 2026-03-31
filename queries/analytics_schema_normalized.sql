-- PostGis extention for GEOMETRY
DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis;
SELECT PostGIS_Version();

-- Change colomns' types from numeric to INT to save the sppace
ALTER TABLE analytics.coffee_shop_raw
ALTER COLUMN store_id TYPE INT,
ALTER COLUMN product_id TYPE INT;
    

--     Creating Store Locations (Geographic hierarchy)  and Stores tables
-----------------------------------------------------------------------------------------

-- Table for stores' locations
DROP TABLE IF EXISTS analytics.store_locations CASCADE;

CREATE TABLE analytics.store_locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL
);

-- Spatial table (geometry type in EPSG:4326)
DROP TABLE IF EXISTS analytics.store_location_boundaries CASCADE;

CREATE TABLE analytics.store_location_boundaries (
    location_id INT,
    geom GEOMETRY(Polygon, 4326)
);

-- Staging table for raw WKT imports
DROP TABLE IF EXISTS analytics._stg_store_location_boundaries CASCADE;

CREATE TABLE IF NOT EXISTS analytics._stg_store_location_boundaries (
   	location_id INT,
    wkt TEXT
);

-- Store table
DROP TABLE IF EXISTS analytics.store CASCADE;

CREATE TABLE analytics.stores (
	store_id INT PRIMARY KEY,
	location_id INT REFERENCES analytics.store_locations(location_id)
);

--     Populating Store Locations (Greographical hierarchy)  and Stores tables
-----------------------------------------------------------------------------------------

COPY analytics._stg_store_location_boundaries
FROM '/docker-entrypoint-initdb.d/data/analytics_schema/store_location_boundaries.csv'
CSV HEADER;

-- Convert WKT to geometry and populate spatial table
INSERT INTO analytics.store_location_boundaries (location_id, geom)
SELECT
  location_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_store_location_boundaries;


-- INSERT INTO analytics._stg_store_location_boundaries (name, geom) VALUES 
-- 1 ('Hell''s Kitchen', ST_GeomFromText('POLYGON((-73.993 40.771, -73.984 40.765, -74.001 40.752, -74.011 40.758, -73.993 40.771))', 4326))
-- 2 ('Astoria', ST_GeomFromText('POLYGON((-73.924 40.776, -73.901 40.776, -73.905 40.758, -73.939 40.752, -73.924 40.776))', 4326))
-- 3 ('Lower Manhattan', ST_GeomFromText('POLYGON((-74.010 40.700, -73.970 40.710, -73.980 40.740, -74.020 40.730, -74.010 40.700))', 4326));

SELECT 
	*
FROM analytics._stg_store_location_boundaries;
