-- ============================================================
-- File: 03_executive_kpis.sql
-- Project: Budget Performance & Variance Analysis
-- Purpose: Calculates management-level budget performance KPIs
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_executive_kpis` AS

SELECT
    SUM(budget_amount) AS total_budget,
    SUM(actual_amount) AS total_actual,
    SUM(variance) AS total_variance,

    SAFE_DIVIDE(
        SUM(variance),
        SUM(budget_amount)
    ) AS variance_pct,

    SAFE_DIVIDE(
        SUM(actual_amount),
        SUM(budget_amount)
    ) AS budget_utilization,

    COUNT(*) AS transactions,

    COUNTIF(status = 'Issue') AS issue_transactions,

    SAFE_DIVIDE(
        COUNTIF(status = 'Issue'),
        COUNT(*)
    ) AS issue_pct

FROM
`budget-variance-portfolio.budget_controlling.stg_budget_actual`;


--SELECT * FROM `budget-variance-portfolio.budget_controlling.vw_executive_kpis`;