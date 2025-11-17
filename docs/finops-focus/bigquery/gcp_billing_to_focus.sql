-- ============================================================================
-- GCP Billing Export to FOCUS 1.0/1.1/1.2 Transformation
-- ============================================================================
-- 
-- Purpose: Transform Google Cloud Platform billing export data into 
--          FinOps Open Cost and Usage Specification (FOCUS) format
-- 
-- Version: 1.0
-- Last Updated: 2025-11-17
-- FOCUS Compliance: v1.0, v1.1, v1.2
-- 
-- Prerequisites:
--   - GCP Detailed Billing Export enabled
--   - Data exported to BigQuery
--   - (Optional) Pricing Export enabled for ListCost accuracy
-- 
-- Usage:
--   1. Replace placeholders:
--      - your-project-id
--      - your-dataset-id
--      - your-billing-account-id
--   2. Adjust date range in WHERE clause as needed
--   3. Create as view or materialized table
--   4. Run validation queries to verify output
-- 
-- Performance Notes:
--   - Partitioned by ChargePeriodStart (DATE)
--   - Clustered by BillingAccountId, SubAccountId, ServiceName
--   - Recommended: Materialize for large datasets
-- 
-- ============================================================================

CREATE OR REPLACE VIEW `your-project-id.your-dataset-id.gcp_billing_focus_v1` AS

-- ============================================================================
-- Main Transformation Query
-- ============================================================================

WITH 

-- ----------------------------------------------------------------------------
-- CTE 1: Deduplicate billing data (handle export delays)
-- ----------------------------------------------------------------------------
deduplicated_billing AS (
  SELECT
    * EXCEPT(rn)
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY 
          billing_account_id,
          project.id,
          service.id,
          sku.id,
          usage_start_time,
          usage_end_time,
          cost_type,
          IFNULL(resource.global_name, '')
        ORDER BY export_time DESC  -- Keep latest export
      ) AS rn
    FROM `your-project-id.your-dataset-id.gcp_billing_export_resource_v1_YOUR_BILLING_ACCOUNT_ID`
    WHERE usage_start_time >= '2024-01-01'  -- Adjust date range as needed
  )
  WHERE rn = 1
),

-- ----------------------------------------------------------------------------
-- CTE 2: Calculate aggregated credits per row
-- ----------------------------------------------------------------------------
billing_with_credits AS (
  SELECT
    *,
    -- Total credits amount
    IFNULL(
      (SELECT SUM(c.amount) FROM UNNEST(credits) AS c),
      0
    ) AS total_credits,
    
    -- Credits by type
    IFNULL(
      (SELECT SUM(c.amount) FROM UNNEST(credits) AS c 
       WHERE c.type = 'COMMITTED_USAGE'),
      0
    ) AS committed_usage_credits,
    
    IFNULL(
      (SELECT SUM(c.amount) FROM UNNEST(credits) AS c 
       WHERE c.type = 'SUSTAINED_USAGE'),
      0
    ) AS sustained_usage_credits,
    
    IFNULL(
      (SELECT SUM(c.amount) FROM UNNEST(credits) AS c 
       WHERE c.type IN ('PROMOTION', 'FREE_TIER', 'DISCOUNT')),
      0
    ) AS promotional_credits,
    
    -- Extract commitment ID from credits
    (SELECT c.id FROM UNNEST(credits) AS c 
     WHERE c.type = 'COMMITTED_USAGE' LIMIT 1) AS credit_commitment_id
     
  FROM deduplicated_billing
),

-- ----------------------------------------------------------------------------
-- CTE 3: Identify commitment purchases and usage
-- ----------------------------------------------------------------------------
commitment_classified AS (
  SELECT
    *,
    
    -- Is this a CUD purchase?
    CASE
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment.*purchase')
        OR REGEXP_CONTAINS(LOWER(sku.description), r'committed use discount.*purchase')
        OR (REGEXP_CONTAINS(LOWER(sku.description), r'commitment') 
            AND REGEXP_CONTAINS(LOWER(sku.description), r'fee'))
      THEN TRUE
      ELSE FALSE
    END AS is_cud_purchase,
    
    -- Is this usage covered by CUD?
    CASE
      WHEN committed_usage_credits < 0  -- Credits are negative
      THEN TRUE
      ELSE FALSE
    END AS is_cud_covered_usage,
    
    -- Commitment identifier
    CASE
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment')
      THEN CONCAT('gcp-cud-', sku.id)
      WHEN committed_usage_credits < 0
      THEN CONCAT('gcp-cud-', IFNULL(credit_commitment_id, 'unknown'))
      ELSE NULL
    END AS commitment_discount_id,
    
    -- Commitment type
    CASE
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'cpu|compute.*commitment')
      THEN 'Compute'
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'memory|ram.*commitment')
      THEN 'Memory'
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'flexible|spend.*commitment')
      THEN 'Spend'
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment')
      THEN 'Resource'
      ELSE NULL
    END AS commitment_type
    
  FROM billing_with_credits
),

