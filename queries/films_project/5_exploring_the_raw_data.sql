SELECT 
	COUNT(*)					   -- 80115			
FROM analytics._stg_rockbuster

SELECT 
  COUNT(DISTINCT customer_email)   -- 599
FROM analytics._stg_rockbuster;

SELECT 
COUNT(DISTINCT title)            -- 955
FROM analytics._stg_rockbuster;

SELECT 
  COUNT(DISTINCT actor_first_name || actor_last_name) --199
FROM analytics._stg_rockbuster;