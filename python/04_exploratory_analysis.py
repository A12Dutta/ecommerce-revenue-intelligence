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

# 2. Key Analytical Queries
queries = {
    "Payment Value Statistics": """
        SELECT 
            ROUND(AVG(payment_value), 2) AS avg_payment,
            ROUND(MIN(payment_value), 2) AS min_payment,
            ROUND(MAX(payment_value), 2) AS max_payment,
            ROUND(STDDEV(payment_value), 2) AS std_payment
        FROM olist_order_payments_dataset;
    """,
    "Delivery Performance Metrics (Days)": """
        SELECT 
            ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 1) AS avg_delivery_days,
            ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date)), 1) AS avg_days_ahead_of_estimate
        FROM olist_orders_dataset
        WHERE order_status = 'delivered';
    """,
    "Review Score Breakdown": """
        SELECT 
            review_score, 
            COUNT(*) AS total_reviews,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset), 2) AS percentage
        FROM olist_order_reviews_dataset
        GROUP BY review_score
        ORDER BY review_score DESC;
    """
}

# 3. Execute and Output Results
with engine.connect() as conn:
    for title, query in queries.items():
        print("=" * 60)
        print(f"METRIC: {title}")
        print("=" * 60)
        df = pd.read_sql(text(query), con=conn)
        print(df.to_string(index=False))
        print("\n")