-- ============================================================
-- File: 02_data_quality.sql
-- Project: Budget Performance & Variance Analysis
--
-- Purpose:
-- Performs data quality checks before analytical processing.
--
-- Checks:
-- - Row count
-- - Unique transaction IDs
-- - Duplicate transaction IDs
-- - Missing dates
-- - Missing dimensions
-- - Missing budget and actual values
-- ============================================================

SELECT
    COUNT(*) AS rows,
    COUNT(DISTINCT transaction_id) AS unique_transactions,

    COUNTIF(transaction_id IS NULL) AS null_transaction_id,
    COUNTIF(transaction_date IS NULL) AS null_date,
    COUNTIF(department IS NULL) AS null_department,
    COUNTIF(category IS NULL) AS null_category,
    COUNTIF(region IS NULL) AS null_region,
    COUNTIF(budget_amount IS NULL) AS null_budget,
    COUNTIF(actual_amount IS NULL) AS null_actual,

    COUNT(*) - COUNT(DISTINCT transaction_id)
        AS duplicate_transaction_ids

FROM
    `budget-variance-portfolio.budget_controlling.stg_budget_actual`;