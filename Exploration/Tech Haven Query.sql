
-- 1. What were the order counts, sales, and AOV for Macbooks sold in North America for each quarter across all years?

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,
    DATEPART(QUARTER, o.Purchase_TS) AS purchase_quarter,
    SUM(o.Quantity_Ordered) AS order_count,
    SUM(o.Price_Each * o.Quantity_Ordered) AS total_sales,
    ROUND(SUM(o.Price_Each * o.Quantity_Ordered) / SUM(o.Quantity_Ordered), 2) AS aov
FROM [Tech Haven].dbo.Tech_Haven_Orders AS o
WHERE o.Product = 'Macbook Pro Laptop'
GROUP BY YEAR(o.Purchase_TS), DATEPART(QUARTER, o.Purchase_TS)
ORDER BY purchase_year, purchase_quarter;

-- 2. How many Macbooks were ordered each month in 2020 through 2021, sorted from oldest to most recent month?

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,
    MONTH(o.Purchase_TS) AS purchase_month,
    SUM(o.Quantity_Ordered) AS total_macbooks_ordered
FROM [Tech Haven].dbo.Tech_Haven_Orders AS o
WHERE o.Product = 'Macbook Pro Laptop'
    AND YEAR(o.Purchase_TS) BETWEEN 2020 AND 2021
GROUP BY YEAR(o.Purchase_TS), MONTH(o.Purchase_TS)
ORDER BY purchase_year ASC, purchase_month ASC;

-- 3. Return the purchase month, shipping month, time to ship (in days), and product name for each order placed in 2020.

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,
    MONTH(o.Purchase_TS) AS purchase_month,
    YEAR(os.Ship_TS) AS ship_year,
    MONTH(os.Ship_TS) AS ship_month,
    DATEDIFF(DAY, o.Purchase_TS, os.Ship_TS) AS time_to_ship,
    o.Product
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os
    ON o.Order_ID = os.Order_ID
WHERE 
    YEAR(o.Purchase_TS) = 2020
ORDER BY 
    purchase_year, purchase_month;

-- 4. What is the average order value per year for products that are either phones or headphones?

SELECT 
    YEAR(Purchase_TS) AS purchase_year,
    ROUND(SUM(Price_Each * Quantity_Ordered) / COUNT(DISTINCT Order_ID), 2) AS avg_order_value
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders
WHERE 
    Product LIKE '%phone%' OR Product LIKE '%headphone%'
GROUP BY 
    YEAR(Purchase_TS)
ORDER BY 
    purchase_year;

-- 5. How many people used the mobile app vs the website as a purchase platform?

SELECT 
    Purchase_Platform,
    COUNT(DISTINCT Customer_ID) AS customer_count
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders
GROUP BY 
    Purchase_Platform
ORDER BY 
    customer_count DESC;

-- 6. What is the total number of orders per year for each product? Clean up product names when grouping and return in alphabetical order after sorting by months.

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,
    REPLACE(o.Product, ' ', '') AS cleaned_product,
    MONTH(o.Purchase_TS) AS purchase_month,
    COUNT(o.Order_ID) AS total_orders
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o
GROUP BY 
    YEAR(o.Purchase_TS),
    REPLACE(o.Product, ' ', ''),
    MONTH(o.Purchase_TS)
ORDER BY 
    purchase_year ASC,
    purchase_month ASC,
    cleaned_product ASC;

SELECT 
    geo.region,
    AVG(DATEDIFF(day, o.Purchase_TS, os.Delivery_TS)) AS avg_delivery_time
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os
    ON o.Order_ID = os.Order_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers AS c
    ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup AS geo
    ON c.State = geo.state_name
WHERE 
    (
        (YEAR(o.Purchase_TS) = 2022 AND o.Purchase_Platform = 'Website')
        OR
        (o.Purchase_Platform = 'Mobile App')
    )
GROUP BY 
    geo.region
ORDER BY 
    avg_delivery_time DESC;

--7. For products purchased in 2022 on the website or products purchased on mobile in any year, which region has the average highest time to deliver?

SELECT 
    geo.region,
    AVG(DATEDIFF(day, o.Purchase_TS, os.Delivery_TS)) AS avg_delivery_time
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os
    ON o.Order_ID = os.Order_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers AS c
    ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup AS geo
    ON c.State = geo.state_code
WHERE 
    (
        (YEAR(o.Purchase_TS) = 2022 AND o.Purchase_Platform = 'Website')
        OR
        (o.Purchase_Platform = 'Mobile')
    )
GROUP BY 
    geo.region
ORDER BY 
    avg_delivery_time DESC;


--8. What was the refund rate and refund count for each product overall?

SELECT 
    o.Product,
    COUNT(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 END) AS refund_count,
    CAST(ROUND(
        (COUNT(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 END) * 1.0 / COUNT(o.Order_ID)) * 100, 
        1
    ) AS DECIMAL(10, 1)) AS refund_rate
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os 
    ON o.Order_ID = os.Order_ID -- Join to get refund information
GROUP BY 
    o.Product
ORDER BY 
    refund_count DESC;

-- 9. Within each region, what is the most popular product?

