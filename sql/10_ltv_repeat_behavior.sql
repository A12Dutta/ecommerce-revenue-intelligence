-- Phase 5.3: Repeat Purchase Rate & Customer Lifetime Value (LTV)
USE olist_db;

-- 1. Repeat Purchase Rate Overview
WITH customer_order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(p.payment_value) AS total_customer_spend
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_customer_pct,
    ROUND(AVG(total_customer_spend), 2) AS overall_avg_ltv,
    ROUND(AVG(CASE WHEN total_orders > 1 THEN total_customer_spend END), 2) AS repeat_customer_avg_ltv,
    ROUND(AVG(CASE WHEN total_orders = 1 THEN total_customer_spend END), 2) AS single_order_avg_ltv
FROM customer_order_counts;