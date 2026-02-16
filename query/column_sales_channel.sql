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