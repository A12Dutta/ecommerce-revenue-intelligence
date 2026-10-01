import os
import pandas as pd

raw_data_path = os.path.join("DATA", "raw")

for file_name in os.listdir(raw_data_path):
    if file_name.endswith(".csv"):
        file_path = os.path.join(raw_data_path, file_name)
        df = pd.read_csv(file_path)
        print("=" * 60)
        print(f"TABLE: {file_name}")
        print(f"SHAPE: {df.shape[0]} rows, {df.shape[1]} columns")
        print("\nCOLUMNS & DATA TYPES:")
        print(df.dtypes)
        print("\nNULL COUNTS:")
        print(df.isnull().sum()[df.isnull().sum() > 0])
        print("\nHEAD:")
        print(df.head(2))
        print("=" * 60 + "\n")