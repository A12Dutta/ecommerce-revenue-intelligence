-- Phase 5.1: Customer Cohort Construction
USE olist_db;

-- 1. Create View for Customer First Purchase Month
CREATE OR REPLACE VIEW view_customer_cohorts AS
SELECT 
    c.customer_unique_id,
    DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m-01') AS cohort_month
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;

-- 2. Verify Cohort Distribution
SELECT 
    cohort_month,
    COUNT(customer_unique_id) AS total_acquired_customers
FROM view_customer_cohorts
GROUP BY cohort_month
ORDER BY cohort_month ASC;