-- ============================================================
-- File: 10_reconciliation.sql
-- Project: Budget Performance & Variance Analysis
--
-- Purpose:
-- Reconciles SQL analytical outputs with the original
-- Google Sheets analysis to validate consistency and accuracy
-- across both implementations.
--
-- Validation targets:
-- Total Budget
-- Total Actual
-- Total Variance
-- Variance %
-- Largest Variance Driver
-- Top 10 Driver Concentration
-- ============================================================

WITH overall AS (
  SELECT
    SUM(budget_amount) AS budget,
    SUM(actual_amount) AS actual,
    SUM(variance) AS variance,
    SAFE_DIVIDE(SUM(variance), SUM(budget_amount)) AS variance_pct
  FROM `budget-variance-portfolio.budget_controlling.stg_budget_actual`
),

top_driver AS (
  SELECT
    department,
    category,
    variance
  FROM `budget-variance-portfolio.budget_controlling.vw_driver_analysis`
  ORDER BY variance ASC
  LIMIT 1
),

top10 AS (
  SELECT
    MAX(cumulative_pct) AS top10_cumulative_pct
  FROM (
    SELECT *
    FROM (
      WITH unfavorable AS (
        SELECT
          variance,
          ABS(variance) AS abs_variance
        FROM `budget-variance-portfolio.budget_controlling.vw_driver_analysis`
        WHERE variance < 0
      )
      SELECT
        ROW_NUMBER() OVER (ORDER BY abs_variance DESC) AS rn,
        SUM(abs_variance) OVER (
          ORDER BY abs_variance DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) / SUM(abs_variance) OVER () AS cumulative_pct
      FROM unfavorable
    )
    WHERE rn <= 10
  )
)

SELECT
  o.budget,
  o.actual,
  o.variance,
  o.variance_pct,
  t.department AS top_driver_department,
  t.category AS top_driver_category,
  t.variance AS top_driver_variance,
  p.top10_cumulative_pct
FROM overall o
CROSS JOIN top_driver t
CROSS JOIN top10 p;