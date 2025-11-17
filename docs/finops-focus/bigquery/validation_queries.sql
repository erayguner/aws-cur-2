-- ============================================================================
-- AWS CUR to FOCUS Validation Queries
-- ============================================================================
-- Description: Comprehensive validation queries to ensure data quality and
--              accuracy of the FOCUS transformation
-- Version: 1.0
-- Last Updated: 2025-11-17
-- ============================================================================

-- ============================================================================
-- SECTION 1: BASIC DATA QUALITY CHECKS
-- ============================================================================

-- Query 1.1: Row Count Comparison
-- Validates that no rows were lost in transformation
SELECT 
  'Row Count Check' AS validation_check,
  (SELECT COUNT(*) FROM `project.dataset.aws_cur_raw`) AS source_rows,
  (SELECT COUNT(*) FROM `project.dataset.aws_cur_focus`) AS focus_rows,
  CASE 
    WHEN (SELECT COUNT(*) FROM `project.dataset.aws_cur_raw`) = 
         (SELECT COUNT(*) FROM `project.dataset.aws_cur_focus`)
    THEN '✓ PASS'
    ELSE '✗ FAIL'
  END AS status;

-- Query 1.2: Cost Reconciliation
-- Ensures total costs match within acceptable variance (< 0.01%)
WITH source AS (
  SELECT SUM(line_item_unblended_cost) AS total FROM `project.dataset.aws_cur_raw`
),
focus AS (
  SELECT SUM(BilledCost) AS total FROM `project.dataset.aws_cur_focus`
)
SELECT 
  'Cost Reconciliation' AS validation_check,
  ROUND(source.total, 2) AS source_total_cost,
  ROUND(focus.total, 2) AS focus_total_cost,
  ROUND(source.total - focus.total, 2) AS difference,
  ROUND(ABS(source.total - focus.total) / NULLIF(source.total, 0) * 100, 6) AS percent_variance,
  CASE 
    WHEN ABS(source.total - focus.total) / NULLIF(source.total, 0) < 0.0001
    THEN '✓ PASS'
    ELSE '✗ FAIL'
  END AS status
FROM source, focus;

-- Query 1.3: Required Fields Check
-- Validates that FOCUS required fields are never NULL
SELECT
  'Required Fields Check' AS validation_check,
  COUNT(*) AS total_rows,
  COUNTIF(BilledCost IS NULL) AS null_billed_cost,
  COUNTIF(ChargeCategory IS NULL) AS null_charge_category,
  COUNTIF(ChargeDescription IS NULL) AS null_charge_description,
  COUNTIF(BillingCurrency IS NULL) AS null_billing_currency,
  COUNTIF(BillingPeriodStart IS NULL) AS null_billing_start,
  COUNTIF(BillingPeriodEnd IS NULL) AS null_billing_end,
  CASE
    WHEN COUNTIF(
      BilledCost IS NULL OR
      ChargeCategory IS NULL OR
      ChargeDescription IS NULL OR
      BillingCurrency IS NULL OR
      BillingPeriodStart IS NULL OR
      BillingPeriodEnd IS NULL
    ) = 0
    THEN '✓ PASS'
    ELSE '✗ FAIL'
  END AS status
FROM `project.dataset.aws_cur_focus`;

-- Query 1.4: Data Type Validation
-- Ensures all fields have correct data types
SELECT
  'Data Type Validation' AS validation_check,
  COUNTIF(SAFE_CAST(BilledCost AS NUMERIC) IS NULL) AS invalid_billed_cost,
  COUNTIF(SAFE_CAST(EffectiveCost AS NUMERIC) IS NULL) AS invalid_effective_cost,
  COUNTIF(SAFE_CAST(ListCost AS NUMERIC) IS NULL) AS invalid_list_cost,
  COUNTIF(SAFE_CAST(BillingPeriodStart AS TIMESTAMP) IS NULL) AS invalid_billing_start,
  COUNTIF(LENGTH(BillingCurrency) != 3) AS invalid_currency_code,
  CASE
    WHEN COUNTIF(
      SAFE_CAST(BilledCost AS NUMERIC) IS NULL OR
      SAFE_CAST(BillingPeriodStart AS TIMESTAMP) IS NULL OR
      LENGTH(BillingCurrency) != 3
    ) = 0
    THEN '✓ PASS'
    ELSE '✗ FAIL'
  END AS status