WITH ProductPopularity AS (
    SELECT 
        geo.region, 
        o.Product, 
        COUNT(o.Order_ID) AS order_count
    FROM 
        [Tech Haven].dbo.Tech_Haven_Orders AS o
    JOIN 
        [Tech Haven].dbo.Tech_Haven_Customers AS c
        ON o.Customer_ID = c.Customer_ID
    JOIN 
        [Tech Haven].dbo.Tech_Haven_Geo_Lookup AS geo
        ON c.State = geo.state_code
    GROUP BY 
        geo.region, 
        o.Product
)
SELECT 
    pp.region, 
    pp.Product, 
    pp.order_count
FROM 
    ProductPopularity AS pp
JOIN (
    SELECT 
        region, 
        MAX(order_count) AS max_order_count
    FROM 
        ProductPopularity
    GROUP BY 
        region
) AS max_counts
    ON pp.region = max_counts.region
    AND pp.order_count = max_counts.max_order_count
ORDER BY 
    pp.region;

-- 10. What is the average total sales over the entire range of 2020-2024?

SELECT 
    c.Loyalty_Program,
    o.Product,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    SUM(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 ELSE 0 END) AS refund_count,
    ROUND(
        (SUM(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 ELSE 0 END) * 1.0) / COUNT(DISTINCT o.Order_ID), 4
    ) AS refund_rate
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers c ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status os ON o.Order_ID = os.Order_ID
WHERE 
    YEAR(o.Purchase_TS) BETWEEN 2020 AND 2024
GROUP BY 
    c.Loyalty_Program, o.Product
ORDER BY 
    refund_rate DESC;


-- 11. Is there a correlation with product refund rates and loyalty status?

SELECT 
    c.Loyalty_Program,
    o.Product,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    SUM(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 ELSE 0 END) AS refund_count,
    ROUND(
        (SUM(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 ELSE 0 END) * 1.0) / COUNT(DISTINCT o.Order_ID), 4
    ) AS refund_rate
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers c ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status os ON o.Order_ID = os.Order_ID
WHERE 
    YEAR(o.Purchase_TS) BETWEEN 2020 AND 2024
GROUP BY 
    c.Loyalty_Program, o.Product
ORDER BY 
    refund_rate DESC;

-- 12. What percentage of customers made more than one purchase in a year? Break it down by year.

WITH CustomerPurchases AS (
    SELECT 
        o.Customer_ID,
        YEAR(o.Purchase_TS) AS purchase_year,
        COUNT(o.Order_ID) AS total_orders
    FROM 
        [Tech Haven].dbo.Tech_Haven_Orders o
    GROUP BY 
        o.Customer_ID, YEAR(o.Purchase_TS)
)
SELECT 
    purchase_year,
    COUNT(DISTINCT CASE WHEN total_orders > 1 THEN Customer_ID END) AS customers_with_multiple_purchases,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    ROUND(
        (COUNT(DISTINCT CASE WHEN total_orders > 1 THEN Customer_ID END) * 1.0) / 
        COUNT(DISTINCT Customer_ID) * 100, 2
    ) AS percentage_with_multiple_purchases
FROM 
    CustomerPurchases
GROUP BY 
    purchase_year
ORDER BY 
    purchase_year;

-- 13. How many refunds were there for each month in 2021?

SELECT 
    YEAR(r.Refund_TS) AS refund_year,
    MONTH(r.Refund_TS) AS refund_month,
    COUNT(r.Order_ID) AS refund_count
FROM 
    [Tech Haven].dbo.Tech_Haven_Order_Status r
WHERE 
    YEAR(r.Refund_TS) = 2021
GROUP BY 
    YEAR(r.Refund_TS), MONTH(r.Refund_TS)
ORDER BY 
    refund_year, refund_month;

-- 14. For each region, what's the total number of customers and the total number of orders? Sort alphabetically by region.

SELECT 
    geo.region,  -- Select the region
    COUNT(DISTINCT c.Customer_ID) AS total_customers,
    COUNT(o.Order_ID) AS total_orders
FROM 
    [Tech Haven].dbo.Tech_Haven_Customers c
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup geo ON c.state = geo.state_code
LEFT JOIN 
    [Tech Haven].dbo.Tech_Haven_Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY 
    geo.region
ORDER BY 
    geo.region;

-- 15. What's the average time to deliver for each purchase platform?

SELECT 
    o.Purchase_Platform,
    AVG(DATEDIFF(DAY, o.Purchase_TS, os.Delivery_TS)) AS avg_delivery_time
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status os ON o.Order_ID = os.Order_ID
WHERE 
    os.Delivery_TS IS NOT NULL
GROUP BY 
    o.Purchase_Platform
ORDER BY 
    o.Purchase_Platform;

-- 16. What were the top 2 regions for iPhone sales in 2020?

SELECT TOP 2 
    geo.region,  -- Select the region
    SUM(o.Quantity_Ordered * o.Price_Each) AS total_sales
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers c ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup geo ON c.State = geo.state_code
WHERE 
    o.Product = 'iPhone'
    AND YEAR(o.Purchase_TS) = 2020
GROUP BY 
    geo.region
ORDER BY 
    total_sales DESC;

