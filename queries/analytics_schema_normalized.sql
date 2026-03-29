ALTER TABLE analytics.coffee_shop_raw
ALTER COLUMN store_id TYPE INT;

-- Store table
CREATE TABLE analytics.stores (
	store_id INT PRIMARY KEY,
	location_id INT REFERENCES analytics.store_locations(location_id)
);

-- Temp table for stores' locations
CREATE TABLE analytics.store_locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL
);

CREATE TABLE analytics.store_location_boundaries (
    location_id INT PRIMARY KEY REFERENCES analytics.store_locations(location_id),
    geom GEOMETRY(Polygon, 4326)
);

CREATE TABLE IF NOT EXISTS analytics._stg_store_location_boundaries (
    location_id INT,
    wkt TEXT
);

-- INSERT INTO analytics._stg_store_location_boundaries (name, geom) VALUES 
-- 1 ('Hell''s Kitchen', ST_GeomFromText('POLYGON((-73.993 40.771, -73.984 40.765, -74.001 40.752, -74.011 40.758, -73.993 40.771))', 4326))
-- 2 ('Astoria', ST_GeomFromText('POLYGON((-73.924 40.776, -73.901 40.776, -73.905 40.758, -73.939 40.752, -73.924 40.776))', 4326))
-- 3 ('Lower Manhattan', ST_GeomFromText('POLYGON((-74.010 40.700, -73.970 40.710, -73.980 40.740, -74.020 40.730, -74.010 40.700))', 4326));

SELECT 
	*
FROM store_locations;