FROM `project.dataset.aws_cur_focus`;

-- ============================================================================
-- SECTION 2: BUSINESS LOGIC VALIDATION
-- ============================================================================

-- Query 2.1: ChargeCategory Distribution
-- Validates ChargeCategory mapping is working correctly
SELECT
  'ChargeCategory Distribution' AS validation_check,
  ChargeCategory,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(BilledCost) * 100.0 / SUM(SUM(BilledCost)) OVER(), 2) AS cost_percentage
FROM `project.dataset.aws_cur_focus`
GROUP BY ChargeCategory
ORDER BY total_cost DESC;

-- Query 2.2: ChargeClass Validation
-- Ensures ChargeClass is only 'Correction' or NULL
SELECT
  'ChargeClass Validation' AS validation_check,
  ChargeClass,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
GROUP BY ChargeClass;

-- Query 2.3: PricingCategory Distribution
-- Validates pricing model classification
SELECT
  'PricingCategory Distribution' AS validation_check,
  PricingCategory,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(AVG(ContractedUnitPrice), 4) AS avg_unit_price
FROM `project.dataset.aws_cur_focus`
GROUP BY PricingCategory
ORDER BY total_cost DESC;

-- Query 2.4: ServiceCategory Coverage
-- Checks how many services are mapped vs unmapped
WITH service_mapping AS (
  SELECT
    ServiceName,
    ServiceCategory,
    COUNT(*) AS usage_count,
    SUM(BilledCost) AS total_cost
  FROM `project.dataset.aws_cur_focus`
  GROUP BY ServiceName, ServiceCategory
)
SELECT
  'ServiceCategory Coverage' AS validation_check,
  COUNTIF(ServiceCategory != 'Other') AS mapped_services,
  COUNTIF(ServiceCategory = 'Other') AS unmapped_services,
  ROUND(SUM(CASE WHEN ServiceCategory != 'Other' THEN total_cost ELSE 0 END), 2) AS mapped_cost,
  ROUND(SUM(CASE WHEN ServiceCategory = 'Other' THEN total_cost ELSE 0 END), 2) AS unmapped_cost,
  ROUND(SUM(CASE WHEN ServiceCategory != 'Other' THEN total_cost ELSE 0 END) * 100.0 / SUM(total_cost), 2) AS mapped_cost_pct
FROM service_mapping;

-- Query 2.5: List Unmapped Services
-- Shows which services need ServiceCategory mapping
SELECT
  'Unmapped Services' AS validation_check,
  ServiceName,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
WHERE ServiceCategory = 'Other'
GROUP BY ServiceName
ORDER BY total_cost DESC
LIMIT 20;

-- ============================================================================
-- SECTION 3: COMMITMENT DISCOUNT VALIDATION
-- ============================================================================

-- Query 3.1: Commitment Discount Coverage
-- Validates RI and SP identification
SELECT
  'Commitment Discount Coverage' AS validation_check,
  CommitmentDiscountType,
  CommitmentDiscountStatus,
  COUNT(*) AS line_items,
  ROUND(SUM(BilledCost), 2) AS billed_cost,
  ROUND(SUM(EffectiveCost), 2) AS effective_cost,
  ROUND(SUM(BilledCost - EffectiveCost), 2) AS savings
FROM `project.dataset.aws_cur_focus`
WHERE CommitmentDiscountId IS NOT NULL
GROUP BY CommitmentDiscountType, CommitmentDiscountStatus
ORDER BY savings DESC;

