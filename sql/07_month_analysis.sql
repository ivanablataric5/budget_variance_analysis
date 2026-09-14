-- ============================================================
-- File: 07_month_analysis.sql
-- Project: Budget Performance & Variance Analysis

-- Purpose: Analyzes monthly variance patterns and identifies
-- the worst-performing month for each Department × Category driver.
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_driver_months` AS

WITH monthly AS (

  SELECT
    department,
    category,
    month,
    SUM(budget_amount) AS budget,
    SUM(actual_amount) AS actual,
    SUM(variance) AS variance,
    SAFE_DIVIDE(
      SUM(variance),
      SUM(budget_amount)
    ) AS variance_pct,
    COUNT(*) AS transactions

  FROM `budget-variance-portfolio.budget_controlling.stg_budget_actual`

  GROUP BY
    department,
    category,
    month
),

ranked AS (

  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY department, category
      ORDER BY variance ASC
    ) AS month_rank

  FROM monthly
)

SELECT *
FROM ranked;


SELECT
  department,
  category,
  month AS worst_month,
  variance AS monthly_variance
FROM `budget-variance-portfolio.budget_controlling.vw_driver_months`
WHERE month_rank = 1
ORDER BY monthly_variance ASC;