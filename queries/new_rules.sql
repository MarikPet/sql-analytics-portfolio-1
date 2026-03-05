-- Business rules


--1. Employees' emails must be unique
ALTER TABLE employees
ADD CONSTRAINT unique_employee_email UNIQUE (email);

--2. Add phone_number column to the 'employees' table 
ALTER TABLE customers
ADD COLUMN phone_number TEXT;

-- Populate column with sample data
UPDATE customers
SET phone_number = '+374 10 101010'; 

--3. Employee phone numbers must be mandatory
ALTER TABLE customers
ALTER COLUMN phone_number SET NOT NULL;

--4. Product prices must be non-negative
ALTER TABLE products
ADD CONSTRAINT chk_product_price CHECK (price >= 0);

--5. Product prices must be non-negative
ALTER TABLE sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);

-- Create indices for faster queries 
CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);
    

-- Add sales_channel column to the sales table
ALTER TABLE sales
ADD COLUMN sales_channel TEXT;

-- Add constraints to ensure sales_channel is one of the allowed values ('Online', 'Store'))
ALTER TABLE sales
ADD CONSTRAINT check_sales_channel 
CHECK (sales_channel IN ('Online', 'Store'));

-- Populate records with sample values for sales_channel (this is just an example, adjust as needed)
UPDATE sales
SET sales_channel = CASE
    WHEN order_id % 2 = 0 THEN 'Online'  -- Example logic: even order_ids are 'Online'
    ELSE 'Store'                          -- odd order_ids are 'Store'
END;  