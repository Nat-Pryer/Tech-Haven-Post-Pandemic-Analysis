
-- 1. What were the order counts, sales, and AOV for Macbooks sold in North America for each quarter across all years?

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,  -- Extract the year from the Purchase_TS column
    DATEPART(QUARTER, o.Purchase_TS) AS purchase_quarter,  -- Extract the quarter from the Purchase_TS column
    SUM(o.Quantity_Ordered) AS order_count,  -- Sum the Quantity_Ordered for the order count
    SUM(o.Price_Each * o.Quantity_Ordered) AS total_sales,  -- Calculate total sales
    ROUND(SUM(o.Price_Each * o.Quantity_Ordered) / SUM(o.Quantity_Ordered), 2) AS aov  -- Calculate average order value
FROM [Tech Haven].dbo.Tech_Haven_Orders AS o  -- Specify the 'Tech Haven Orders' table and alias it as 'o'
WHERE o.Product = 'Macbook Pro Laptop'  -- Filter to only include orders for 'Macbook Pro Laptop'
GROUP BY YEAR(o.Purchase_TS), DATEPART(QUARTER, o.Purchase_TS)  -- Group the results by purchase year and quarter
ORDER BY purchase_year, purchase_quarter;  -- Order by purchase year and then by purchase quarter

-- 2. How many Macbooks were ordered each month in 2020 through 2021, sorted from oldest to most recent month?

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,  -- Extract the year from the Purchase_TS column
    MONTH(o.Purchase_TS) AS purchase_month,  -- Extract the month from the Purchase_TS column
    SUM(o.Quantity_Ordered) AS total_macbooks_ordered  -- Sum the Quantity_Ordered for Macbook orders
FROM [Tech Haven].dbo.Tech_Haven_Orders AS o  -- Specify the 'Tech Haven Orders' table and alias it as 'o'
WHERE o.Product = 'Macbook Pro Laptop'  -- Filter to only include orders for 'Macbook Pro Laptop'
    AND YEAR(o.Purchase_TS) BETWEEN 2020 AND 2021  -- Filter to only include orders from 2020 and 2021
GROUP BY YEAR(o.Purchase_TS), MONTH(o.Purchase_TS)  -- Group by purchase year and purchase month
ORDER BY purchase_year ASC, purchase_month ASC;  -- Order by purchase year and then by purchase month (oldest to most recent)

-- 3. Return the purchase month, shipping month, time to ship (in days), and product name for each order placed in 2020.

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,        -- Extract the purchase year
    MONTH(o.Purchase_TS) AS purchase_month,      -- Extract the purchase month
    YEAR(os.Ship_TS) AS ship_year,               -- Extract the shipping year
    MONTH(os.Ship_TS) AS ship_month,             -- Extract the shipping month
    DATEDIFF(DAY, o.Purchase_TS, os.Ship_TS) AS time_to_ship,  -- Calculate the time difference between purchase and shipping in days
    o.Product                                    -- Return the product name
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o                  -- Tech Haven Orders table
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os           -- Tech Haven Order Status table
    ON o.Order_ID = os.Order_ID                 -- Join the two tables on Order_ID
WHERE 
    YEAR(o.Purchase_TS) = 2020                  -- Filter to only include orders from the year 2020
ORDER BY 
    purchase_year, purchase_month;              -- Sort by purchase year and purchase month

-- 4. What is the average order value per year for products that are either phones or headphones?

SELECT 
    YEAR(Purchase_TS) AS purchase_year,                  -- Extract the purchase year
    ROUND(SUM(Price_Each * Quantity_Ordered) / COUNT(DISTINCT Order_ID), 2) AS avg_order_value -- Calculate AOV per year
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders                               -- Tech Haven Orders table
WHERE 
    Product LIKE '%phone%' OR Product LIKE '%headphone%' -- Filter for products that are phones or headphones
GROUP BY 
    YEAR(Purchase_TS)                                    -- Group the results by purchase year
ORDER BY 
    purchase_year;                                      -- Order the results by purchase year

-- 5. How many people used the mobile app vs the website as a purchase platform?

SELECT 
    Purchase_Platform,                                 -- Select the Purchase Platform (Mobile App or Website)
    COUNT(DISTINCT Customer_ID) AS customer_count       -- Count the distinct number of customers
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders                               -- Tech Haven Orders table
GROUP BY 
    Purchase_Platform                                   -- Group by Purchase Platform
ORDER BY 
    customer_count DESC;                               -- Order by the number of customers in descending order

-- 6. What is the total number of orders per year for each product? Clean up product names when grouping and return in alphabetical order after sorting by months.

SELECT 
    YEAR(o.Purchase_TS) AS purchase_year,                      -- Extract the year from the purchase timestamp and label it as 'purchase_year'
    REPLACE(o.Product, ' ', '') AS cleaned_product,              -- Clean up the product name by removing spaces
    MONTH(o.Purchase_TS) AS purchase_month,                     -- Extract the month from the purchase timestamp and label it as 'purchase_month'
    COUNT(o.Order_ID) AS total_orders                            -- Count the total number of orders for each product
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o                                  -- From the 'Tech_Haven_Orders' table (aliased as 'o')
GROUP BY 
    YEAR(o.Purchase_TS),                                        -- Group by purchase year
    REPLACE(o.Product, ' ', ''),                                 -- Group by the cleaned-up product name (with spaces removed)
    MONTH(o.Purchase_TS)                                        -- Group by the purchase month
ORDER BY 
    purchase_year ASC,                                          -- Order by purchase year in ascending order
    purchase_month ASC,                                         -- Order by purchase month in ascending order
    cleaned_product ASC;                                        -- Order by product name in alphabetical order

