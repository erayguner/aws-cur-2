-- ============================================================================
-- Unified Multi-Cloud FOCUS - Sample Analytical Queries
-- ============================================================================
-- Description: Curated collection of analytical queries for multi-cloud
--              cost analysis using the unified FOCUS view
-- Version: 1.0.0
-- Last Updated: 2025-11-17
-- ============================================================================

-- ----------------------------------------------------------------------------
-- QUERY 1: Total Cost by Provider (Current Month)
-- ----------------------------------------------------------------------------
-- Purpose: Compare total spending across cloud providers for the current month
-- Use Case: Executive dashboard, monthly cloud cost review
-- Performance: Fast (uses partition filter and clustering)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  SUM(BilledCost) AS TotalBilledCost,
  SUM(EffectiveCost) AS TotalEffectiveCost,
  SUM(ListCost) AS TotalListCost,
  SUM(ListCost - EffectiveCost) AS TotalSavings,
  ROUND((SUM(ListCost - EffectiveCost) / SUM(ListCost)) * 100, 2) AS SavingsPercentage,
  COUNT(DISTINCT SubAccountId) AS NumberOfAccounts,
  COUNT(DISTINCT ServiceName) AS NumberOfServices
FROM `your-project.finops.unified_focus_materialized`
WHERE DATE(ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY ProviderName
ORDER BY TotalBilledCost DESC;

-- ----------------------------------------------------------------------------
-- QUERY 2: Month-over-Month Cost Comparison by Provider
-- ----------------------------------------------------------------------------
-- Purpose: Identify cost trends and growth rates by provider
-- Use Case: Monthly business review, budget forecasting
-- Performance: Medium (uses monthly summary table)
-- ----------------------------------------------------------------------------

WITH monthly_costs AS (
  SELECT
    ProviderName,
    ChargeMonth,
    MonthlyBilledCost,
    LAG(MonthlyBilledCost) OVER (PARTITION BY ProviderName ORDER BY ChargeMonth) AS PreviousMonthCost
  FROM `your-project.finops.unified_focus_monthly_summary`
  WHERE ChargeMonth >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 6 MONTH)
)
SELECT
  ProviderName,
  ChargeMonth,
  MonthlyBilledCost AS CurrentMonthCost,
  PreviousMonthCost,
  MonthlyBilledCost - PreviousMonthCost AS CostChange,
  ROUND(((MonthlyBilledCost - PreviousMonthCost) / NULLIF(PreviousMonthCost, 0)) * 100, 2) AS PercentageChange
FROM monthly_costs
WHERE PreviousMonthCost IS NOT NULL
ORDER BY ProviderName, ChargeMonth DESC;

-- ----------------------------------------------------------------------------
-- QUERY 3: Compute Cost Comparison Across Providers
-- ----------------------------------------------------------------------------
-- Purpose: Compare compute spending and identify optimization opportunities
-- Use Case: Infrastructure cost optimization, right-sizing analysis
-- Performance: Fast (filtered by ServiceCategory cluster column)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  ServiceName,
  SUM(EffectiveCost) AS ComputeCost,
  SUM(UsageQuantity) AS TotalUsage,
  ROUND(SUM(EffectiveCost) / NULLIF(SUM(UsageQuantity), 0), 4) AS CostPerUnit,
  COUNT(DISTINCT ResourceId) AS UniqueResources,
  -- Cost breakdown
  ROUND((SUM(EffectiveCost) / SUM(SUM(EffectiveCost)) OVER (PARTITION BY ProviderName)) * 100, 2) AS PercentOfProviderCost
FROM `your-project.finops.unified_focus_materialized`
WHERE ServiceCategory = 'Compute'
  AND DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY ProviderName, ServiceName
ORDER BY ProviderName, ComputeCost DESC;

