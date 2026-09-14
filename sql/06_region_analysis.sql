-- ============================================================
-- File: 06_region_analysis.sql
-- Project: Budget Performance & Variance Analysis
-- Purpose: Identifies the worst-performing region
--          for each Department × Category combination
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_driver_regions` AS

WITH regional AS (
    SELECT
        department,
        category,
        region,
        SUM(budget_amount) AS budget,
        SUM(actual_amount) AS actual,
        SUM(variance) AS variance,
        SAFE_DIVIDE(
            SUM(variance),
            SUM(budget_amount)
        ) AS variance_pct
    FROM
        `budget-variance-portfolio.budget_controlling.stg_budget_actual`
    GROUP BY
        department,
        category,
        region
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY department, category
            ORDER BY variance ASC
        ) AS region_rank
    FROM regional
)

SELECT *
FROM ranked;