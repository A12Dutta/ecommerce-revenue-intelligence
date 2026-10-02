import os
import pandas as pd
from sqlalchemy import create_engine, text

# 1. Establish Database Connection
DB_USER = "root"
DB_PASS = os.getenv("OLIST_DB_PASSWORD")
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "olist_db"

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# 2. Anomaly Detection Queries
queries = {
    "Unfulfilled Orders Breakdown": """
        SELECT 
            order_status, 
            COUNT(*) AS total_orders,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS pct_of_total
        FROM olist_orders_dataset
        WHERE order_status NOT IN ('delivered')
        GROUP BY order_status
        ORDER BY total_orders DESC;
    """,
    "Multi-Item vs Single-Item Orders": """
        SELECT 
            item_count_category,
            COUNT(*) AS total_orders
        FROM (
            SELECT 
                order_id, 
                CASE 
                    WHEN COUNT(*) = 1 THEN 'Single-Item Order'
                    ELSE 'Multi-Item Order'
                END AS item_count_category
            FROM olist_order_items_dataset
            GROUP BY order_id
        ) AS order_counts
        GROUP BY item_count_category;
    """,
    "Multi-Seller Orders (Complexity Check)": """
        SELECT 
            COUNT(*) AS multi_seller_orders
        FROM (
            SELECT order_id
            FROM olist_order_items_dataset
            GROUP BY order_id
            HAVING COUNT(DISTINCT seller_id) > 1
        ) AS multi_sellers;
    """
}

# 3. Execute and Output Results
with engine.connect() as conn:
    for title, query in queries.items():
        print("=" * 60)
        print(f"ANOMALY CHECK: {title}")
        print("=" * 60)
        df = pd.read_sql(text(query), con=conn)
        print(df.to_string(index=False))
        print("\n")