-- ----------------------------------------------------------------------------
-- CTE 4: Consolidate tags/labels
-- ----------------------------------------------------------------------------
billing_with_tags AS (
  SELECT
    b.*,
    
    -- Combine all labels into JSON format
    TO_JSON_STRING(
      ARRAY_CONCAT(
        -- Resource labels
        IFNULL(
          (SELECT ARRAY_AGG(STRUCT(label.key AS key, label.value AS value))
           FROM UNNEST(b.labels) AS label),
          []
        ),
        -- Project labels (prefixed)
        IFNULL(
          (SELECT ARRAY_AGG(STRUCT(CONCAT('project:', label.key) AS key, label.value AS value))
           FROM UNNEST(b.project.labels) AS label),
          []
        ),
        -- System labels (prefixed)
        IFNULL(
          (SELECT ARRAY_AGG(STRUCT(CONCAT('gcp-system:', label.key) AS key, label.value AS value))
           FROM UNNEST(b.system_labels) AS label),
          []
        )
      )
    ) AS consolidated_tags
    
  FROM commitment_classified AS b
)

-- ============================================================================
-- Final SELECT: Map to FOCUS Schema
-- ============================================================================

SELECT

  -- ==========================================================================
  -- ACCOUNT & IDENTITY
  -- ==========================================================================
  
  billing_account_id AS BillingAccountId,
  NULL AS BillingAccountName,  -- Not available in standard export
  'Standard' AS BillingAccountType,  -- GCP billing account type
  
  project.id AS SubAccountId,
  project.name AS SubAccountName,
  CASE 
    WHEN project.ancestry_numbers IS NOT NULL 
      AND ARRAY_LENGTH(SPLIT(project.ancestry_numbers, '/')) > 2
    THEN 'Folder'
    ELSE 'Project'
  END AS SubAccountType,
  
  -- ==========================================================================
  -- PROVIDER & PUBLISHER
  -- ==========================================================================
  
  'Google Cloud' AS Provider,
  'GCP' AS x_ProviderCode,  -- GCP-specific extension
  
  CASE 
    WHEN invoice.publisher_type = 'GOOGLE' THEN 'Google Cloud'
    WHEN invoice.publisher_type = 'PARTNER' THEN 'Google Cloud Marketplace'
    ELSE 'Google Cloud'
  END AS Publisher,
  
  invoice.publisher_type AS x_PublisherType,  -- GCP-specific
  
  -- ==========================================================================
  -- INVOICE & BILLING PERIOD
  -- ==========================================================================
  
  invoice.month AS x_InvoiceMonth,  -- GCP-specific (YYYYMM format)
  
  -- BillingPeriodStart: First day of invoice month
  PARSE_DATE('%Y%m', invoice.month) AS BillingPeriodStart,
  
  -- BillingPeriodEnd: First day of next month (exclusive)
  DATE_ADD(PARSE_DATE('%Y%m', invoice.month), INTERVAL 1 MONTH) AS BillingPeriodEnd,
  
  -- ==========================================================================
  -- CHARGE PERIOD (USAGE TIME)
  -- ==========================================================================
  
  -- ChargePeriodStart: Inclusive start of usage (hourly granularity)
  CAST(usage_start_time AS DATETIME) AS ChargePeriodStart,
  
  -- ChargePeriodEnd: Exclusive end of usage
  CAST(usage_end_time AS DATETIME) AS ChargePeriodEnd,
  
  -- ==========================================================================
  -- CURRENCY
  -- ==========================================================================
  
  currency AS BillingCurrency,
  
  -- ==========================================================================
  -- COST COLUMNS
  -- ==========================================================================
  
  -- BilledCost: What you actually pay (cost + credits)
  CAST(cost + total_credits AS DECIMAL(18, 6)) AS BilledCost,
  
  -- EffectiveCost: Amortized cost (cost + promotional credits only)
  -- Excludes automatic discounts (SUDs) for true amortization
  CAST(
    cost + promotional_credits
  AS DECIMAL(18, 6)) AS EffectiveCost,
  
  -- ListCost: Cost at list price (pre-discount)
  CAST(
    IFNULL(cost_at_list, cost) 
  AS DECIMAL(18, 6)) AS ListCost,
  
  -- ContractedCost: Cost with negotiated rates (already in 'cost')
  CAST(cost AS DECIMAL(18, 6)) AS ContractedCost,
  
  -- ListUnitPrice: Calculated from list cost and pricing quantity
  CASE
    WHEN usage.amount_in_pricing_units > 0
    THEN CAST(
      IFNULL(cost_at_list, cost) / usage.amount_in_pricing_units 
    AS DECIMAL(18, 6))
    ELSE NULL
  END AS ListUnitPrice,
  
  -- ContractedUnitPrice: Calculated from contracted cost
  CASE
    WHEN usage.amount_in_pricing_units > 0
    THEN CAST(cost / usage.amount_in_pricing_units AS DECIMAL(18, 6))
    ELSE NULL
  END AS ContractedUnitPrice,
  
  -- ==========================================================================
  -- CHARGE CLASSIFICATION
  -- ==========================================================================
  
  -- ChargeCategory: Nature of the charge
  CASE
    -- Tax charges
    WHEN cost_type = 'tax' THEN 'Tax'
    
    -- Adjustments
    WHEN cost_type IN ('adjustment', 'rounding error') THEN 'Adjustment'
    
    -- Credits (negative cost or credit entries)
    WHEN cost < 0 OR total_credits < 0 THEN 'Credit'
    
    -- Purchases (commitment purchases, support plans)
    WHEN is_cud_purchase THEN 'Purchase'
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'support')
      AND cost > 0 
      AND usage.amount = 1
    THEN 'Purchase'
    
    -- Usage (default)
    ELSE 'Usage'
  END AS ChargeCategory,
  
  -- ChargeClass: Corrections vs regular charges
  CASE
    WHEN adjustment_info IS NOT NULL 
      AND adjustment_info.mode = 'MANUAL_ADJUSTMENT'
      AND PARSE_DATE('%Y%m', invoice.month) > DATE(usage_start_time)
    THEN 'Correction'
    ELSE NULL  -- NULL for regular charges
  END AS ChargeClass,
  
  -- ChargeDescription: Detailed description
  sku.description AS ChargeDescription,
  
  -- ChargeFrequency: How often the charge occurs
  CASE
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment|subscription') 
    THEN 'Recurring'
    WHEN cost_type = 'regular' 
    THEN 'Usage-Based'
    ELSE 'One-Time'
  END AS ChargeFrequency,
  
  -- ==========================================================================
  -- PRICING
  -- ==========================================================================
  
  -- PricingCategory: Pricing model
  CASE
    -- Spot/Preemptible
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'preemptible|\bspot\b')
    THEN 'Spot'
    
    -- Committed
    WHEN is_cud_purchase OR is_cud_covered_usage
    THEN 'Committed'
    
    -- Dynamic (flexible CUD)
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'flexible')
    THEN 'Dynamic'
    
    -- On-Demand (default)
    ELSE 'On-Demand'
  END AS PricingCategory,
  
  -- PricingQuantity: Quantity used for pricing
  CAST(usage.amount_in_pricing_units AS DECIMAL(18, 6)) AS PricingQuantity,
  
  -- PricingUnit: Unit for pricing
  usage.pricing_unit AS PricingUnit,
  
  -- Pricing currency (same as billing for GCP)
  currency AS PricingCurrency,
  
  -- Pricing currency unit prices (same as above for GCP)
  CASE
    WHEN usage.amount_in_pricing_units > 0
    THEN CAST(
      IFNULL(cost_at_list, cost) / usage.amount_in_pricing_units 
    AS DECIMAL(18, 6))
    ELSE NULL
  END AS PricingCurrencyListUnitPrice,
  
  CASE
    WHEN usage.amount_in_pricing_units > 0
    THEN CAST(cost / usage.amount_in_pricing_units AS DECIMAL(18, 6))
    ELSE NULL
  END AS PricingCurrencyContractedUnitPrice,
  
  -- PricingCurrencyEffectiveCost: Same as EffectiveCost for GCP
  CAST(
    cost + promotional_credits
  AS DECIMAL(18, 6)) AS PricingCurrencyEffectiveCost,
  
  -- ==========================================================================
  -- USAGE / CONSUMPTION
  -- ==========================================================================
  
  -- ConsumedQuantity: Actual usage amount
  CAST(usage.amount AS DECIMAL(18, 6)) AS ConsumedQuantity,
  
  -- ConsumedUnit: Usage unit
  usage.unit AS ConsumedUnit,
  
  -- ==========================================================================
  -- SERVICE
  -- ==========================================================================
  
  -- ServiceName: Human-readable service name
  service.description AS ServiceName,
  
  -- ServiceCategory: High-level categorization
  CASE
    -- Compute
    WHEN service.description IN (
      'Compute Engine', 'Kubernetes Engine', 'Google Kubernetes Engine',
      'Cloud Run', 'Cloud Functions', 'App Engine', 
      'App Engine Flexible Environment', 'Cloud Composer'
    ) THEN 'Compute'
    
    -- Storage
    WHEN service.description IN (
      'Cloud Storage', 'Persistent Disk', 'Filestore', 
      'Cloud Storage for Firebase', 'Local SSD'
    ) THEN 'Storage'
    
    -- Database
    WHEN service.description IN (
      'Cloud SQL', 'Cloud Spanner', 'Cloud Bigtable', 'Firestore',
      'Firebase Realtime Database', 'Memorystore for Redis', 
      'Memorystore for Memcached', 'Cloud Datastore'
    ) THEN 'Database'
    
    -- Networking
    WHEN service.description IN (
      'Cloud Load Balancing', 'Cloud CDN', 'Cloud DNS', 'Cloud NAT',
      'Cloud VPN', 'Cloud Interconnect', 'Cloud Armor', 
      'Network Telemetry', 'Network Intelligence Center', 
      'Virtual Private Cloud'
    ) OR service.description LIKE '%Networking%'
    THEN 'Networking'
    
    -- Analytics
    WHEN service.description IN (
      'BigQuery', 'BigQuery Storage', 'BigQuery Data Transfer Service',
      'Dataflow', 'Dataproc', 'Cloud Pub/Sub', 'Cloud Data Fusion',
      'Cloud Dataprep', 'Looker', 'Looker Studio'
    ) THEN 'Analytics'
    
    -- Machine Learning
    WHEN service.description IN (
      'Vertex AI', 'AI Platform', 'AutoML', 'Cloud Natural Language',
      'Cloud Vision', 'Cloud Speech-to-Text', 'Cloud Text-to-Speech',
      'Cloud Translation', 'Dialogflow', 'Recommendations AI',
      'Cloud Inference API'
    ) OR service.description LIKE '%AI%' OR service.description LIKE '%ML%'
    THEN 'Machine Learning'
    
    -- Security
    WHEN service.description IN (
      'Cloud Key Management Service', 'Secret Manager', 
      'Security Command Center', 'Cloud Identity-Aware Proxy',
      'Cloud Armor', 'Binary Authorization', 
      'Certificate Authority Service', 'Cloud HSM'
    ) OR service.description LIKE '%Security%'
    THEN 'Security'
    
    -- Developer Tools
    WHEN service.description IN (
      'Cloud Build', 'Cloud Source Repositories', 'Artifact Registry',
      'Container Registry', 'Cloud Deploy', 'Cloud Code'
    ) THEN 'Developer Tools'
    
    -- Management & Monitoring
    WHEN service.description IN (
      'Cloud Logging', 'Cloud Monitoring', 'Cloud Trace',
      'Cloud Profiler', 'Cloud Debugger', 'Error Reporting'
    ) THEN 'Management & Monitoring'
    
    -- Support
    WHEN service.description LIKE '%Support%'
    THEN 'Support'
    
    -- Other
    ELSE 'Other'
  END AS ServiceCategory,
  
  -- ServiceSubcategory: More granular (optional, not populated for GCP)
  NULL AS ServiceSubcategory,
  
  -- ==========================================================================
  -- SKU
  -- ==========================================================================
  
  sku.id AS SkuId,
  sku.description AS x_SkuDescription,  -- GCP-specific
  
  -- SkuPriceId: Combination of SKU and pricing tier
  CONCAT(
    sku.id, 
    '-', 
    COALESCE(CAST(price.tier_start_amount AS STRING), '0')
  ) AS SkuPriceId,
  
  -- SkuMeter: Metering unit (optional)
  usage.pricing_unit AS SkuMeter,
  
  -- ==========================================================================
  -- RESOURCE
  -- ==========================================================================
  
  -- ResourceId: Globally unique identifier (detailed export only)
  resource.global_name AS ResourceId,
  
  -- ResourceName: Human-readable name
  resource.name AS ResourceName,
  
  -- ResourceType: Derived from SKU description
  CASE
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'n1|n2|e2|c2|m1|m2')
    THEN 'Instance'
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'disk')
    THEN 'Disk'
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'storage')
    THEN 'Storage'
    WHEN REGEXP_CONTAINS(LOWER(sku.description), r'network')
    THEN 'Network'
    ELSE 'Other'
  END AS ResourceType,
  
  -- ==========================================================================
  -- LOCATION
  -- ==========================================================================
  
  -- Region: Geographic region
  COALESCE(location.region, location.location) AS Region,
  
  -- RegionName: Human-readable region name (optional, not populated)
  NULL AS RegionName,
  
  -- AvailabilityZone: Zone identifier
  location.zone AS AvailabilityZone,
  
  -- Additional location fields (GCP-specific)
  location.country AS x_LocationCountry,
  location.location AS x_Location,
  
  -- ==========================================================================
  -- TAGS
  -- ==========================================================================
  
  consolidated_tags AS Tags,
  
  -- ==========================================================================
  -- COMMITMENT DISCOUNT
  -- ==========================================================================
  
  commitment_discount_id AS CommitmentDiscountId,
  
  CASE
    WHEN commitment_discount_id IS NOT NULL
    THEN sku.description
    ELSE NULL
  END AS CommitmentDiscountName,
  
  commitment_type AS CommitmentDiscountType,
  
  CASE
    WHEN commitment_discount_id IS NOT NULL THEN 'Used'
    ELSE NULL
  END AS CommitmentDiscountStatus,
  
  -- CommitmentDiscountQuantity: Not directly available in GCP
  NULL AS CommitmentDiscountQuantity,
  NULL AS CommitmentDiscountUnit,
  
  -- CommitmentDiscountCategory: Not applicable for GCP
  NULL AS CommitmentDiscountCategory,
  
  -- ==========================================================================
  -- CAPACITY RESERVATION (Not applicable for GCP)
  -- ==========================================================================
  
  NULL AS CapacityReservationId,
  NULL AS CapacityReservationStatus,
  
  -- ==========================================================================
  -- GCP-SPECIFIC EXTENSIONS (x_ prefix for provider-specific fields)
  -- ==========================================================================
  
  -- Original GCP fields for reference
  service.id AS x_ServiceId,
  cost_type AS x_CostType,
  project.number AS x_ProjectNumber,
  project.ancestry_numbers AS x_ProjectAncestryNumbers,
  
  -- Currency conversion
  currency_conversion_rate AS x_CurrencyConversionRate,
  
  -- Credits breakdown
  total_credits AS x_TotalCredits,
  committed_usage_credits AS x_CommittedUsageCredits,
  sustained_usage_credits AS x_SustainedUsageCredits,
  promotional_credits AS x_PromotionalCredits,
  
  -- Pricing details
  price.effective_price AS x_EffectivePrice,
  price.tier_start_amount AS x_PriceTierStartAmount,
  
  -- Export metadata
  export_time AS x_ExportTime,
  
  -- Transaction metadata
  transaction_type AS x_TransactionType,
  seller_name AS x_SellerName,
  
  -- Adjustment info
  CASE
    WHEN adjustment_info IS NOT NULL
    THEN TO_JSON_STRING(adjustment_info)
    ELSE NULL
  END AS x_AdjustmentInfo