SELECT 
    geo.region,                                                    -- Select the region from the Geo_Lookup table
    AVG(DATEDIFF(day, o.Purchase_TS, os.Delivery_TS)) AS avg_delivery_time -- Calculate the average delivery time (in days) for each region
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o                                      -- From the Tech_Haven_Orders table (aliased as 'o')
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os                               -- Join the Tech_Haven_Order_Status table (aliased as 'os') on Order_ID
    ON o.Order_ID = os.Order_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers AS c                                   -- Join the Tech_Haven_Customers table (aliased as 'c') to get customer information
    ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup AS geo                                -- Join the Tech_Haven_Geo_Lookup table (aliased as 'geo') to get region information
    ON c.State = geo.state_name
WHERE 
    (
        (YEAR(o.Purchase_TS) = 2022 AND o.Purchase_Platform = 'Website')  -- Filter for products purchased on the website in 2022
        OR
        (o.Purchase_Platform = 'Mobile App')                                     -- Filter for products purchased on mobile in any year
    )
GROUP BY 
    geo.region                                                        -- Group by region to get the average delivery time for each region
ORDER BY 
    avg_delivery_time DESC;                                           -- Order by average delivery time in descending order, so the region with the highest average comes first

--7. For products purchased in 2022 on the website or products purchased on mobile in any year, which region has the average highest time to deliver?

SELECT 
    geo.region,                                                    -- Select the region from the Geo_Lookup table
    AVG(DATEDIFF(day, o.Purchase_TS, os.Delivery_TS)) AS avg_delivery_time -- Calculate the average delivery time (in days) for each region
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders AS o                                      -- From the Tech_Haven_Orders table (aliased as 'o')
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status AS os                               -- Join the Tech_Haven_Order_Status table (aliased as 'os') on Order_ID
    ON o.Order_ID = os.Order_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers AS c                                   -- Join the Tech_Haven_Customers table (aliased as 'c') to get customer information
    ON o.Customer_ID = c.Customer_ID
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup AS geo                                -- Join the Tech_Haven_Geo_Lookup table (aliased as 'geo') to get region information
    ON c.State = geo.state_code
WHERE 
    (
        (YEAR(o.Purchase_TS) = 2022 AND o.Purchase_Platform = 'Website')  -- Filter for products purchased on the website in 2022
        OR
        (o.Purchase_Platform = 'Mobile')                                     -- Filter for products purchased on mobile in any year
    )
GROUP BY 
    geo.region                                                        -- Group by region to get the average delivery time for each region
ORDER BY 
    avg_delivery_time DESC;                                           -- Order by average delivery time in descending order, so the region with the highest average comes first


--8. What was the refund rate and refund count for each product overall?

SELECT 
    o.Product,
    COUNT(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 END) AS refund_count, -- Count refunded orders
    CAST(ROUND(
        (COUNT(CASE WHEN os.Refund_TS IS NOT NULL THEN 1 END) * 1.0 / COUNT(o.Order_ID)) * 100, 
        1
    ) AS DECIMAL(10, 1)) AS refund_rate -- Calculate refund rate as a percentage, round to 1 decimal, and cast to DECIMAL
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
    YEAR(r.Refund_TS) = 2021  -- Filter for refunds in 2021
GROUP BY 
    YEAR(r.Refund_TS), MONTH(r.Refund_TS)  -- Group by year and month
ORDER BY 
    refund_year, refund_month;  -- Sort by year and month

-- 14. For each region, what's the total number of customers and the total number of orders? Sort alphabetically by region.

SELECT 
    geo.region,  -- Select the region
    COUNT(DISTINCT c.Customer_ID) AS total_customers,  -- Count the distinct customers in each region
    COUNT(o.Order_ID) AS total_orders  -- Count the total orders in each region
FROM 
    [Tech Haven].dbo.Tech_Haven_Customers c
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup geo ON c.state = geo.state_code  -- Join customers with their regions
LEFT JOIN 
    [Tech Haven].dbo.Tech_Haven_Orders o ON c.Customer_ID = o.Customer_ID  -- Join orders with customers
GROUP BY 
    geo.region  -- Group the results by region
ORDER BY 
    geo.region;  -- Sort by region alphabetically

-- 15. What's the average time to deliver for each purchase platform?

SELECT 
    o.Purchase_Platform,  -- Select the purchase platform
    AVG(DATEDIFF(DAY, o.Purchase_TS, os.Delivery_TS)) AS avg_delivery_time  -- Calculate the average delivery time in days
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Order_Status os ON o.Order_ID = os.Order_ID  -- Join orders with order status
WHERE 
    os.Delivery_TS IS NOT NULL  -- Only include rows where delivery is not null
GROUP BY 
    o.Purchase_Platform  -- Group the results by purchase platform
ORDER BY 
    o.Purchase_Platform;  -- Sort by purchase platform

-- 16. What were the top 2 regions for iPhone sales in 2020?

SELECT TOP 2 
    geo.region,  -- Select the region
    SUM(o.Quantity_Ordered * o.Price_Each) AS total_sales  -- Calculate the total sales for iPhones
FROM 
    [Tech Haven].dbo.Tech_Haven_Orders o
JOIN 
    [Tech Haven].dbo.Tech_Haven_Customers c ON o.Customer_ID = c.Customer_ID  -- Join with the customers table to get the region
JOIN 
    [Tech Haven].dbo.Tech_Haven_Geo_Lookup geo ON c.State = geo.state_code  -- Join with the geo lookup table to get the region
WHERE 
    o.Product = 'iPhone'  -- Filter for iPhone sales
    AND YEAR(o.Purchase_TS) = 2020  -- Filter for 2020 only
GROUP BY 
    geo.region  -- Group by region
ORDER BY 
    total_sales DESC;  -- Sort by total sales in descending order