-- Query 3.2: EffectiveCost vs BilledCost Comparison
-- Ensures EffectiveCost calculation is correct
SELECT
  'EffectiveCost Validation' AS validation_check,
  ROUND(SUM(BilledCost), 2) AS total_billed_cost,
  ROUND(SUM(EffectiveCost), 2) AS total_effective_cost,
  ROUND(SUM(BilledCost - EffectiveCost), 2) AS total_savings,
  ROUND((SUM(BilledCost - EffectiveCost) / NULLIF(SUM(BilledCost), 0)) * 100, 2) AS savings_percentage
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH);

-- Query 3.3: Commitment Discount ID Format
-- Validates ARN format for commitments
SELECT
  'Commitment ID Format' AS validation_check,
  CommitmentDiscountType,
  COUNT(*) AS total_count,
  COUNTIF(CommitmentDiscountId LIKE 'arn:aws:%') AS valid_arn_count,
  COUNTIF(CommitmentDiscountId NOT LIKE 'arn:aws:%') AS invalid_arn_count
FROM `project.dataset.aws_cur_focus`
WHERE CommitmentDiscountId IS NOT NULL
GROUP BY CommitmentDiscountType;

-- ============================================================================
-- SECTION 4: GEOGRAPHIC DATA VALIDATION
-- ============================================================================

-- Query 4.1: Region Coverage
-- Validates region mapping
SELECT
  'Region Coverage' AS validation_check,
  Region,
  RegionName,
  COUNT(DISTINCT ServiceName) AS service_count,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
WHERE Region IS NOT NULL
GROUP BY Region, RegionName
ORDER BY total_cost DESC
LIMIT 20;

-- Query 4.2: Global vs Regional Services
-- Checks distribution of global vs regional charges
SELECT
  'Global vs Regional' AS validation_check,
  CASE 
    WHEN Region IS NULL OR Region = '' THEN 'Global'
    ELSE 'Regional'
  END AS service_scope,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(BilledCost) * 100.0 / SUM(SUM(BilledCost)) OVER(), 2) AS cost_percentage
FROM `project.dataset.aws_cur_focus`
GROUP BY service_scope;

-- ============================================================================
-- SECTION 5: TAG DATA VALIDATION
-- ============================================================================

-- Query 5.1: Tag Coverage
-- Shows percentage of resources with tags
SELECT
  'Tag Coverage' AS validation_check,
  COUNT(*) AS total_resources,
  COUNTIF(Tags IS NOT NULL) AS tagged_resources,
  COUNTIF(Tags IS NULL) AS untagged_resources,
  ROUND(COUNTIF(Tags IS NOT NULL) * 100.0 / COUNT(*), 2) AS tag_coverage_pct,
  ROUND(SUM(CASE WHEN Tags IS NOT NULL THEN BilledCost ELSE 0 END), 2) AS tagged_cost,
  ROUND(SUM(CASE WHEN Tags IS NULL THEN BilledCost ELSE 0 END), 2) AS untagged_cost
FROM `project.dataset.aws_cur_focus`
WHERE ResourceId IS NOT NULL;

-- Query 5.2: ResourceName Extraction Success
-- Validates ResourceName extraction logic
SELECT
  'ResourceName Extraction' AS validation_check,
  COUNTIF(ResourceId IS NOT NULL) AS total_resources,
  COUNTIF(ResourceName IS NOT NULL) AS named_resources,
  COUNTIF(ResourceName IS NULL AND ResourceId IS NOT NULL) AS unnamed_resources,
  ROUND(COUNTIF(ResourceName IS NOT NULL) * 100.0 / NULLIF(COUNTIF(ResourceId IS NOT NULL), 0), 2) AS name_extraction_pct
FROM `project.dataset.aws_cur_focus`;

-- ============================================================================
-- SECTION 6: TIME-BASED VALIDATION
-- ============================================================================

-- Query 6.1: Billing Period Coverage
-- Shows data coverage by month
SELECT
  'Billing Period Coverage' AS validation_check,
  DATE_TRUNC(BillingPeriodStart, MONTH) AS billing_month,
  COUNT(*) AS row_count,
  COUNT(DISTINCT SubAccountId) AS account_count,
  COUNT(DISTINCT ServiceName) AS service_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
