DESCRIBE customers;

SELECT COUNT(*) AS total_rows
FROM customers;

-- check for missing data

SELECT
    SUM(customer_id IS NULL OR TRIM(customer_id) = '') AS missing_id,
    SUM(customer_name IS NULL OR TRIM(customer_name) = '') AS missing_name,
    SUM(gender IS NULL OR TRIM(gender) = '') AS missing_gender,
    SUM(city IS NULL OR TRIM(city) = '') AS missing_city,
    SUM(age IS NULL OR TRIM(age) = '') AS missing_age,
    SUM(join_date IS NULL OR TRIM(join_date) = '') AS missing_join_date
FROM customers;

-- check city 

SELECT
    city COLLATE utf8mb4_bin,
    COUNT(*) AS total
FROM customers
GROUP BY city COLLATE utf8mb4_bin;

-- check gender

SELECT
    gender COLLATE utf8mb4_bin,
    COUNT(*) AS total
FROM customers
GROUP BY gender COLLATE utf8mb4_bin;

-- check data to transform type

SELECT *
FROM customers
WHERE customer_id NOT REGEXP '^[0-9]+$'
   OR age NOT REGEXP '^[0-9]+$';

SELECT *
FROM customers
WHERE STR_TO_DATE(join_date, '%Y-%m-%d') IS NULL;

SELECT
    customer_id,
    COUNT(*) AS total
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- create clean coustomer 

CREATE TABLE customers_clean AS
SELECT
    CAST(customer_id AS UNSIGNED) AS customer_id,
    customer_name,
    gender,
    city,
    CAST(age AS UNSIGNED) AS age,
    STR_TO_DATE(join_date, '%Y-%m-%d') AS join_date
FROM customers;

ALTER TABLE customers_clean
MODIFY COLUMN customer_id INT NOT NULL,
ADD PRIMARY KEY (customer_id);

ALTER TABLE customers_clean
MODIFY COLUMN age INT;

DESCRIBE customers_clean;

-- check unreal age

SELECT 
	min(age) as youngest_age,
    max(age) as oldest_age,
    round(avg(age),2) as avg_age
FROM customers_clean;

SELECT *
FROM customers_clean
WHERE age < 0 OR age > 100;

-- check if name is clean 
SELECT *
FROM customers_clean
WHERE customer_name IS NULL
   OR TRIM(customer_name) = '';

SELECT discount_pct
FROM sales_clean;

