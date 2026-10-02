import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine, text

# 1. Establish MySQL Connection
DB_USER = "root"
DB_PASS = os.getenv("OLIST_DB_PASSWORD")  
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "olist_db"

print("Checking environment and database connection...\n")

try:
    engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")
    
    # 2. Test execution with a basic SQL query
    query = "SELECT order_status, COUNT(*) AS total_orders FROM olist_orders_dataset GROUP BY order_status;"
    
    with engine.connect() as conn:
        df = pd.read_sql(text(query), con=conn)
        
    print("✓ Environment check successful!")
    print("✓ Database connection established.")
    print("\nSample Query Output (Orders by Status):")
    print(df.to_string(index=False))

except Exception as e:
    print(f"❌ Connection/Environment Error: {e}")