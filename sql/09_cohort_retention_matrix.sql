-- Phase 5.2: Cohort Retention Matrix (Relative Month Index)
USE olist_db;

WITH customer_first_order AS (
    SELECT 
        c.customer_unique_id,
        DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m-01') AS cohort_month,
        MIN(o.order_purchase_timestamp) AS first_order_time
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
customer_orders AS (
    SELECT 
        c.customer_unique_id,
        f.cohort_month,
        TIMESTAMPDIFF(MONTH, f.first_order_time, o.order_purchase_timestamp) AS month_number
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN customer_first_order f ON c.customer_unique_id = f.customer_unique_id
    WHERE o.order_status = 'delivered'
)
SELECT 
    cohort_month,
    month_number,
    COUNT(DISTINCT customer_unique_id) AS active_users
FROM customer_orders
WHERE month_number <= 12
GROUP BY cohort_month, month_number
ORDER BY cohort_month ASC, month_number ASC;