FROM billing_with_tags

-- ==========================================================================
-- OPTIONAL FILTERS
-- ==========================================================================

-- Filter by date range (adjust as needed)
WHERE usage_start_time >= '2024-01-01'

-- Filter out very small charges (optional cost optimization)
-- AND ABS(cost) >= 0.01

-- Exclude test projects (optional)
-- AND project.id NOT IN ('test-project-1', 'sandbox-project')

-- Order by charge period for readability
ORDER BY ChargePeriodStart DESC, SubAccountId, ServiceName;


-- ============================================================================
-- ALTERNATIVE: Materialized Table for Better Performance
-- ============================================================================
--
-- For large datasets, consider creating a materialized table:
--
-- CREATE OR REPLACE TABLE `your-project-id.your-dataset-id.gcp_billing_focus_materialized`
-- PARTITION BY DATE(ChargePeriodStart)
-- CLUSTER BY BillingAccountId, SubAccountId, ServiceName, ChargeCategory
-- AS
-- SELECT * FROM `your-project-id.your-dataset-id.gcp_billing_focus_v1`;
--
-- Then set up scheduled query to refresh daily:
--
-- MERGE `your-project-id.your-dataset-id.gcp_billing_focus_materialized` AS target
-- USING `your-project-id.your-dataset-id.gcp_billing_focus_v1` AS source
-- ON target.BillingAccountId = source.BillingAccountId
--   AND target.SubAccountId = source.SubAccountId
--   AND target.ChargePeriodStart = source.ChargePeriodStart
--   AND target.SkuId = source.SkuId
--   AND IFNULL(target.ResourceId, '') = IFNULL(source.ResourceId, '')
-- WHEN MATCHED THEN UPDATE SET *
-- WHEN NOT MATCHED THEN INSERT *;
--
-- ============================================================================


