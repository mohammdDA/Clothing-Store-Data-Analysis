-- clean sales 

CREATE TABLE sales_clean LIKE sales;

INSERT INTO sales_clean
SELECT *
FROM sales;

SELECT
    (SELECT COUNT(*) FROM sales) AS original_rows,
    (SELECT COUNT(*) FROM sales_clean) AS clean_rows;

-- delete dublicate rows 

SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT order_id
    FROM sales_clean
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicates;

WITH duplicate_cte AS
(
    SELECT *,
        ROW_NUMBER() OVER(
            PARTITION BY order_id
            ORDER BY order_id
        ) AS row_num
    FROM sales_clean
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

ALTER TABLE sales_clean
ADD COLUMN row_id INT AUTO_INCREMENT PRIMARY KEY;

DELETE s1
from sales_clean s1
JOIN sales_clean s2
	on s1.order_id=s2.order_id
    AND s1.row_id > s2.row_id ;
    
SELECT COUNT(*) AS total_rows
FROM sales_clean;

SELECT trim(payment_method)
FROM sales_clean;

-- trim paymeny method

UPDATE sales_clean 
SET payment_method = trim(payment_method)
WHERE payment_method <> TRIM(payment_method);

SELECT payment_method
FROM sales_clean
WHERE payment_method <> TRIM(payment_method);

-- lower case payment method
UPDATE sales_clean
SET payment_method = LOWER(payment_method);

SELECT payment_method COLLATE utf8mb4_bin AS payment_method, COUNT(*)
FROM sales_clean
GROUP BY payment_method COLLATE utf8mb4_bin;

-- sales chanel 

UPDATE sales_clean
SET sales_channel = LOWER(TRIM(sales_channel));

SELECT
    sales_channel COLLATE utf8mb4_bin AS sales_channel,
    COUNT(*) AS total_count
FROM sales_clean
GROUP BY sales_channel COLLATE utf8mb4_bin;

-- empty customer id 

SELECT count(*)
FROM sales_clean 
WHERE customer_id ="";

UPDATE sales_clean
set customer_id = null
WHERE customer_id= "";

-- empty discoun to 0

SELECT count(*)
FROM sales_clean
where discount_pct ="";

UPDATE sales_clean
set discount_pct = 0 
WHERE discount_pct = "";

-- order date

UPDATE sales_clean
SET order_date = CASE
    WHEN order_date LIKE '__/__/____'
        THEN DATE_FORMAT(
            STR_TO_DATE(order_date, '%d/%m/%Y'),
            '%Y-%m-%d'
        )
    ELSE order_date
END;

ALTER TABLE sales_clean
MODIFY COLUMN order_date DATE;

SELECT order_date
FROM sales_clean ;

ALTER TABLE sales_clean
ADD COLUMN is_suspicious TINYINT DEFAULT 0;

SELECT
    quantity,
    COUNT(*) AS total
FROM sales_clean
GROUP BY quantity
ORDER BY quantity;

UPDATE sales_clean
SET is_suspicious = 1
WHERE quantity <= 0 or quantity > 80;

SELECT
    quantity,
    is_suspicious,
    COUNT(*) AS total
FROM sales_clean
GROUP BY quantity, is_suspicious
ORDER BY quantity;

SELECT *
FROM sales_clean
WHERE
    order_id NOT REGEXP '^[0-9]+$'
    OR customer_id NOT REGEXP '^[0-9]+$'
    OR product_id NOT REGEXP '^[0-9]+$'
    OR quantity NOT REGEXP '^-?[0-9]+$';
    
ALTER TABLE sales_clean
MODIFY order_id INT,
MODIFY customer_id INT,
MODIFY product_id INT,
MODIFY quantity INT,
MODIFY discount_pct DECIMAL(5,2);

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM sales_clean
GROUP BY order_id
HAVING COUNT(*) > 1;

ALTER TABLE sales_clean
ADD CONSTRAINT uq_order_id UNIQUE (order_id);

ALTER TABLE sales_clean 
DROP COLUMN row_id;

SELECT COUNT(*), COUNT(DISTINCT order_id), COUNT(order_date),
       SUM(customer_id IS NULL), SUM(is_suspicious),
       MIN(order_date), MAX(order_date), MAX(quantity)
FROM sales_clean;

DESCRIBE sales_clean;

