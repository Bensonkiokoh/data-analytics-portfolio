-- ============================================
-- SHOPZETU E-COMMERCE ANALYSIS
-- Analyst: Benson Kioko
-- Tool: SQL Server Management Studio
-- Date: 2024
-- Description: Exploratory data analysis of
-- ShopZetu online fashion store covering
-- revenue trends, customer acquisition,
-- product performance, and RFM segmentation.
-- ============================================

USE ShopZetu;
GO

-- ============================================
-- QUERY 1: Monthly Revenue Trend
-- Business Question: How has ShopZetu total
-- revenue trended month by month from January
-- 2023 to July 2024? Is the business growing,
-- flat, or declining?
-- ============================================

SELECT
    FORMAT(O.order_date, 'yyyy-MM')      AS OrderMonth,
    SUM(OI.quantity * OI.unit_price)     AS TotalRevenue
FROM Order_Items OI
INNER JOIN Orders O ON OI.order_id = O.order_id
GROUP BY FORMAT(O.order_date, 'yyyy-MM')
ORDER BY MIN(O.order_date);

-- Finding: Revenue grew consistently through 2023,
-- peaking at KES 24,700 in January 2024, likely
-- driven by back-to-school and new year cycles.
-- Declined sharply from March 2024 to KES 6,600
-- in June 2024. June and July data may be incomplete
-- -- verify before drawing conclusions on the decline.


-- ============================================
-- QUERY 2: New Customer Acquisition per Month
-- Business Question: How many new customers
-- joined ShopZetu each month? Is the business
-- growing its customer base?
-- ============================================

SELECT
    FORMAT(join_date, 'yyyy-MM')     AS JoiningMonth,
    COUNT(*)                         AS NewCustomers
FROM Customers
GROUP BY FORMAT(join_date, 'yyyy-MM')
ORDER BY MIN(join_date);

-- Finding: ShopZetu acquired exactly 2 customers
-- per month from January to October 2023 -- 20
-- customers total -- and has acquired zero new
-- customers since. Despite this, revenue continued
-- growing into early 2024, confirming existing
-- customers are increasing their spend over time.
-- Recommendation: target at least 5 new customers
-- per month to reduce concentration risk.


-- ============================================
-- QUERY 3: Top 10 and Bottom 10 Products
-- Business Question: Which products generate
-- the most and least revenue? Show total units
-- sold and total revenue per product.
-- ============================================

WITH ProductRevenue AS (
    SELECT
        P.product_name,
        P.category,
        SUM(OI.quantity * OI.unit_price)    AS TotalRevenue,
        SUM(OI.quantity)                    AS TotalUnitsSold,
        DENSE_RANK() OVER (ORDER BY SUM(OI.quantity * OI.unit_price) DESC) AS TopRank,
        DENSE_RANK() OVER (ORDER BY SUM(OI.quantity * OI.unit_price) ASC)  AS BottomRank
    FROM Order_Items OI
    INNER JOIN Products P ON OI.product_id = P.product_id
    GROUP BY P.product_name, P.category
)
SELECT
    product_name,
    category,
    TotalRevenue,
    TotalUnitsSold,
    CASE
        WHEN TopRank    <= 10 THEN 'Top 10'
        WHEN BottomRank <= 10 THEN 'Bottom 10'
    END AS RankGroup
FROM ProductRevenue
WHERE TopRank <= 10 OR BottomRank <= 10
ORDER BY TotalRevenue DESC;

-- Finding: Trench Coat (KES 38,500) and Running
-- Sneakers (KES 37,800) are top revenue drivers
-- through premium pricing, not volume.
-- Classic White Shirt is the most sold product
-- at 10 units but sits in bottom 10 due to its
-- low unit price of KES 1,200.
-- Recommendation: review pricing on high-demand
-- low-price items and develop bundling strategies.


-- ============================================
-- QUERY 4: Revenue by Product Category
-- Business Question: How is total revenue
-- distributed across product categories?
-- Which categories drive the most value?
-- ============================================

WITH ProductRevenue AS (
    SELECT
        P.category,
        SUM(OI.quantity * OI.unit_price)    AS TotalRevenue
    FROM Order_Items OI
    INNER JOIN Products P ON OI.product_id = P.product_id
    GROUP BY P.category
)
SELECT
    category,
    TotalRevenue,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER(), 2) AS PercentageShare
FROM ProductRevenue
ORDER BY TotalRevenue DESC;

-- Finding: Jackets, Footwear, and Accessories
-- account for 58.3% of total revenue, driven by
-- premium pricing. Tops is the weakest category
-- at 5.93% despite containing the most sold product.
-- Activewear shows internal inconsistency -- Yoga
-- Pants in top 10, Sports Bra in bottom 10.
-- Recommendation: review Tops pricing and replace
-- or reprice Sports Bra.


-- ============================================
-- QUERY 5: Repeat Purchase Rate
-- Business Question: What percentage of
-- customers have made more than one purchase?
-- How strong is customer loyalty?
-- ============================================

