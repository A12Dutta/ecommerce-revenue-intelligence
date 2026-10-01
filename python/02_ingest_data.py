import os
import pandas as pd
from sqlalchemy import create_engine, text

# 1. Establish MySQL Connection
# Replace 'your_password' with your actual MySQL root password
DB_USER = "root"
DB_PASS = "MySQL18#DA09" 
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "olist_db"

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

raw_data_path = os.path.join("DATA", "raw")

# 2. Ingestion Order (Respecting Foreign Key Dependencies)
ingestion_plan = [
    ("product_category_name_translation.csv", "product_category_name_translation", []),
    ("olist_customers_dataset.csv", "olist_customers_dataset", []),
    ("olist_sellers_dataset.csv", "olist_sellers_dataset", []),
    ("olist_products_dataset.csv", "olist_products_dataset", []),
    ("olist_geolocation_dataset.csv", "olist_geolocation_dataset", []),
    ("olist_orders_dataset.csv", "olist_orders_dataset", [
        "order_purchase_timestamp", "order_approved_at", 
        "order_delivered_carrier_date", "order_delivered_customer_date", 
        "order_estimated_delivery_date"
    ]),
    ("olist_order_items_dataset.csv", "olist_order_items_dataset", ["shipping_limit_date"]),
    ("olist_order_payments_dataset.csv", "olist_order_payments_dataset", []),
    ("olist_order_reviews_dataset.csv", "olist_order_reviews_dataset", [
        "review_creation_date", "review_answer_timestamp"
    ])
]

# 3. Process Ingestion
print("Starting Data Ingestion into MySQL...\n")

with engine.begin() as conn:
    # Disable foreign key checks during batch insert for speed & smooth load
    conn.execute(text("SET FOREIGN_KEY_CHECKS = 0;"))

    for csv_file, table_name, date_cols in ingestion_plan:
        file_path = os.path.join(raw_data_path, csv_file)
        df = pd.read_csv(file_path)

        # Convert date columns to datetime
        for col in date_cols:
            df[col] = pd.to_datetime(df[col], errors='coerce')

        print(f"Loading {csv_file} -> `{table_name}` ({len(df)} rows)...")
        df.to_sql(name=table_name, con=conn, if_exists='append', index=False, chunksize=5000)
        print(f"✓ `{table_name}` loaded successfully.")

    conn.execute(text("SET FOREIGN_KEY_CHECKS = 1;"))

print("\nAll data successfully ingested into olist_db!")