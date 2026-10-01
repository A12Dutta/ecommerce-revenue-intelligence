-- Phase 4.3: Revenue Reconciliation (Payments vs. Order Items)
USE olist_db;

SELECT 
    o.order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(SUM(i.item_gross_value), 2) AS total_item_plus_freight,
    ROUND(SUM(p.payment_value) - SUM(i.item_gross_value), 2) AS variance
FROM olist_orders_dataset o
LEFT JOIN (
    SELECT order_id, SUM(payment_value) AS payment_value
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p ON o.order_id = p.order_id
LEFT JOIN (
    SELECT order_id, SUM(price + freight_value) AS item_gross_value
    FROM olist_order_items_dataset
    GROUP BY order_id
) i ON o.order_id = i.order_id
GROUP BY o.order_status
ORDER BY total_orders DESC;