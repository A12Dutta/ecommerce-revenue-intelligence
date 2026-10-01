import os
import pandas as pd
from sqlalchemy import create_engine

# 1. Establish Database Connection
DB_USER = "root"
DB_PASS = "MySQL18#DA09"  # Replace with your actual MySQL password
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "olist_db"

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

output_dir = "powerbi_data"
os.makedirs(output_dir, exist_ok=True)

# 2. Key Analytical Datasets to Export for Power BI Modeling
export_queries = {
    "fact_orders": """
        SELECT 
            o.order_id,
            o.customer_id,
            o.order_status,
            o.order_purchase_timestamp,
            o.order_approved_at,
            o.order_delivered_carrier_date,
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        FROM olist_orders_dataset o;
    """,
    "fact_order_items": """
        SELECT 
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value
        FROM olist_order_items_dataset;
    """,
    "fact_order_payments": """
        SELECT 
            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            payment_value
        FROM olist_order_payments_dataset;
    """,
    "fact_order_reviews": """
        SELECT 
            review_id,
            order_id,
            review_score,
            review_creation_date,
            review_answer_timestamp
        FROM olist_order_reviews_dataset;
    """,
    "dim_customers": """
        SELECT 
            c.customer_id,
            c.customer_unique_id,
            c.customer_zip_code_prefix,
            c.customer_city,
            c.customer_state,
            vc.cohort_month
        FROM olist_customers_dataset c
        LEFT JOIN view_customer_cohorts vc ON c.customer_unique_id = vc.customer_unique_id;
    """,
    "dim_products": """
        SELECT 
            p.product_id,
            COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS product_category_name,
            p.product_weight_g,
            p.product_length_cm,
            p.product_height_cm,
            p.product_width_cm
        FROM olist_products_dataset p
        LEFT JOIN product_category_name_translation t 
            ON p.product_category_name = t.product_category_name;
    """,
    "dim_sellers": """
        SELECT 
            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        FROM olist_sellers_dataset;
    """
}

# 3. Export each query to CSV
print("Exporting datasets for Power BI...\n")
with engine.connect() as conn:
    for table_name, query in export_queries.items():
        df = pd.read_sql(query, con=conn)
        file_path = os.path.join(output_dir, f"{table_name}.csv")
        df.to_csv(file_path, index=False)
        print(f"✓ Exported {table_name}.csv ({len(df):,} rows)")

print("\nAll datasets exported successfully into powerbi_data/!")