-- ----------------------------------------------------------------------------
-- QUERY 4: Storage Cost Analysis by Type and Provider
-- ----------------------------------------------------------------------------
-- Purpose: Analyze storage costs and identify right-sizing opportunities
-- Use Case: Storage optimization, cost reduction initiatives
-- Performance: Fast (filtered by ServiceCategory)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  ServiceName,
  Region,
  SUM(EffectiveCost) AS StorageCost,
  SUM(UsageQuantity) AS TotalStorageGB,
  ROUND(SUM(EffectiveCost) / NULLIF(SUM(UsageQuantity), 0), 4) AS CostPerGB,
  COUNT(DISTINCT ResourceId) AS NumberOfStorageResources,
  -- Month-over-month growth
  SUM(CASE WHEN DATE(ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH) THEN EffectiveCost ELSE 0 END) AS CurrentMonthCost,
  SUM(CASE WHEN DATE(ChargePeriodStart) >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH)
               AND DATE(ChargePeriodStart) < DATE_TRUNC(CURRENT_DATE(), MONTH) 
           THEN EffectiveCost ELSE 0 END) AS PreviousMonthCost
FROM `your-project.finops.unified_focus_materialized`
WHERE ServiceCategory = 'Storage'
  AND DATE(ChargePeriodStart) >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH)
GROUP BY ProviderName, ServiceName, Region
HAVING StorageCost > 100  -- Filter to significant costs only
ORDER BY StorageCost DESC
LIMIT 50;

-- ----------------------------------------------------------------------------
-- QUERY 5: Commitment Discount Analysis (RI/Savings Plans/CUDs)
-- ----------------------------------------------------------------------------
-- Purpose: Analyze Reserved Instance and Savings Plan utilization and savings
-- Use Case: Commitment optimization, capacity planning
-- Performance: Medium (filters on ChargeClass)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  CommitmentDiscountType,
  CommitmentDiscountStatus,
  COUNT(DISTINCT CommitmentDiscountId) AS NumberOfCommitments,
  SUM(ContractedCost) AS TotalCommittedAmount,
  SUM(EffectiveCost) AS ActualUsage,
  SUM(ListCost - EffectiveCost) AS TotalSavings,
  ROUND((SUM(EffectiveCost) / NULLIF(SUM(ContractedCost), 0)) * 100, 2) AS UtilizationPercentage,
  ROUND((SUM(ListCost - EffectiveCost) / NULLIF(SUM(ListCost), 0)) * 100, 2) AS SavingsPercentage
FROM `your-project.finops.unified_focus_materialized`
WHERE ChargeClass = 'Commitment'
  AND DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY ProviderName, CommitmentDiscountType, CommitmentDiscountStatus
ORDER BY ProviderName, TotalSavings DESC;

-- ----------------------------------------------------------------------------
-- QUERY 6: Multi-Cloud Spend by Team (Tag-based Chargeback)
-- ----------------------------------------------------------------------------
-- Purpose: Allocate costs to teams based on tagging across all clouds
-- Use Case: Chargeback/showback, team budgets
-- Performance: Medium (requires JSON extraction)
-- ----------------------------------------------------------------------------

SELECT
  JSON_EXTRACT_SCALAR(Tags, '$.Team') AS Team,
  JSON_EXTRACT_SCALAR(Tags, '$.Environment') AS Environment,
  ProviderName,
  ServiceCategory,
  SUM(BilledCost) AS TeamSpend,
  COUNT(DISTINCT ResourceId) AS ResourceCount,
  -- Cost breakdown by provider
  ROUND((SUM(BilledCost) / SUM(SUM(BilledCost)) OVER (PARTITION BY JSON_EXTRACT_SCALAR(Tags, '$.Team'))) * 100, 2) AS PercentOfTeamBudget
