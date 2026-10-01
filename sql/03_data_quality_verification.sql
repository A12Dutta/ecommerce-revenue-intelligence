-- Phase 2.3: Verify Row Counts Across All 9 Tables
USE olist_db;

SELECT 'product_category_name_translation' AS table_name, COUNT(*) AS mysql_row_count FROM product_category_name_translation
UNION ALL
SELECT 'olist_customers_dataset', COUNT(*) FROM olist_customers_dataset
UNION ALL
SELECT 'olist_sellers_dataset', COUNT(*) FROM olist_sellers_dataset
UNION ALL
SELECT 'olist_products_dataset', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'olist_geolocation_dataset', COUNT(*) FROM olist_geolocation_dataset
UNION ALL
SELECT 'olist_orders_dataset', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'olist_order_items_dataset', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'olist_order_payments_dataset', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'olist_order_reviews_dataset', COUNT(*) FROM olist_order_reviews_dataset;