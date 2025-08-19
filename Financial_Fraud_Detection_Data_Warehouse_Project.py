import os
import mysql.connector
import pandas as pd
from kaggle.api.kaggle_api_extended import KaggleApi

# --------------------
# CONFIGURATION
# --------------------
KAGGLE_DATASET = "ealaxi/paysim1"
CSV_FILE_NAME = "PS_20174392719_1491204439457_log.csv"

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1234567",  # CHANGE THIS
    "database": "fraud_db"
}

# --------------------
# 1. DOWNLOAD DATASET FROM KAGGLE
# --------------------
print("Downloading dataset from Kaggle...")
api = KaggleApi()
api.authenticate()

download_path = "./kaggle_dataset"
os.makedirs(download_path, exist_ok=True)
api.dataset_download_files(KAGGLE_DATASET, path=download_path, unzip=True)

csv_path = os.path.join(download_path, CSV_FILE_NAME)
if not os.path.exists(csv_path):
    raise FileNotFoundError(f"CSV file not found at {csv_path}")

# --------------------
# 2. LOAD INTO PANDAS
# --------------------
print("Loading CSV into DataFrame...")
df = pd.read_csv(csv_path)

# Optional: Basic cleaning / transformation
print("Transforming data...")
df.columns = [col.lower().replace(" ", "_") for col in df.columns]  # clean column names

# --------------------
# 3. CONNECT TO MYSQL
# --------------------
print("Connecting to MySQL...")
conn = mysql.connector.connect(
    host=DB_CONFIG["host"],
    user=DB_CONFIG["user"],
    password=DB_CONFIG["password"]
)
cursor = conn.cursor()

# Ensure database exists
cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DB_CONFIG['database']}")
cursor.execute(f"USE {DB_CONFIG['database']}")

# Drop table if exists
cursor.execute("DROP TABLE IF EXISTS transactions")

# Create table (adjust column types as needed)
cursor.execute("""
CREATE TABLE transactions (
    step INT,
    type VARCHAR(20),
    amount DOUBLE,
    nameorig VARCHAR(20),
    oldbalanceorg DOUBLE,
    newbalanceorg DOUBLE,
    namedest VARCHAR(20),
    oldbalancedest DOUBLE,
    newbalancedest DOUBLE,
    isfraud INT,
    isflaggedfraud INT
)
""")

# --------------------
# 4. LOAD DATA INTO MYSQL IN CHUNKS
# --------------------
print("Loading data into MySQL...")
insert_query = """
INSERT INTO transactions
(step, type, amount, nameorig, oldbalanceorg, newbalanceorg, namedest,
 oldbalancedest, newbalancedest, isfraud, isflaggedfraud)
VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
"""

chunk_size = 5000
for i in range(0, len(df), chunk_size):
    chunk = df.iloc[i:i+chunk_size]
    cursor.executemany(insert_query, chunk.values.tolist())
    conn.commit()
    print(f"Inserted {i+len(chunk)}/{len(df)} rows")

print("✅ Data load complete!")

cursor.close()
conn.close()
