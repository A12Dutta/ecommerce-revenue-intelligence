-- Phase 4.4: Logistics & Customer Experience Analysis
USE olist_db;

-- 1. Delivery Gap & Late Delivery Performance
SELECT 
    COUNT(*) AS total_delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_delivery_pct,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 1) AS avg_actual_days,
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date)), 1) AS avg_days_ahead_of_estimate
FROM olist_orders_dataset
WHERE order_status = 'delivered';

-- 2. Impact of On-Time vs. Late Delivery on Review Scores
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late Delivery'
        ELSE 'On-Time / Early'
    END AS delivery_performance,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_performance;