-- ============================================================================
-- VALIDATION QUERIES
-- ============================================================================

-- Run these queries after creating the view to validate the transformation

-- ----------------------------------------------------------------------------
-- 1. Cost Reconciliation
-- ----------------------------------------------------------------------------
/*
WITH gcp_totals AS (
  SELECT
    invoice.month,
    SUM(cost + IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) AS c), 0)) AS gcp_billed_total
  FROM `your-project-id.your-dataset-id.gcp_billing_export_resource_v1_YOUR_BILLING_ACCOUNT_ID`
  WHERE usage_start_time >= '2024-01-01'
  GROUP BY invoice.month
),
focus_totals AS (
  SELECT
    FORMAT_DATE('%Y%m', BillingPeriodStart) AS month,
    SUM(BilledCost) AS focus_billed_total
  FROM `your-project-id.your-dataset-id.gcp_billing_focus_v1`
  GROUP BY month
)
SELECT
  gcp_totals.month,
  ROUND(gcp_billed_total, 2) AS gcp_total,
  ROUND(focus_billed_total, 2) AS focus_total,
  ROUND(gcp_billed_total - focus_billed_total, 2) AS difference,
  ROUND(ABS((gcp_billed_total - focus_billed_total) / NULLIF(gcp_billed_total, 0)) * 100, 2) AS percent_diff
FROM gcp_totals
JOIN focus_totals USING (month)
ORDER BY month DESC;
*/

