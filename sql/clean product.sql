-- create clean products 

CREATE TABLE products_clean LIKE products;
INSERT INTO products_clean 
SELECT * FROM products;

-- change type 

ALTER TABLE products_clean
MODIFY cost_price DECIMAL (10,2),
MODIFY sell_price DECIMAL (10,2);

DESCRIBE products_clean;

-- set primary key 

ALTER TABLE products_clean
MODIFY COLUMN product_id INT NOT NULL,
ADD PRIMARY KEY (product_id);


DESCRIBE products_clean;

-- check for unreal prices

SELECT *
FROM products_clean
WHERE cost_price IS NULL
   OR sell_price IS NULL
   OR cost_price <= 0
   OR sell_price <= 0
   OR sell_price < cost_price;

SELECT *
FROM products_clean
WHERE product_name IS NULL
   OR TRIM(product_name) = ''
   OR category IS NULL
   OR TRIM(category) = '';
   

   
   
   
   
   
   
   


