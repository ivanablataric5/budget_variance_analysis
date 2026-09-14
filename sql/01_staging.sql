-- ============================================================
-- File: 01_staging.sql
-- Project: Budget Performance & Variance Analysis
-- Purpose: Creates a clean analytical layer from the raw data.
-- ============================================================


CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.stg_budget_actual` AS

SELECT
  CAST(Date AS DATE) AS transaction_date,
  Department AS department,
  Category AS category,
  Region AS region,
  CAST(`Budget Amount` AS NUMERIC) AS budget_amount,
  CAST(`Actual Amount` AS NUMERIC) AS actual_amount,

  CAST(`Budget Amount` AS NUMERIC)
    - CAST(`Actual Amount` AS NUMERIC) AS variance,

  SAFE_DIVIDE(
    CAST(`Budget Amount` AS NUMERIC)
      - CAST(`Actual Amount` AS NUMERIC),
    CAST(`Budget Amount` AS NUMERIC)
  ) AS variance_pct,

  `Payment Method` AS payment_method,
  `Transaction ID` AS transaction_id,

  FORMAT_DATE('%Y-%m', CAST(Date AS DATE)) AS month,

  CASE
    WHEN CAST(`Budget Amount` AS NUMERIC)
         - CAST(`Actual Amount` AS NUMERIC) < 0
    THEN 'Issue'
    ELSE 'Ok'
  END AS status

FROM
`budget-variance-portfolio.budget_controlling.raw_budget_actual`;

/*
SELECT *
FROM `budget-variance-portfolio.budget_controlling.stg_budget_actual`
LIMIT 20; */