-- ----------------------------------------------------------------------------
-- 2. ChargeCategory Distribution
-- ----------------------------------------------------------------------------
/*
SELECT
  ChargeCategory,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(BilledCost) / SUM(SUM(BilledCost)) OVER () * 100, 2) AS percent_of_total
FROM `your-project-id.your-dataset-id.gcp_billing_focus_v1`
GROUP BY ChargeCategory
ORDER BY total_cost DESC;
*/

-- ----------------------------------------------------------------------------
-- 3. Required Fields Check
-- ----------------------------------------------------------------------------
/*
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(ChargePeriodStart IS NULL) AS missing_charge_start,
  COUNTIF(ChargePeriodEnd IS NULL) AS missing_charge_end,
  COUNTIF(BillingPeriodStart IS NULL) AS missing_billing_start,
  COUNTIF(BillingPeriodEnd IS NULL) AS missing_billing_end,
  COUNTIF(BillingCurrency IS NULL) AS missing_currency,
  COUNTIF(ChargeCategory IS NULL) AS missing_category,
  COUNTIF(BilledCost IS NULL) AS missing_billed_cost,
  COUNTIF(EffectiveCost IS NULL) AS missing_effective_cost
FROM `your-project-id.your-dataset-id.gcp_billing_focus_v1`;
*/

-- ----------------------------------------------------------------------------
-- 4. Service Category Distribution
-- ----------------------------------------------------------------------------
/*
SELECT
  ServiceCategory,
  COUNT(DISTINCT ServiceName) AS distinct_services,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(BilledCost) / SUM(SUM(BilledCost)) OVER () * 100, 2) AS percent_of_total
FROM `your-project-id.your-dataset-id.gcp_billing_focus_v1`
WHERE ChargeCategory = 'Usage'
GROUP BY ServiceCategory
ORDER BY total_cost DESC;
*/

-- ============================================================================
-- END OF SQL FILE
-- ============================================================================