WITH CustomerOrders AS (
    SELECT
        customer_id,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY customer_id
)
SELECT
    COUNT(*)                                                        AS TotalCustomers,
    SUM(CASE WHEN TotalOrders > 1 THEN 1 ELSE 0 END)               AS RepeatCustomers,
    ROUND(
        SUM(CASE WHEN TotalOrders > 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
    2)                                                              AS RepeatRate
FROM CustomerOrders;

-- Finding: 70% of customers are repeat buyers --
-- nearly double the 40% benchmark.
-- 6 customers have purchased only once and
-- represent an immediate re-engagement opportunity.
-- Recommendation: win-back campaign for single-
-- purchase customers and prioritise new acquisition
-- as the most urgent growth lever.


-- ============================================
-- QUERY 6: Average Days Between First and
-- Second Purchase
-- Business Question: For customers with at least
-- two purchases, how many days passed between
-- their first and second order?
-- ============================================

WITH CustomerOrders AS (
    SELECT
        customer_id,
        order_date,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY customer_id, order_date
),
OrderDates AS (
    SELECT
        C.full_name,
        CO.order_date,
        COUNT(CO.TotalOrders) OVER (PARTITION BY C.customer_id)             AS TotalOrdersPlaced,
        LEAD(CO.order_date)   OVER (PARTITION BY C.customer_id
                                    ORDER BY CO.order_date)                 AS NextOrderDate,
        DENSE_RANK()          OVER (PARTITION BY C.customer_id
                                    ORDER BY CO.order_date)                 AS OrderRank
    FROM Customers C
    INNER JOIN CustomerOrders CO ON C.customer_id = CO.customer_id
)
SELECT
    full_name,
    order_date                                          AS FirstOrderDate,
    DATEDIFF(DAY, order_date, NextOrderDate)            AS DaysBetweenOrders
FROM OrderDates
WHERE OrderRank = 1
AND   TotalOrdersPlaced > 1
ORDER BY DaysBetweenOrders ASC;

-- Finding: Average gap between first and second
-- purchase is 114 days (approximately 4 months).
-- Fastest return: 66 days. Slowest: 163 days.
-- Recommendation: trigger re-engagement campaigns
-- at day 90 post-purchase. Classify single-purchase
-- customers as At Risk after 120 days and Lost
-- after 180 days of inactivity.


-- ============================================
-- QUERY 7: RFM Customer Segmentation
-- Business Question: How do ShopZetu customers
-- segment by Recency, Frequency, and Monetary
-- value? Who are Champions, Loyal, At Risk,
-- and Lost customers?
-- Reference date: 2024-08-01
-- Scoring: NTILE(4) -- 4 = best, 1 = worst
-- Recency: lower days = better = score 4
-- Frequency: higher orders = better = score 4
-- Monetary: higher spend = better = score 4
-- ============================================

WITH CustomerMetrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT O.order_id)          AS Frequency,
        SUM(OI.quantity * OI.unit_price)    AS Monetary
    FROM Orders O
    INNER JOIN Order_Items OI ON O.order_id = OI.order_id
    GROUP BY customer_id
),
LastOrder AS (
    SELECT
        customer_id,
        MAX(order_date) AS LastOrderDate
    FROM Orders
    GROUP BY customer_id
),
RFM_Base AS (
    SELECT
        C.customer_id,
        C.full_name,
        DATEDIFF(DAY, LO.LastOrderDate, '2024-08-01')               AS Recency,
        CM.Frequency,
        CM.Monetary,
        NTILE(4) OVER (ORDER BY CM.Frequency ASC)                   AS NtileFrequency,
        NTILE(4) OVER (ORDER BY CM.Monetary  ASC)                   AS NtileMonetary,
        NTILE(4) OVER (ORDER BY
            DATEDIFF(DAY, LO.LastOrderDate, '2024-08-01') DESC)     AS NtileRecency
    FROM Customers C
    INNER JOIN CustomerMetrics CM ON C.customer_id = CM.customer_id
    INNER JOIN LastOrder LO        ON C.customer_id = LO.customer_id
),
RFM_Scored AS (
    SELECT
        full_name,
        Recency,
        Frequency,
        Monetary,
        NtileRecency,
        NtileFrequency,
        NtileMonetary,
        ROUND((NtileRecency + NtileFrequency + NtileMonetary) / 3.0, 2) AS AvgScore,
        CASE
            WHEN NtileRecency = 4
             AND NtileFrequency = 4
             AND NtileMonetary  = 4
                THEN 'Champion'
            WHEN (NtileRecency + NtileFrequency + NtileMonetary) / 3.0 >= 2.5
                THEN 'Loyal'
            WHEN (NtileRecency + NtileFrequency + NtileMonetary) / 3.0 >= 1.5
                THEN 'At Risk'
            ELSE 'Lost'
        END AS Segment
    FROM RFM_Base
)
SELECT
    full_name,
    Recency,
    Frequency,
    Monetary,
    NtileRecency,
    NtileFrequency,
    NtileMonetary,
    AvgScore,
    Segment
FROM RFM_Scored
ORDER BY AvgScore DESC;

-- Finding: 2 Champions, 9 Loyal, 4 At Risk,
-- 5 Lost out of 20 customers.
-- Champions: Amina Wanjiru and Grace Chebet.
-- Lost: Henry Odhiambo, Quincy Omondi,
-- James Kariuki, Lydia Rotich, Nancy Cherop.
-- Note: RFM scores are relative not absolute.
-- In a base of 20 customers, top 25% frequency
-- only requires 4 orders to qualify as Champion.
-- Recommendation: loyalty rewards for Champions
-- and Loyal, win-back offers for At Risk,
-- evaluate cost of re-engaging Lost customers.