-- ============================================================
-- File: 09_transaction_analysis.sql
-- Project: Budget Performance & Variance Analysis

-- Purpose: Provides transaction-level drill-down and ranks the largest
-- unfavorable transactions within each Department × Category driver.
-- ============================================================

CREATE OR REPLACE VIEW
`budget-variance-portfolio.budget_controlling.vw_driver_transactions` AS

SELECT
  department,
  category,
  transaction_id,
  transaction_date,
  region,
  payment_method,
  budget_amount,
  actual_amount,
  variance,

  ROW_NUMBER() OVER (
    PARTITION BY department, category
    ORDER BY variance ASC
  ) AS transaction_rank

FROM `budget-variance-portfolio.budget_controlling.stg_budget_actual`

WHERE variance < 0;

 
--check top 10 neg drivers for specific department and category
/*SELECT *
FROM `budget-variance-portfolio.budget_controlling.vw_driver_transactions`
WHERE department = 'Marketing'
  AND category = 'Training'
  AND transaction_rank <= 10
ORDER BY transaction_rank;*/
 