GROUP BY billing_month
ORDER BY billing_month DESC
LIMIT 12;

-- Query 6.2: Charge Period Validation
-- Ensures ChargePeriodStart <= ChargePeriodEnd
SELECT
  'Charge Period Validation' AS validation_check,
  COUNTIF(ChargePeriodStart > ChargePeriodEnd) AS invalid_periods,
  CASE
    WHEN COUNTIF(ChargePeriodStart > ChargePeriodEnd) = 0
    THEN '✓ PASS'
    ELSE '✗ FAIL'
  END AS status
FROM `project.dataset.aws_cur_focus`;

-- ============================================================================
-- SECTION 7: ACCOUNT DATA VALIDATION
-- ============================================================================

-- Query 7.1: Account Hierarchy
-- Validates billing account structure
SELECT
  'Account Hierarchy' AS validation_check,
  BillingAccountId,
  BillingAccountName,
  COUNT(DISTINCT SubAccountId) AS linked_account_count,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
GROUP BY BillingAccountId, BillingAccountName
ORDER BY total_cost DESC;

-- Query 7.2: SubAccount Distribution
-- Shows cost distribution across accounts
SELECT
  'SubAccount Distribution' AS validation_check,
  SubAccountId,
  SubAccountName,
  COUNT(DISTINCT ServiceName) AS service_count,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(EffectiveCost), 2) AS effective_cost,
  ROUND(SUM(BilledCost - EffectiveCost), 2) AS savings
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
GROUP BY SubAccountId, SubAccountName
ORDER BY total_cost DESC
LIMIT 20;

-- ============================================================================
-- SECTION 8: SUMMARY REPORT
-- ============================================================================

-- Query 8.1: Overall Data Quality Summary
WITH validation_summary AS (
  SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT BillingPeriodStart) AS billing_periods,
    COUNT(DISTINCT SubAccountId) AS accounts,
    COUNT(DISTINCT ServiceName) AS services,
    ROUND(SUM(BilledCost), 2) AS total_billed_cost,
    ROUND(SUM(EffectiveCost), 2) AS total_effective_cost,
    ROUND(SUM(ListCost), 2) AS total_list_cost,
    COUNTIF(BilledCost IS NULL OR ChargeCategory IS NULL) AS null_required_fields,
    COUNTIF(CommitmentDiscountId IS NOT NULL) AS commitment_rows,
    COUNTIF(Tags IS NOT NULL) AS tagged_rows
  FROM `project.dataset.aws_cur_focus`
)
SELECT
  'Overall Summary' AS validation_check,
  *,
  ROUND(commitment_rows * 100.0 / total_rows, 2) AS commitment_coverage_pct,
  ROUND(tagged_rows * 100.0 / total_rows, 2) AS tag_coverage_pct,
  ROUND((total_billed_cost - total_effective_cost) / NULLIF(total_billed_cost, 0) * 100, 2) AS savings_rate_pct
FROM validation_summary;

-- ============================================================================
-- SECTION 9: AWS-SPECIFIC EXTENSION VALIDATION
-- ============================================================================

-- Query 9.1: AWS Extension Fields
-- Validates x_* fields are populated
SELECT
  'AWS Extension Fields' AS validation_check,
  COUNTIF(x_Operation IS NOT NULL) AS has_operation,
  COUNTIF(x_UsageType IS NOT NULL) AS has_usage_type,
  COUNTIF(x_ServiceCode IS NOT NULL) AS has_service_code,
  COUNTIF(x_LineItemId IS NOT NULL) AS has_line_item_id,
  COUNT(*) AS total_rows
FROM `project.dataset.aws_cur_focus`;

-- ============================================================================
-- END OF VALIDATION QUERIES
-- ============================================================================

-- To run all validations at once, execute this file in BigQuery.
-- Review any FAIL statuses and investigate root causes.
