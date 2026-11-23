USE clothe_store;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customers;

-- sales clean 
SELECT order_id , count(*) as n
FROM sales
GROUP BY 1
HAVING count(*)>1;

SELECT *
FROM sales
WHERE order_id in (
	SELECT order_id 
    FROM sales
    GROUP BY order_id
    HAVING count(*)>1
)
order BY order_id;

-- 2.(Missing Values)

SELECT 
	sum(case
		WHEN product_id = "" or product_id is null
        then 1 ELSE 0 
        end
    ) as missing_costomer_id , 
    sum(case
		WHEN discount_pct = "" or discount_pct is NULL
        THEN 1 ELSE 0
        end
    ) as missing_discount_pct
FROM sales;

SELECT *
FROM sales
WHERE discount_pct in (
	SELECT order_id 
    FROM sales
    GROUP BY discount_pct
    HAVING count(*)>1
)
order BY order_id;

SELECT
    payment_method,
    COUNT(*) AS total
FROM sales
GROUP BY payment_method
ORDER BY total DESC;

SELECT
    sales_channel,
    COUNT(*) AS total
FROM sales
GROUP BY sales_channel
ORDER BY total DESC;

SELECT
    COUNT(*) AS different_date_format
FROM sales
WHERE order_date LIKE '%/%';

SELECT DISTINCT order_date
FROM sales
WHERE order_date LIKE '%/%';

SELECT
    MIN(CAST(quantity AS SIGNED)) AS min_quantity,
    MAX(CAST(quantity AS SIGNED)) AS max_quantity
FROM sales;

SELECT
    s.product_id
FROM sales s
LEFT JOIN products p
    ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    s.customer_id
FROM sales s
LEFT JOIN customers c
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;



SELECT
    COUNT(*) AS missing_products
FROM sales s
LEFT JOIN products p
    ON s.product_id = p.product_id
WHERE p.product_id IS NULL
AND s.product_id IS NOT NULL
AND s.product_id <> '';
SELECT
    COUNT(*) AS missing_customers
FROM sales s
LEFT JOIN customers c
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL
AND s.customer_id IS NOT NULL
AND s.customer_id <> '';

SELECT
    SUM(CASE WHEN product_id = '' OR product_id IS NULL
        THEN 1 ELSE 0 END) AS empty_product_id,

    SUM(CASE WHEN customer_id = '' OR customer_id IS NULL
        THEN 1 ELSE 0 END) AS empty_customer_id
FROM sales;

SELECT quantity , product_id 
FROM sales 
WHERE quantity < 0 ;

SELECT customer_id , count(*)
FROM sales 
WHERE customer_id = "";

SELECT
    discount_pct,
    COUNT(*) AS total
FROM sales
GROUP BY discount_pct
ORDER BY total DESC;
