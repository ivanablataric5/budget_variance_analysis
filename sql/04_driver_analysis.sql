-- ============================================================
-- File: 04_driver_analysis.sql
-- Project: Budget Performance & Variance Analysis
-- Purpose: Aggregates performance by Department × Category to identify and quantify the main drivers of unfavorable budget variance.
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_driver_analysis` AS

SELECT
  department,
  category,
  SUM(budget_amount) AS budget,
  SUM(actual_amount) AS actual,
  SUM(variance) AS variance,
  SAFE_DIVIDE(SUM(variance), SUM(budget_amount)) AS variance_pct,
  COUNT(*) AS transactions,
  COUNTIF(status = 'Issue') AS issue_transactions,
  SAFE_DIVIDE(COUNTIF(status = 'Issue'), COUNT(*)) AS issue_pct,
  SAFE_DIVIDE(SUM(variance), COUNT(*)) AS avg_variance_per_transaction

FROM `budget-variance-portfolio.budget_controlling.stg_budget_actual`

GROUP BY
  department,
  category;


 /* SELECT *
FROM `budget-variance-portfolio.budget_controlling.vw_driver_analysis`
ORDER BY variance ASC
LIMIT 10;*/
