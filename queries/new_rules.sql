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