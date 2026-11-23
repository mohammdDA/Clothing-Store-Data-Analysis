DESCRIBE products;

-- check for dublicates products
SELECT count(*) as total_rows , 
	count(DISTINCT product_id) as unique_products,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_ids
from products;

-- check for unrealastic rows
SELECT * 
FROM products 
WHERE product_id is null 
	or cost_price is null
    or sell_price is null 
    or cost_price < 0 
    or sell_price < 0 ;

-- check for wrong sell data

SELECT *
FROM products 
WHERE sell_price < cost_price ;

