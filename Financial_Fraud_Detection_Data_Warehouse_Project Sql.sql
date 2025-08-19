CREATE DATABASE fraud_db;
use fraud_db;
select * from transactions;
select count(*) from transactions;

-- Total transactions
SELECT COUNT(*) AS total_transactions
FROM transactions;

-- Fraud vs. Non-Fraud counts
SELECT isFraud, COUNT(*) AS transaction_count
FROM transactions
GROUP BY isFraud;

-- Fraud percentage
SELECT 
    ROUND(
        (SUM(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
    ) AS fraud_percentage
FROM transactions;

-- Count transactions by type
SELECT type, COUNT(*) AS count
FROM transactions
GROUP BY type
ORDER BY count DESC;

-- Fraud by transaction type
SELECT type, COUNT(*) AS fraud_count
FROM transactions
WHERE isFraud = 1
GROUP BY type
ORDER BY fraud_count DESC;

-- Total fraud amount
SELECT SUM(amount) AS total_fraud_amount
FROM transactions
WHERE isFraud = 1;

-- Average fraud amount by type
SELECT type, ROUND(AVG(amount), 2) AS avg_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY type
ORDER BY avg_fraud_amount DESC;

-- High-value transactions that are NOT marked as fraud
SELECT *
FROM transactions
WHERE amount > 100000 AND isFraud = 0
ORDER BY amount DESC
LIMIT 20;

-- Multiple transactions from same account within short time (possible fraud ring)
SELECT nameOrig, COUNT(*) AS txn_count
FROM transactions
GROUP BY nameOrig
HAVING txn_count > 10
ORDER BY txn_count DESC;

-- Accounts receiving most fraud transactions
SELECT nameDest, COUNT(*) AS fraud_received
FROM transactions
WHERE isFraud = 1
GROUP BY nameDest
ORDER BY fraud_received DESC
LIMIT 20;

-- Calculate total transactions, fraud count, and fraud percentage per transaction type
SELECT type,
       COUNT(*) AS total_transactions,
       SUM(isFraud) AS total_fraud,
       ROUND(SUM(isFraud) / COUNT(*) * 100, 2) AS fraud_percentage
FROM transactions
GROUP BY type
ORDER BY fraud_percentage DESC;

-- Retrieve the top 10 largest fraudulent transactions by amount
SELECT type, amount, nameOrig, nameDest
FROM transactions
WHERE isFraud = 1
ORDER BY amount DESC
LIMIT 10;

-- Count total and fraudulent transactions for each day of the week
SELECT DAYNAME(transaction_date) AS day_of_week,
       COUNT(*) AS total_transactions,
       SUM(isFraud) AS total_fraud
FROM transactions
GROUP BY day_of_week
ORDER BY total_fraud DESC;

-- Find accounts that initiated more than one fraud transaction
SELECT nameOrig,
       COUNT(*) AS fraud_count,
       SUM(amount) AS total_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY nameOrig
HAVING fraud_count > 1
ORDER BY total_fraud_amount DESC
LIMIT 10;

-- Categorize transactions into amount ranges and count frauds in each range
SELECT CASE
         WHEN amount < 1000 THEN 'Low (< 1K)'
         WHEN amount BETWEEN 1000 AND 10000 THEN 'Medium (1K-10K)'
         WHEN amount BETWEEN 10000 AND 50000 THEN 'High (10K-50K)'
         ELSE 'Very High (> 50K)'
       END AS amount_bracket,
       COUNT(*) AS total_transactions,
       SUM(isFraud) AS total_fraud
FROM transactions
GROUP BY amount_bracket
ORDER BY total_fraud DESC;

