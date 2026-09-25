-- ============================================
-- SQL E-Commerce Analysis | Olist Dataset
-- ============================================

-- 1. Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', order_purchased_at) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_payment_value), 2) AS monthly_revenue
FROM mart_customer_orders
GROUP BY 1
ORDER BY 1;


-- 2. Top 10 Customers by Lifetime Value
SELECT
    customer_unique_id,
    customer_state,
    total_orders,
    ROUND(lifetime_value, 2) AS lifetime_value,
    ROUND(avg_order_value, 2) AS avg_order_value
FROM mart_customer_orders
ORDER BY lifetime_value DESC
LIMIT 10;


-- 3. Customer Segmentation by Order Volume
SELECT
    CASE
        WHEN total_orders = 1 THEN '1 - One-time'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 - Occasional'
        WHEN total_orders BETWEEN 4 AND 6 THEN '4-6 - Regular'
        ELSE '7+ - Loyal'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value
FROM mart_customer_orders
GROUP BY 1
ORDER BY 2 DESC;


-- 4. Revenue by State (Top 10)
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    ROUND(SUM(lifetime_value), 2) AS total_revenue
FROM mart_customer_orders
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;


-- 5. Ranking Customers Within Each State by Lifetime Value
SELECT
    customer_unique_id,
    customer_state,
    ROUND(lifetime_value, 2) AS lifetime_value,
    RANK() OVER (PARTITION BY customer_state ORDER BY lifetime_value DESC) AS rank_in_state
FROM mart_customer_orders
QUALIFY rank_in_state <= 3
ORDER BY customer_state, rank_in_state;


-- 6. Running Total Revenue Over Time
SELECT
    DATE_TRUNC('month', order_purchased_at) AS order_month,
    ROUND(SUM(total_payment_value), 2) AS monthly_revenue,
    ROUND(SUM(SUM(total_payment_value)) OVER (ORDER BY DATE_TRUNC('month', order_purchased_at)), 2) AS running_total
FROM mart_customer_orders
GROUP BY 1
ORDER BY 1;


-- 7. Average Days to Deliver by State
SELECT
    c.customer_state,
    ROUND(AVG(DATE_DIFF('day', o.order_purchased_at, o.order_delivered_at)), 1) AS avg_delivery_days,
    COUNT(*) AS total_orders
FROM stg_orders o
JOIN stg_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_at IS NOT NULL
GROUP BY 1
ORDER BY avg_delivery_days;


-- 8. Late Delivery Rate by State
SELECT
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.order_delivered_at > o.order_estimated_delivery_at THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN o.order_delivered_at > o.order_estimated_delivery_at THEN 1 ELSE 0 END) / COUNT(*), 1) AS late_pct
FROM stg_orders o
JOIN stg_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_at IS NOT NULL
GROUP BY 1
HAVING COUNT(*) > 50
ORDER BY late_pct DESC;