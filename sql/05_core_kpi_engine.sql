-- Phase 4.2: Core E-Commerce Decision KPIs
USE olist_db;

SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_unique_customers,
    ROUND(SUM(p.payment_value), 2) AS total_gross_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value_aov,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT c.customer_unique_id), 2) AS avg_revenue_per_user_arpu
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';