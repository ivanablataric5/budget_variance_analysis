-- ============================================================
-- File: 05_pareto_analysis.sql
-- Project: Budget Performance & Variance Analysis
--
-- Purpose:
-- Ranks unfavorable Department × Category variance drivers
-- and calculates their individual and cumulative contribution
-- to total net unfavorable variance.
--
-- Key SQL concepts:
-- CTEs, RANK(), window functions, SAFE_DIVIDE
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_pareto_analysis` AS

WITH driver_analysis AS (
    SELECT
        department,
        category,
        variance,
        ABS(variance) AS abs_variance
    FROM `budget-variance-portfolio.budget_controlling.vw_driver_analysis`
),

total_variance AS (
    SELECT
        ABS(SUM(variance)) AS total_net_unfavorable_variance
    FROM driver_analysis
),

unfavorable AS (
    SELECT
        d.department,
        d.category,
        d.variance,
        d.abs_variance,
        t.total_net_unfavorable_variance
    FROM driver_analysis d
    CROSS JOIN total_variance t
    WHERE d.variance < 0
),

ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY abs_variance DESC) AS driver_rank,
        SAFE_DIVIDE(
            abs_variance,
            total_net_unfavorable_variance
        ) AS share_pct
    FROM unfavorable
)

SELECT
    driver_rank,
    department,
    category,
    variance,
    abs_variance,
    share_pct,
    SUM(share_pct) OVER (
        ORDER BY driver_rank
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_pct
FROM ranked
ORDER BY driver_rank;