--What is the general statistical summary of movie rental conditions?
SELECT
    COUNT(DISTINCT r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_revenue,
    AVG(p.amount) AS avg_payment,
    MIN(p.amount) AS min_payment,
    MAX(p.amount) AS max_payment,
    AVG(EXTRACT(EPOCH FROM (r.return_date - r.rental_date))/86400)  AS avg_rental_days
FROM analytics.rental r
JOIN analytics.payment p ON p.rental_id = r.rental_id;

-- How many customers are there per country?
SELECT
    co.country_name,
    COUNT(c.customer_id) AS total_customers
FROM analytics.customer c
JOIN analytics.address a   ON a.address_id = c.address_id
JOIN analytics.city ci     ON ci.city_id = a.city_id
JOIN analytics.country co  ON co.country_id = ci.country_id
GROUP BY co.country_name
ORDER BY total_customers DESC;

-- How much revenue does each country generate?
SELECT
    co.country_name,
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM analytics.payment p
JOIN analytics.rental r     ON r.rental_id = p.rental_id
JOIN analytics.customer c   ON c.customer_id = r.customer_id
JOIN analytics.address a    ON a.address_id = c.address_id
JOIN analytics.city ci      ON ci.city_id = a.city_id
JOIN analytics.country co   ON co.country_id = ci.country_id
GROUP BY co.country_name
ORDER BY total_revenue DESC;

-- What is the average revenue per customer by country?
SELECT
    co.country_name,
    SUM(p.amount) / COUNT(DISTINCT c.customer_id) AS avg_revenue_per_customer
FROM analytics.payment p
JOIN analytics.rental r     ON r.rental_id = p.rental_id
JOIN analytics.customer c   ON c.customer_id = r.customer_id
JOIN analytics.address a    ON a.address_id = c.address_id
JOIN analytics.city ci      ON ci.city_id = a.city_id
JOIN analytics.country co   ON co.country_id = ci.country_id
GROUP BY co.country_name
ORDER BY avg_revenue_per_customer DESC;

-- How much is the revenue per film?
SELECT
	f.title,
	SUM(p.amount) AS income
FROM analytics.rental r
JOIN analytics.payment p  ON r.rental_id = p.rental_id
JOIN analytics.film f     ON r.film_id = f.film_id
GROUP BY f.title
ORDER BY income DESC
;

-- Which categories in demand?
SELECT
    c.category_name,
	SUM(p.amount) AS income
FROM analytics.rental r
JOIN analytics.payment p        ON r.rental_id = p.rental_id
JOIN analytics.film f           ON r.film_id = f.film_id
JOIN analytics.film_category fc ON f.film_id = fc.film_id
JOIN analytics.category c       ON c.category_id = fc.category_id
GROUP BY c.category_name
ORDER BY income DESC
;

-- Which categories in demand per country?
SELECT
	co.country_name,
    c.category_name,
	SUM(p.amount) AS income
FROM analytics.rental r
JOIN analytics.payment p        ON r.rental_id = p.rental_id
JOIN analytics.film f           ON r.film_id = f.film_id
JOIN analytics.film_category fc ON f.film_id = fc.film_id
JOIN analytics.category c       ON c.category_id = fc.category_id
JOIN analytics.customer cu      ON cu.customer_id = r.customer_id
JOIN analytics.address a    	ON a.address_id = cu.address_id
JOIN analytics.city ci      	ON ci.city_id = a.city_id
JOIN analytics.country co   	ON co.country_id = ci.country_id
GROUP BY co.country_name, c.category_name
ORDER BY co.country_name, income DESC
;

-- How much is revenue by store?
