-- Phase 2.1B/2.1C: Schema Implementation (DDL)
USE olist_db;

-- 1. Product Category Name Translation
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(64) PRIMARY KEY,
    product_category_name_english VARCHAR(64) NOT NULL
);

-- 2. Customers Table
CREATE TABLE IF NOT EXISTS olist_customers_dataset (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix INT NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state VARCHAR(2) NOT NULL
);

-- 3. Sellers Table
CREATE TABLE IF NOT EXISTS olist_sellers_dataset (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state VARCHAR(2) NOT NULL
);

-- 4. Products Table
CREATE TABLE IF NOT EXISTS olist_products_dataset (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(64),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    FOREIGN KEY (product_category_name) REFERENCES product_category_name_translation(product_category_name)
);

-- 5. Geolocation Table (No strict PK due to duplicates across prefix/coordinates)
CREATE TABLE IF NOT EXISTS olist_geolocation_dataset (
    geolocation_zip_code_prefix INT NOT NULL,
    geolocation_lat DECIMAL(10, 8) NOT NULL,
    geolocation_lng DECIMAL(11, 8) NOT NULL,
    geolocation_city VARCHAR(100) NOT NULL,
    geolocation_state VARCHAR(2) NOT NULL
);

-- 6. Orders Table
CREATE TABLE IF NOT EXISTS olist_orders_dataset (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id)
);

-- 7. Order Items Table
CREATE TABLE IF NOT EXISTS olist_order_items_dataset (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    freight_value DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id),
    FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id)
);

-- 8. Order Payments Table
CREATE TABLE IF NOT EXISTS olist_order_payments_dataset (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);

-- 9. Order Reviews Table
CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset (
    review_id VARCHAR(32) NOT NULL,
    order_id VARCHAR(32) NOT NULL,
    review_score INT NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME NOT NULL,
    review_answer_timestamp DATETIME NOT NULL,
    PRIMARY KEY (review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);