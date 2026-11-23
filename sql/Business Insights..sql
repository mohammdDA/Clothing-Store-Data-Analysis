-- creat sales enriched view

CREATE or REPLACE VIEW sales_enriched  as 
SELECT 
	
    s.order_id,
    s.order_date,
    s.customer_id,
    s.product_id,
    s.quantity,
    s.discount_pct,
    s.payment_method,
    s.sales_channel,
    s.is_suspicious,

	p.product_name,
    p.category,
    p.cost_price,
    p.sell_price,

	c.city,
    c.gender,
    c.age,

	-- Revenue after discount
    (s.quantity * p.sell_price)
        * (1 - s.discount_pct / 100) AS revenue,

    -- Profit after discount
    (
        (s.quantity * p.sell_price)
        * (1 - s.discount_pct / 100)
    ) - (s.quantity * p.cost_price) AS profit
    
FROM sales_clean s

INNER JOIN products_clean p
    ON s.product_id = p.product_id

LEFT JOIN customers_clean c
    ON s.customer_id = c.customer_id
WHERE is_suspicious = 0;

-- check the view 
SELECT COUNT(*) FROM sales_enriched;  

-- Revenue Validation 

SELECT
    ROUND(SUM(revenue), 2) AS net_revenue,
    ROUND(SUM(quantity * sell_price), 2) AS gross_revenue,

    ROUND(
        SUM(revenue) / SUM(quantity * sell_price) * 100,
        2
    ) AS revenue_percentage,

    ROUND(
        (1 - SUM(revenue) / SUM(quantity * sell_price)) * 100,
        2
    ) AS effective_discount_percentage

FROM sales_enriched
WHERE is_suspicious = 0;

-- mothely revenue

SELECT 
	year(order_date) as sales_year,
    month(order_date) as sales_monthe,
    round(sum(revenue),2) as total_revenue,
    round(sum(profit),2)as total_profit
FROM sales_enriched
GROUP BY year(order_date), month(order_date)
order BY year(order_date), month(order_date);

-- best 5 product profit 

SELECT product_id,product_name,category,
	sum(quantity) as total_quantity,
    round(sum(revenue),2 ) as total_revenue,
    round(sum(profit),2) as total_profit
FROM sales_enriched
GROUP BY product_id,product_name,category
ORDER BY round(sum(profit),2) DESC 
LIMIT 5 ;

-- top 5 product selling

SELECT product_id,product_name,
	sum(quantity) as total_quantity,
	round(sum(profit),2) as total_profit
FROM sales_enriched 
GROUP BY product_id,product_name 
ORDER BY total_quantity DESC 
LIMIT 5;
	
-- category per semester

SELECT
    CASE
        WHEN MONTH(order_date) IN (11, 12, 1) THEN 'Winter'
        WHEN MONTH(order_date) IN (2, 3, 4) THEN 'Spring'
        WHEN MONTH(order_date) IN (5, 6, 7) THEN 'Summer'
        WHEN MONTH(order_date) IN (8, 9, 10) THEN 'Autumn'
    END AS season,

    category,

    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit

FROM sales_enriched
WHERE is_suspicious = 0

GROUP BY season, category

ORDER BY
    FIELD(season, 'Winter', 'Spring', 'Summer', 'Autumn'),
    total_revenue DESC;
    
-- best sell chanel

SELECT
    city,
    sales_channel,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(revenue) / COUNT(DISTINCT order_id),
        2
    ) AS avg_order_value

FROM sales_enriched

WHERE is_suspicious = 0

GROUP BY
    city,
    sales_channel

ORDER BY
    total_profit DESC;

-- discount good or bad for us 

SELECT
    discount_pct,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(AVG(quantity), 2) AS avg_quantity,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(revenue), 0) * 100,
        2
    ) AS profit_margin_pct

FROM sales_enriched

WHERE is_suspicious = 0

GROUP BY discount_pct

ORDER BY discount_pct ;

-- best 10 coustomers 
 
SELECT customer_id,
	count(DISTINCT order_id) as total_orders ,
    round(sum(revenue),2) as total_revenue ,
    round(sum(profit),2) as total_profit
FROM sales_enriched
WHERE customer_id is not null 
GROUP BY customer_id
ORDER bY total_revenue DESC 
LIMIT 10;

-- revenue_share per top 10 customer
WITH customer_revenue AS
(
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM sales_enriched
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        total_revenue / SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_share_pct

FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 10;

-- Revenue by City
SELECT
    city,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(revenue) / COUNT(DISTINCT customer_id),
        2
    ) AS revenue_per_customer

FROM sales_enriched

WHERE customer_id IS NOT NULL
  AND is_suspicious = 0

GROUP BY city
ORDER BY total_revenue DESC;

-- sales discount per monthe 	
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,

    ROUND(SUM(quantity * sell_price), 2) AS gross_revenue,

    ROUND(
        SUM(quantity * sell_price * discount_pct / 100),
        2
    ) AS discount_amount,

    ROUND(SUM(revenue), 2) AS net_revenue,

    ROUND(
        SUM(quantity * sell_price * discount_pct / 100)
        / NULLIF(SUM(quantity * sell_price), 0) * 100,
        2
    ) AS effective_discount_pct,

    ROUND(SUM(profit), 2) AS total_profit

FROM sales_enriched

GROUP BY sales_month
ORDER BY sales_month;