FROM `your-project.finops.unified_focus_materialized`
WHERE JSON_EXTRACT_SCALAR(Tags, '$.Team') IS NOT NULL
  AND DATE(ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY Team, Environment, ProviderName, ServiceCategory
HAVING TeamSpend > 10  -- Filter small costs
ORDER BY Team, TeamSpend DESC;

-- ----------------------------------------------------------------------------
-- QUERY 7: Top 20 Most Expensive Resources Across All Clouds
-- ----------------------------------------------------------------------------
-- Purpose: Identify highest-cost resources for optimization
-- Use Case: Cost optimization, resource right-sizing
-- Performance: Medium (full table scan, but filtered by date)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  ServiceName,
  ResourceId,
  ResourceName,
  ResourceType,
  Region,
  SubAccountName,
  SUM(EffectiveCost) AS ResourceCost,
  JSON_EXTRACT_SCALAR(Tags, '$.Name') AS ResourceTagName,
  JSON_EXTRACT_SCALAR(Tags, '$.Owner') AS Owner,
  JSON_EXTRACT_SCALAR(Tags, '$.Environment') AS Environment
FROM `your-project.finops.unified_focus_materialized`
WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND ResourceId IS NOT NULL
GROUP BY ProviderName, ServiceName, ResourceId, ResourceName, ResourceType, Region, SubAccountName, Tags
ORDER BY ResourceCost DESC
LIMIT 20;

-- ----------------------------------------------------------------------------
-- QUERY 8: Daily Cost Trend (Last 90 Days) by Provider
-- ----------------------------------------------------------------------------
-- Purpose: Visualize daily spending trends across providers
-- Use Case: Anomaly detection, trend analysis
-- Performance: Fast (uses daily summary table)
-- ----------------------------------------------------------------------------

SELECT
  ChargeDate,
  ProviderName,
  SUM(DailyBilledCost) AS DailyCost,
  -- 7-day moving average
  AVG(SUM(DailyBilledCost)) OVER (
    PARTITION BY ProviderName 
    ORDER BY ChargeDate 
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS SevenDayAverage,
  -- Day-over-day change
  SUM(DailyBilledCost) - LAG(SUM(DailyBilledCost)) OVER (PARTITION BY ProviderName ORDER BY ChargeDate) AS DayOverDayChange
FROM `your-project.finops.unified_focus_daily_summary`
WHERE ChargeDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
GROUP BY ChargeDate, ProviderName
ORDER BY ProviderName, ChargeDate DESC;

-- ----------------------------------------------------------------------------
-- QUERY 9: Service Category Breakdown by Provider
-- ----------------------------------------------------------------------------
-- Purpose: Understand cost distribution across service categories
-- Use Case: Portfolio analysis, cost allocation
-- Performance: Fast (uses clustering)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  ServiceCategory,
  SUM(EffectiveCost) AS CategoryCost,
  COUNT(DISTINCT ServiceName) AS NumberOfServices,
  COUNT(DISTINCT ResourceId) AS NumberOfResources,
  -- Percentage of total provider cost
  ROUND((SUM(EffectiveCost) / SUM(SUM(EffectiveCost)) OVER (PARTITION BY ProviderName)) * 100, 2) AS PercentOfProviderCost,
  -- Average daily cost
  SUM(EffectiveCost) / COUNT(DISTINCT DATE(ChargePeriodStart)) AS AvgDailyCost
FROM `your-project.finops.unified_focus_materialized`
WHERE DATE(ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY ProviderName, ServiceCategory
ORDER BY ProviderName, CategoryCost DESC;

-- ----------------------------------------------------------------------------
-- QUERY 10: Regional Cost Distribution
-- ----------------------------------------------------------------------------
-- Purpose: Analyze costs by geographic region across providers
-- Use Case: Multi-region strategy, data residency compliance
-- Performance: Fast (Region is clustered)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  Region,
  ServiceCategory,
  SUM(EffectiveCost) AS RegionalCost,
  COUNT(DISTINCT ResourceId) AS ResourceCount,
  -- Top service in this region
  ARRAY_AGG(STRUCT(ServiceName, SUM(EffectiveCost) AS ServiceCost) ORDER BY SUM(EffectiveCost) DESC LIMIT 1)[OFFSET(0)] AS TopService
FROM `your-project.finops.unified_focus_materialized`
WHERE DATE(ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
  AND Region IS NOT NULL
GROUP BY ProviderName, Region, ServiceCategory
HAVING RegionalCost > 50
ORDER BY RegionalCost DESC
LIMIT 50;

-- ----------------------------------------------------------------------------
-- QUERY 11: Untagged Resources Report
-- ----------------------------------------------------------------------------
-- Purpose: Identify resources without proper tagging for governance
-- Use Case: Tag compliance, cost allocation improvement
-- Performance: Medium (requires tag inspection)
-- ----------------------------------------------------------------------------

SELECT
  ProviderName,
  ServiceCategory,
  ServiceName,
  SubAccountName,
  COUNT(DISTINCT ResourceId) AS UntaggedResources,
  SUM(EffectiveCost) AS UntaggedCost,
  ROUND((SUM(EffectiveCost) / SUM(SUM(EffectiveCost)) OVER ()) * 100, 2) AS PercentOfTotalCost
FROM `your-project.finops.unified_focus_materialized`
WHERE DATE(ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
  AND (Tags IS NULL 
       OR JSON_EXTRACT_SCALAR(Tags, '$.Team') IS NULL
       OR JSON_EXTRACT_SCALAR(Tags, '$.Environment') IS NULL
       OR JSON_EXTRACT_SCALAR(Tags, '$.Owner') IS NULL)
  AND ResourceId IS NOT NULL
GROUP BY ProviderName, ServiceCategory, ServiceName, SubAccountName
HAVING UntaggedCost > 100
ORDER BY UntaggedCost DESC;

-- ----------------------------------------------------------------------------
-- QUERY 12: Cross-Cloud Equivalent Service Cost Comparison
-- ----------------------------------------------------------------------------
-- Purpose: Compare costs of equivalent services across AWS and GCP
-- Use Case: Cloud migration planning, vendor negotiation
-- Performance: Medium (requires service mapping join)
-- ----------------------------------------------------------------------------

WITH normalized_costs AS (
  SELECT
    uf.ProviderName,
    sm.NormalizedServiceName,
    sm.ServiceCategory,
    SUM(uf.EffectiveCost) AS ServiceCost,
    COUNT(DISTINCT uf.ResourceId) AS ResourceCount
  FROM `your-project.finops.unified_focus_materialized` uf
  JOIN `your-project.finops.service_mapping` sm
    ON uf.ProviderName = sm.ProviderName
    AND uf.ServiceName = sm.OriginalServiceName
  WHERE DATE(uf.ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
    AND sm.NormalizedServiceName IS NOT NULL
  GROUP BY uf.ProviderName, sm.NormalizedServiceName, sm.ServiceCategory
)
SELECT
  NormalizedServiceName,
  ServiceCategory,
  MAX(CASE WHEN ProviderName = 'AWS' THEN ServiceCost END) AS AWS_Cost,
  MAX(CASE WHEN ProviderName = 'GCP' THEN ServiceCost END) AS GCP_Cost,
  MAX(CASE WHEN ProviderName = 'AWS' THEN ResourceCount END) AS AWS_Resources,
  MAX(CASE WHEN ProviderName = 'GCP' THEN ResourceCount END) AS GCP_Resources,
  -- Cost difference
  COALESCE(MAX(CASE WHEN ProviderName = 'AWS' THEN ServiceCost END), 0) - 
  COALESCE(MAX(CASE WHEN ProviderName = 'GCP' THEN ServiceCost END), 0) AS CostDifference
FROM normalized_costs
GROUP BY NormalizedServiceName, ServiceCategory
HAVING AWS_Cost IS NOT NULL OR GCP_Cost IS NOT NULL
ORDER BY COALESCE(AWS_Cost, 0) + COALESCE(GCP_Cost, 0) DESC;

-- ----------------------------------------------------------------------------
-- QUERY 13: Cost Anomaly Detection (Statistical Outliers)
-- ----------------------------------------------------------------------------
-- Purpose: Detect unusual spending patterns using statistical methods
-- Use Case: Cost anomaly alerts, fraud detection
-- Performance: Medium (uses window functions)
-- ----------------------------------------------------------------------------

WITH daily_costs AS (
  SELECT
    ProviderName,
    ServiceName,
    ChargeDate,
    DailyBilledCost,
    AVG(DailyBilledCost) OVER (PARTITION BY ProviderName, ServiceName) AS AvgCost,
    STDDEV(DailyBilledCost) OVER (PARTITION BY ProviderName, ServiceName) AS StdDevCost
  FROM `your-project.finops.unified_focus_daily_summary`
  WHERE ChargeDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
)
SELECT
  ProviderName,
  ServiceName,
  ChargeDate,
  DailyBilledCost,
  AvgCost,
  StdDevCost,
  -- Z-score (number of standard deviations from mean)
  ROUND((DailyBilledCost - AvgCost) / NULLIF(StdDevCost, 0), 2) AS ZScore,
  -- Percentage deviation from average
  ROUND(((DailyBilledCost - AvgCost) / NULLIF(AvgCost, 0)) * 100, 2) AS PercentDeviation
FROM daily_costs
WHERE ABS((DailyBilledCost - AvgCost) / NULLIF(StdDevCost, 0)) > 2  -- More than 2 std devs
  AND AvgCost > 10  -- Only for services with meaningful spend
ORDER BY ABS((DailyBilledCost - AvgCost) / NULLIF(StdDevCost, 0)) DESC
LIMIT 50;

-- ----------------------------------------------------------------------------
-- QUERY 14: Commitment Coverage Analysis
-- ----------------------------------------------------------------------------
-- Purpose: Measure what percentage of usage is covered by commitments
-- Use Case: Commitment purchase planning, optimization
-- Performance: Medium (requires multiple aggregations)
-- ----------------------------------------------------------------------------

WITH usage_breakdown AS (
  SELECT
    ProviderName,
    ServiceCategory,
    DATE_TRUNC(DATE(ChargePeriodStart), MONTH) AS ChargeMonth,
    SUM(CASE WHEN ChargeClass = 'Commitment' THEN EffectiveCost ELSE 0 END) AS CommitmentCost,
    SUM(CASE WHEN ChargeClass = 'On-Demand' THEN EffectiveCost ELSE 0 END) AS OnDemandCost,
    SUM(EffectiveCost) AS TotalCost
  FROM `your-project.finops.unified_focus_materialized`
  WHERE ServiceCategory IN ('Compute', 'Database')
    AND DATE(ChargePeriodStart) >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 6 MONTH)
  GROUP BY ProviderName, ServiceCategory, ChargeMonth
)
SELECT
  ProviderName,
  ServiceCategory,
  ChargeMonth,
  CommitmentCost,
  OnDemandCost,
  TotalCost,
  ROUND((CommitmentCost / NULLIF(TotalCost, 0)) * 100, 2) AS CommitmentCoveragePercent,
  ROUND((OnDemandCost / NULLIF(TotalCost, 0)) * 100, 2) AS OnDemandPercent,
  -- Potential additional commitment opportunity (30% of on-demand)
  ROUND(OnDemandCost * 0.30, 2) AS PotentialCommitmentAmount
FROM usage_breakdown
ORDER BY ProviderName, ServiceCategory, ChargeMonth DESC;

-- ----------------------------------------------------------------------------
-- QUERY 15: Year-over-Year Cost Comparison
-- ----------------------------------------------------------------------------
-- Purpose: Compare costs to same period last year for budgeting
-- Use Case: Annual planning, growth analysis
-- Performance: Medium (requires historical data)
-- ----------------------------------------------------------------------------

WITH yoy_costs AS (
  SELECT
    ProviderName,
    ServiceCategory,
    DATE_TRUNC(DATE(ChargePeriodStart), MONTH) AS ChargeMonth,
    SUM(EffectiveCost) AS MonthlyCost
  FROM `your-project.finops.unified_focus_materialized`
  WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 24 MONTH)
  GROUP BY ProviderName, ServiceCategory, ChargeMonth
)
SELECT
  current_year.ProviderName,
  current_year.ServiceCategory,
  current_year.ChargeMonth AS CurrentMonth,
  current_year.MonthlyCost AS CurrentYearCost,
  previous_year.MonthlyCost AS PreviousYearCost,
  current_year.MonthlyCost - previous_year.MonthlyCost AS YoYChange,
  ROUND(((current_year.MonthlyCost - previous_year.MonthlyCost) / NULLIF(previous_year.MonthlyCost, 0)) * 100, 2) AS YoYPercentChange
FROM yoy_costs current_year
LEFT JOIN yoy_costs previous_year
  ON current_year.ProviderName = previous_year.ProviderName
  AND current_year.ServiceCategory = previous_year.ServiceCategory
  AND current_year.ChargeMonth = DATE_ADD(previous_year.ChargeMonth, INTERVAL 12 MONTH)
WHERE current_year.ChargeMonth >= DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 6 MONTH)
  AND previous_year.MonthlyCost IS NOT NULL
ORDER BY current_year.ProviderName, current_year.ServiceCategory, current_year.ChargeMonth DESC;

-- ----------------------------------------------------------------------------
-- QUERY 16: Account/Project Cost Summary with Budget Tracking
-- ----------------------------------------------------------------------------
-- Purpose: Track spending by account/project against budgets
-- Use Case: Budget management, account governance
-- Performance: Fast (SubAccountId is clustered)
-- ----------------------------------------------------------------------------

-- Note: Budget table should be created separately with monthly budgets per account
-- CREATE TABLE `your-project.finops.account_budgets` (
--   SubAccountId STRING,
--   ChargeMonth DATE,
--   BudgetAmount FLOAT64
-- );

SELECT
  uf.ProviderName,
  uf.SubAccountId,
  uf.SubAccountName,
  DATE_TRUNC(DATE(uf.ChargePeriodStart), MONTH) AS ChargeMonth,
  SUM(uf.EffectiveCost) AS ActualSpend,
  -- Uncomment when budget table exists
  -- budget.BudgetAmount,
  -- SUM(uf.EffectiveCost) - budget.BudgetAmount AS BudgetVariance,
  -- ROUND((SUM(uf.EffectiveCost) / NULLIF(budget.BudgetAmount, 0)) * 100, 2) AS BudgetUtilizationPercent,
  COUNT(DISTINCT uf.ServiceName) AS ServicesUsed,
  COUNT(DISTINCT uf.ResourceId) AS ResourcesRunning
FROM `your-project.finops.unified_focus_materialized` uf
-- LEFT JOIN `your-project.finops.account_budgets` budget
--   ON uf.SubAccountId = budget.SubAccountId
--   AND DATE_TRUNC(DATE(uf.ChargePeriodStart), MONTH) = budget.ChargeMonth
WHERE DATE(uf.ChargePeriodStart) >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY uf.ProviderName, uf.SubAccountId, uf.SubAccountName, ChargeMonth
ORDER BY ActualSpend DESC;

-- ----------------------------------------------------------------------------
-- Query Performance Tips
-- ----------------------------------------------------------------------------
-- 
-- 1. Always include partition filter (DATE(ChargePeriodStart))
-- 2. Use clustered columns in WHERE clause (ProviderName, ServiceCategory, etc.)
-- 3. Use materialized table for dashboards
-- 4. Use summary tables for trend analysis
-- 5. Limit result sets with LIMIT clause
-- 6. Use APPROX_COUNT_DISTINCT for large cardinality dimensions
-- 7. Cache frequently used queries in Looker PDTs
-- 8. Monitor query costs in BigQuery console
--
-- ----------------------------------------------------------------------------
