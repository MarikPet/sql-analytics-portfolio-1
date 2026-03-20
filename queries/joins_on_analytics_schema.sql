-- Customers, products sold to them, and locations where those products were sold

-- Some customers are located outside cities.
-- There are not customers who have never placed an order.
SELECT 
	country_name,
	p.product_name,
    first_name || ' ' || last_name AS customer_name,
	-- order_id,
    CASE 
        WHEN cb.city_id IS NULL THEN 'Out of any city'
        ELSE ci.city_name 
    END AS city_located,
    CASE 
        WHEN rb.region_id IS NULL THEN 'Out of any region'
        ELSE r.region_name 
    END AS region_located,
	SUM(price * quantity) AS total_revenue
FROM analytics.customers c
JOIN analytics.customer_locations cl ON c.customer_id = cl.customer_id
LEFT JOIN analytics.city_boundaries cb ON ST_Intersects(cl.geom, cb.geom)
LEFT JOIN analytics.region_boundaries rb ON ST_Intersects(cl.geom, rb.geom)
LEFT JOIN analytics.cities ci ON cb.city_id = ci.city_id
LEFT JOIN analytics.regions r ON rb.region_id = r.region_id
LEFT JOIN analytics.orders o ON c.customer_id = o.customer_id
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON p.product_id = oi.product_id
JOIN analytics.countries co ON co.country_id = r.country_id
-- WHERE o.order_id IS NULL;
GROUP BY
	country_name,
	p.product_name,
	first_name || ' ' || last_name,
	CASE 
        WHEN cb.city_id IS NULL THEN 'Out of any city'
        ELSE ci.city_name 
    END ,
    CASE 
        WHEN rb.region_id IS NULL THEN 'Out of any region'
        ELSE r.region_name 
    END 
ORDER BY total_revenue DESC	
;

-- Joining orders to order items increases row count because 
-- there is '1-M' relationship between an order(1) and order items(many)


-- Total revenue per country
SELECT 
	country_name,
	SUM(price * quantity) AS total_revenue
FROM analytics.customers c
LEFT JOIN analytics.orders o ON c.customer_id = o.customer_id
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON p.product_id = oi.product_id
LEFT JOIN analytics.cities ci ON c.city_id = ci.city_id
LEFT JOIN analytics.regions r ON ci.region_id = r.region_id
JOIN analytics.countries co ON co.country_id = r.country_id
GROUP BY
	country_name
ORDER BY total_revenue DESC	
;


-- Customers and their cities

-- There are not customers without a city.
SELECT 
    first_name || ' ' || last_name AS customer_name,
	ci.city_id
FROM analytics.customers c
LEFT JOIN analytics.cities ci ON c.city_id = ci.city_id
WHERE ci.city_id IS NULL
;
