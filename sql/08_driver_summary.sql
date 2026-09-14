-- ============================================================
-- File: 08_driver_summary.sql
-- Project: Budget Performance & Variance Analysis
--
-- Purpose:
-- Creates a consolidated management view of the Top 5
-- unfavorable variance drivers, including worst region,
-- worst month, transaction volume, issue rate and average
-- variance per transaction.
--
-- Key SQL concepts:
-- CTEs, JOINs, aggregation, analytical views
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_driver_summary` AS

SELECT
  d.department,
  d.category,
  d.variance,
  r.region AS worst_region,
  m.month AS worst_month,
  d.transactions,
  d.issue_pct,
  d.avg_variance_per_transaction

FROM `budget-variance-portfolio.budget_controlling.vw_top5_drivers` d

LEFT JOIN `budget-variance-portfolio.budget_controlling.vw_driver_regions` r
  ON d.department = r.department
  AND d.category = r.category
  AND r.region_rank = 1

LEFT JOIN `budget-variance-portfolio.budget_controlling.vw_driver_months` m
  ON d.department = m.department
  AND d.category = m.category
  AND m.month_rank = 1;

  SELECT *
FROM `budget-variance-portfolio.budget_controlling.vw_driver_summary`
ORDER BY variance ASC;
