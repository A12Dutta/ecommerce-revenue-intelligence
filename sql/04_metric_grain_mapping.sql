-- Phase 4.1: Metric Definition & Revenue Reconciliation across Grains
USE olist_db;

-- 1. Order-Item Level Revenue Breakdown
SELECT 
    'Item Level' AS aggregation_grain,
    ROUND(SUM(price), 2) AS total_item_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight_value,
    ROUND(SUM(price + freight_value), 2) AS total_gross_value
FROM olist_order_items_dataset;

-- 2. Payment Level Revenue Total Check
SELECT 
    'Payment Level' AS aggregation_grain,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM olist_order_payments_dataset;
