# Financial_Fraud_Detection_Data_Warehouse_Project

In this project, I designed and implemented a complete ETL-based Data Warehouse pipeline for Financial Fraud Detection, leveraging a large-scale Kaggle dataset (PaySim1, with over 6.3 million transactions) to simulate real-world financial systems.

The process began with the Extract phase, where the dataset was programmatically downloaded from Kaggle into the project environment. In the Transform phase, I performed extensive preprocessing in Python using Pandas, including standardizing column names, converting data types, handling null values, and ensuring relational integrity to prepare the dataset for structured querying.

For the Load phase, I integrated the dataset into a MySQL Data Warehouse. Initially, I attempted row-by-row insertion, which proved inefficient. To solve this, I implemented chunked batch insertion, loading data in optimized blocks until all 6,362,620 rows were inserted. This approach greatly improved performance and mirrored real-world ETL optimization strategies.

After successful warehousing, I designed SQL-based analytical queries to uncover fraudulent activity patterns. Insights included fraud rates by transaction type, average fraudulent amounts, high-risk merchant categories, and time-based fraud trends. To enhance interpretability, I extended the project into a Jupyter Notebook, combining SQL queries with Python visualizations (Matplotlib & Seaborn) to create fraud trend charts, heatmaps, and comparative graphs.

This project demonstrates my ability to work with big data in SQL and Python, and showcases a production-grade ETL pipeline with batch loading optimization, scalable database integration, and actionable financial fraud analytics — skills directly applicable to real-world data engineering and fraud detection.
