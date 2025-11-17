-- ============================================================================
-- AWS CUR 2.0 to FinOps FOCUS Format Transformation
-- ============================================================================
-- Description: Comprehensive BigQuery SQL view to transform AWS Cost and Usage 
--              Report (CUR) 2.0 data into FinOps FOCUS format
-- Version: 1.0
-- Last Updated: 2025-11-17
-- FOCUS Specification: v1.2
-- 
-- Usage:
--   1. Update project, dataset, and table names in the FROM clause
--   2. Run this script to create the view
--   3. Query the view like any other table
--
-- Notes:
--   - This view includes all 43 FOCUS 1.0 core columns
--   - Plus 5 AWS-specific extension columns (x_* prefix)
--   - Optimized for BigQuery performance with partitioning hints
-- ============================================================================

CREATE OR REPLACE VIEW `project.dataset.aws_cur_focus` AS

WITH source_data AS (
  -- Source: AWS CUR 2.0 raw data
  -- TODO: Update these table references to match your environment
  SELECT * 
  FROM `project.dataset.aws_cur_raw`
  WHERE bill_billing_period_start_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 13 MONTH)
),

-- Helper CTE for tag extraction
tag_extraction AS (
  SELECT
    identity_line_item_id,
    -- Extract Name tag from resource_tags JSON
    COALESCE(
      JSON_EXTRACT_SCALAR(resource_tags, '$.Name'),
      JSON_EXTRACT_SCALAR(resource_tags, '$.name'),
      JSON_EXTRACT_SCALAR(resource_tags, '$.aws:Name'),
      -- Fallback: extract from ARN
      CASE 
        WHEN line_item_resource_id LIKE 'arn:%' 
        THEN REGEXP_EXTRACT(line_item_resource_id, r'/([^/]+)$')
        ELSE NULL
      END
    ) AS extracted_resource_name,
    
    -- Parse tags as JSON
    CASE
      WHEN resource_tags IS NOT NULL 
        AND resource_tags != '' 
        AND resource_tags != '{}'
      THEN SAFE.PARSE_JSON(resource_tags)
      ELSE NULL
    END AS parsed_tags
    
  FROM source_data
)

-- Main transformation query
SELECT
  -- ========================================================================
  -- IDENTITY & ACCOUNT COLUMNS
  -- ========================================================================
  
  -- BillingAccountId: The identifier assigned to a billing account by the provider
  bill_payer_account_id AS BillingAccountId,
  
  -- BillingAccountName: The display name assigned to a billing account
  bill_payer_account_name AS BillingAccountName,
  
  -- SubAccountId: The identifier assigned to a sub account by the provider
  line_item_usage_account_id AS SubAccountId,
  
  -- SubAccountName: The display name assigned to a sub account
  line_item_usage_account_name AS SubAccountName,
  
  -- InvoiceIssuerName: The name of the entity issuing the invoice
  'AWS' AS InvoiceIssuerName,
  
  -- ProviderName: The name of the entity that made the resources or services available for purchase
  'AWS' AS ProviderName,
  
  -- PublisherName: The name of the entity that produced the resources or services that were purchased
  'AWS' AS PublisherName,
  
  -- ========================================================================
  -- BILLING PERIOD COLUMNS
  -- ========================================================================
  
  -- BillingPeriodStart: The start date and time of the billing period
  CAST(bill_billing_period_start_date AS TIMESTAMP) AS BillingPeriodStart,
  
  -- BillingPeriodEnd: The end date and time of the billing period
  CAST(bill_billing_period_end_date AS TIMESTAMP) AS BillingPeriodEnd,
  
  -- ChargePeriodStart: The start date and time of a charge period
  CAST(line_item_usage_start_date AS TIMESTAMP) AS ChargePeriodStart,
  
  -- ChargePeriodEnd: The end date and time of a charge period
  CAST(line_item_usage_end_date AS TIMESTAMP) AS ChargePeriodEnd,
  
  -- ========================================================================
  -- CORE COST COLUMNS (The Four Pillars of FOCUS Costing)
  -- ========================================================================
  
  -- BilledCost: The charge serving as the basis for invoicing
  -- REQUIRED FIELD - Must not be null
  CAST(COALESCE(line_item_unblended_cost, 0) AS NUMERIC) AS BilledCost,
  
  -- EffectiveCost: The amortized cost of the charge after applying all reduced rates, discounts, and the applicable portion of relevant, prepaid purchases
  CAST(COALESCE(
    -- For Reserved Instances, use effective cost
    reservation_effective_cost,
    -- For Savings Plans, use SP effective cost
    savings_plan_savings_plan_effective_cost,
    -- For regular usage, use unblended cost
    line_item_unblended_cost,
    0
  ) AS NUMERIC) AS EffectiveCost,
  
  -- ListCost: The cost calculated using list unit prices for the quantity of the associated SKU
  CAST(COALESCE(pricing_public_on_demand_cost, 0) AS NUMERIC) AS ListCost,
  
  -- ContractedCost: The cost calculated using contracted unit prices for the quantity of the associated SKU
  CAST(CASE
    WHEN reservation_reservation_a_r_n IS NOT NULL THEN COALESCE(reservation_effective_cost, 0)
    WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN COALESCE(savings_plan_savings_plan_effective_cost, 0)
    ELSE COALESCE(line_item_unblended_cost, 0)
  END AS NUMERIC) AS ContractedCost,
  
  -- BillingCurrency: The currency that a charge for resources or services was billed in
  -- REQUIRED FIELD - Must not be null
  COALESCE(line_item_currency_code, 'USD') AS BillingCurrency,
  
  -- ========================================================================
  -- CHARGE CLASSIFICATION COLUMNS
  -- ========================================================================
  
  -- ChargeCategory: Highest level classification of a charge based on the nature of how it is billed
  -- REQUIRED FIELD - Must not be null
  CASE line_item_line_item_type
    WHEN 'Usage' THEN 'Usage'
    WHEN 'Fee' THEN 'Purchase'
    WHEN 'Tax' THEN 'Tax'
    WHEN 'Credit' THEN 'Adjustment'
    WHEN 'Refund' THEN 'Adjustment'
    WHEN 'RIFee' THEN 'Purchase'
    WHEN 'SavingsPlanUpfrontFee' THEN 'Purchase'
    WHEN 'SavingsPlanRecurringFee' THEN 'Purchase'
    WHEN 'SavingsPlanCoveredUsage' THEN 'Usage'
    WHEN 'SavingsPlanNegation' THEN 'Adjustment'
    WHEN 'DiscountedUsage' THEN 'Usage'
    WHEN 'BundledDiscount' THEN 'Adjustment'
    WHEN 'EdpDiscount' THEN 'Adjustment'
    WHEN 'PrivateRateDiscount' THEN 'Adjustment'
    ELSE 'Usage'
  END AS ChargeCategory,
  
  -- ChargeClass: Indicates whether the row represents a correction to one or more charges invoiced in a previous billing period
  -- NULL unless it's a correction
  CASE
    WHEN bill_bill_type = 'Refund' THEN 'Correction'
    WHEN line_item_line_item_type IN ('Credit', 'Refund') 
      AND CAST(line_item_usage_start_date AS DATE) < CAST(bill_billing_period_start_date AS DATE)
    THEN 'Correction'
    ELSE NULL
  END AS ChargeClass,
  
  -- ChargeDescription: Plain language description of a charge
  -- REQUIRED FIELD - Must not be null
  COALESCE(
    line_item_line_item_description,
    CONCAT(line_item_product_code, ' - ', line_item_usage_type),
    'No description available'
  ) AS ChargeDescription,
  
  -- ChargeFrequency: Indicates how often a charge will occur
  CASE
    -- One-time charges
    WHEN line_item_line_item_type IN ('RIFee', 'SavingsPlanUpfrontFee') THEN 'One-Time'
    -- Recurring charges
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN 'Recurring'
    WHEN line_item_line_item_type = 'Fee' 
      AND LOWER(line_item_line_item_description) LIKE '%monthly%' THEN 'Recurring'
    WHEN line_item_line_item_type = 'Fee' 
      AND LOWER(line_item_line_item_description) LIKE '%annual%' THEN 'Recurring'
    -- Usage-based charges
    WHEN line_item_line_item_type IN ('Usage', 'SavingsPlanCoveredUsage', 'DiscountedUsage') 
    THEN 'Usage-Based'
    ELSE 'Usage-Based'
  END AS ChargeFrequency,
  
  -- ========================================================================
  -- PRICING & QUANTITY COLUMNS
  -- ========================================================================
  
  -- PricingCategory: Describes the pricing model used for a charge at the time of use or purchase
  CASE
    WHEN reservation_reservation_a_r_n IS NOT NULL THEN 'Reserved'
    WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN 'Committed'
    WHEN pricing_term = 'OnDemand' THEN 'On-Demand'
    WHEN pricing_term = 'Spot' THEN 'Spot'
    WHEN line_item_line_item_type = 'Usage' THEN 'On-Demand'
    WHEN line_item_line_item_type IN ('RIFee', 'DiscountedUsage') THEN 'Reserved'
    WHEN line_item_line_item_type LIKE 'SavingsPlan%' THEN 'Committed'
    ELSE 'On-Demand'
  END AS PricingCategory,
  
  -- PricingQuantity: Volume of a SKU that was used or purchased based on the Pricing Unit
  CAST(COALESCE(line_item_usage_amount, 0) AS NUMERIC) AS PricingQuantity,
  
  -- PricingUnit: Provider-specified measurement unit for determining unit prices
  COALESCE(pricing_unit, 'Unit') AS PricingUnit,
  
  -- ConsumedQuantity: Volume of a SKU that was used based on the Consumed Unit
  CAST(COALESCE(line_item_usage_amount, 0) AS NUMERIC) AS ConsumedQuantity,
  
  -- ConsumedUnit: Unit of measure for the ConsumedQuantity
  COALESCE(pricing_unit, 'Unit') AS ConsumedUnit,
  
  -- ContractedUnitPrice: Unit price for a single Pricing Unit of the associated SKU
  CAST(COALESCE(line_item_unblended_rate, 0) AS NUMERIC) AS ContractedUnitPrice,
  
  -- ListUnitPrice: Unit price for a single Pricing Unit of the associated SKU at list price
  CAST(COALESCE(pricing_public_on_demand_rate, 0) AS NUMERIC) AS ListUnitPrice,
  
  -- ========================================================================
  -- RESOURCE & SERVICE COLUMNS
  -- ========================================================================
  
  -- ResourceId: Provider-assigned identifier for a resource
  line_item_resource_id AS ResourceId,
  
  -- ResourceName: Display name assigned to a resource
  tag_extraction.extracted_resource_name AS ResourceName,
  
  -- ResourceType: The kind of resource a charge applies to (not in FOCUS 1.0, but useful)
  -- Note: This is a custom extension, remove if strict FOCUS compliance needed
  CASE 
    WHEN line_item_resource_id LIKE 'arn:aws:ec2:%:instance/%' THEN 'Instance'
    WHEN line_item_resource_id LIKE 'arn:aws:s3:%' THEN 'Bucket'
    WHEN line_item_resource_id LIKE 'arn:aws:rds:%:db:%' THEN 'Database'
    WHEN line_item_resource_id LIKE 'arn:aws:lambda:%:function:%' THEN 'Function'
    ELSE NULL
  END AS ResourceType,
  
  -- ServiceCategory: Highest-level classification of a service
  CASE line_item_product_code
    -- Compute
    WHEN 'AmazonEC2' THEN 'Compute'
    WHEN 'AmazonECS' THEN 'Compute'
    WHEN 'AmazonEKS' THEN 'Compute'
    WHEN 'AWSLambda' THEN 'Compute'
    WHEN 'AWSBatch' THEN 'Compute'
    WHEN 'ElasticMapReduce' THEN 'Compute'
    WHEN 'AmazonLightsail' THEN 'Compute'
    -- Storage
    WHEN 'AmazonS3' THEN 'Storage'
    WHEN 'AmazonEBS' THEN 'Storage'
    WHEN 'AmazonEFS' THEN 'Storage'
    WHEN 'AmazonFSx' THEN 'Storage'
    WHEN 'AmazonGlacier' THEN 'Storage'
    WHEN 'AWSBackup' THEN 'Storage'
    WHEN 'AWSStorageGateway' THEN 'Storage'
    WHEN 'AmazonS3GlacierDeepArchive' THEN 'Storage'
    -- Database
    WHEN 'AmazonRDS' THEN 'Database'
    WHEN 'AmazonDynamoDB' THEN 'Database'
    WHEN 'AmazonRedshift' THEN 'Database'
    WHEN 'AmazonElastiCache' THEN 'Database'
    WHEN 'AmazonDocumentDB' THEN 'Database'
    WHEN 'AmazonNeptune' THEN 'Database'
    WHEN 'AmazonKeyspaces' THEN 'Database'
    WHEN 'AmazonMemoryDB' THEN 'Database'
    WHEN 'AmazonTimestream' THEN 'Database'
    WHEN 'AmazonQLDB' THEN 'Database'
    -- Networking
    WHEN 'AmazonVPC' THEN 'Networking'
    WHEN 'AmazonCloudFront' THEN 'Networking'
    WHEN 'AmazonRoute53' THEN 'Networking'
    WHEN 'AWSELB' THEN 'Networking'
    WHEN 'AWSDirectConnect' THEN 'Networking'
    WHEN 'AmazonAPIGateway' THEN 'Networking'
    WHEN 'AWSGlobalAccelerator' THEN 'Networking'
    WHEN 'AWSTransitGateway' THEN 'Networking'
    WHEN 'AWSVPN' THEN 'Networking'
    WHEN 'AWSPrivateLink' THEN 'Networking'
    -- Analytics
    WHEN 'AmazonAthena' THEN 'Analytics'
    WHEN 'AmazonEMR' THEN 'Analytics'
    WHEN 'AWSGlue' THEN 'Analytics'
    WHEN 'AmazonKinesis' THEN 'Analytics'
    WHEN 'AmazonMSK' THEN 'Analytics'
    WHEN 'AmazonOpenSearchService' THEN 'Analytics'
    WHEN 'AmazonQuickSight' THEN 'Analytics'
    WHEN 'AWSLakeFormation' THEN 'Analytics'
    WHEN 'AWSDataExchange' THEN 'Analytics'
    -- AI/ML
    WHEN 'AmazonSageMaker' THEN 'AI/ML'
    WHEN 'AmazonBedrock' THEN 'AI/ML'
    WHEN 'AmazonRekognition' THEN 'AI/ML'
    WHEN 'AmazonComprehend' THEN 'AI/ML'
    WHEN 'AmazonTranscribe' THEN 'AI/ML'
    WHEN 'AmazonPolly' THEN 'AI/ML'
    WHEN 'AmazonTranslate' THEN 'AI/ML'
    WHEN 'AmazonLex' THEN 'AI/ML'
    WHEN 'AmazonForecast' THEN 'AI/ML'
    WHEN 'AmazonPersonalize' THEN 'AI/ML'
    WHEN 'AmazonTextract' THEN 'AI/ML'
    WHEN 'AmazonKendra' THEN 'AI/ML'
    -- Security
    WHEN 'AWSKeyManagementService' THEN 'Security'
    WHEN 'AWSSecretsManager' THEN 'Security'
    WHEN 'AmazonGuardDuty' THEN 'Security'
    WHEN 'AWSSecurityHub' THEN 'Security'
    WHEN 'AWSWAF' THEN 'Security'
    WHEN 'AWSShield' THEN 'Security'
    WHEN 'AmazonMacie' THEN 'Security'
    WHEN 'AWSCertificateManager' THEN 'Security'
    -- Management
    WHEN 'AWSCloudTrail' THEN 'Management'
    WHEN 'AmazonCloudWatch' THEN 'Management'
    WHEN 'AWSConfig' THEN 'Management'
    WHEN 'AWSSystemsManager' THEN 'Management'
    WHEN 'AWSCloudFormation' THEN 'Management'
    WHEN 'AWSSupport' THEN 'Management'
    -- Containers
    WHEN 'AmazonECR' THEN 'Containers'
    WHEN 'AWSFargate' THEN 'Containers'
    -- Application Integration
    WHEN 'AmazonSNS' THEN 'Application Integration'
    WHEN 'AmazonSQS' THEN 'Application Integration'
    WHEN 'AWSStepFunctions' THEN 'Application Integration'
    WHEN 'AmazonEventBridge' THEN 'Application Integration'
    -- Developer Tools
    WHEN 'AWSCodeBuild' THEN 'Developer Tools'
    WHEN 'AWSCodePipeline' THEN 'Developer Tools'
    WHEN 'AWSCodeDeploy' THEN 'Developer Tools'
    -- Other/Unknown
    ELSE 'Other'
  END AS ServiceCategory,
  
  -- ServiceName: The name of a provider's offering of a SKU
  line_item_product_code AS ServiceName,
  
  -- SkuId: Unique identifier for the SKU that was used or purchased
  product_sku AS SkuId,
  
  -- SkuPriceId: Unique identifier for a SKU price
  pricing_rate_id AS SkuPriceId,
  
  -- ========================================================================
  -- GEOGRAPHIC COLUMNS
  -- ========================================================================
  
  -- Region: Provider-assigned identifier for an isolated geographic area where a resource is provisioned or a service is provided
  product_region_code AS Region,
  
  -- RegionId: Provider-assigned identifier for an isolated geographic area
  product_region_code AS RegionId,
  
  -- RegionName: Display name assigned to a region
  COALESCE(
    product_location,
    product_region_code,
    'Global'
  ) AS RegionName,
  
  -- AvailabilityZone: Provider-assigned identifier for a physically separated area within a Region
  line_item_availability_zone AS AvailabilityZone,
  
  -- ========================================================================
  -- COMMITMENT DISCOUNT COLUMNS
  -- ========================================================================
  
  -- CommitmentDiscountId: Unique identifier assigned to a commitment discount by the provider
  COALESCE(
    reservation_reservation_a_r_n,
    savings_plan_savings_plan_a_r_n
  ) AS CommitmentDiscountId,
  
  -- CommitmentDiscountName: Display name assigned to a commitment discount
  -- AWS doesn't provide friendly names, so we'll use ID or construct one
  CASE
    WHEN reservation_reservation_a_r_n IS NOT NULL 
      THEN CONCAT('RI-', REGEXP_EXTRACT(reservation_reservation_a_r_n, r'reservation/([^/]+)'))
    WHEN savings_plan_savings_plan_a_r_n IS NOT NULL 
      THEN CONCAT('SP-', REGEXP_EXTRACT(savings_plan_savings_plan_a_r_n, r'savingsplan/([^/]+)'))
    ELSE NULL
  END AS CommitmentDiscountName,
  
  -- CommitmentDiscountType: Type of commitment discount applied
  CASE
    WHEN reservation_reservation_a_r_n IS NOT NULL THEN 'Reservation'
    WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN 
      CASE savings_plan_offering_type
        WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plan'
        WHEN 'EC2InstanceSavingsPlans' THEN 'EC2 Instance Savings Plan'
        WHEN 'SageMakerSavingsPlans' THEN 'SageMaker Savings Plan'
        ELSE 'Savings Plan'
      END
    ELSE NULL
  END AS CommitmentDiscountType,
  
  -- CommitmentDiscountStatus: Indicates if the commitment discount is used or unused
  CASE
    WHEN reservation_reservation_a_r_n IS NOT NULL THEN
      CASE
        WHEN COALESCE(reservation_unused_quantity, 0) > 0 THEN 'Unused'
        WHEN line_item_line_item_type IN ('DiscountedUsage', 'RIFee') THEN 'Used'
        ELSE 'Used'
      END
    WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN
      CASE
        WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN 'Used'
        WHEN line_item_line_item_type IN ('SavingsPlanRecurringFee', 'SavingsPlanUpfrontFee') THEN 'Used'
        ELSE 'Used'
      END
    ELSE NULL
  END AS CommitmentDiscountStatus,
  
  -- CommitmentDiscountCategory: Indicates whether the commitment discount applies to usage quantity or spending amount
  CASE
    WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN 'Spend'
    WHEN reservation_reservation_a_r_n IS NOT NULL THEN 'Usage'
    ELSE NULL
  END AS CommitmentDiscountCategory,
  
  -- ========================================================================
  -- TAG COLUMNS
  -- ========================================================================
  
  -- Tags: Provider-defined or user-defined key-value pairs attached to resources
  tag_extraction.parsed_tags AS Tags,
  
  -- ========================================================================
  -- INVOICE COLUMNS
  -- ========================================================================
  
  -- InvoiceId: Unique identifier for an invoice
  bill_invoice_id AS InvoiceId,
  
  -- ========================================================================
  -- AWS-SPECIFIC EXTENSION COLUMNS (x_* prefix)
  -- ========================================================================
  
  -- x_Operation: AWS-specific operation field
  line_item_operation AS x_Operation,
  
  -- x_UsageType: AWS-specific usage type field
  line_item_usage_type AS x_UsageType,
  
  -- x_ServiceCode: AWS-specific service code field
  line_item_product_code AS x_ServiceCode,
  
  -- x_CostCategories: AWS Cost Categories as JSON
  CASE
    WHEN cost_category IS NOT NULL AND cost_category != ''
    THEN SAFE.PARSE_JSON(cost_category)
    ELSE NULL
  END AS x_CostCategories,
  
  -- x_Discounts: Aggregated discount information as JSON
  TO_JSON_STRING(STRUCT(
    discount AS bundled_discount,
    discount_bundled_discount AS bundled_discount_detail,
    discount_total_discount AS total_discount,
    COALESCE(reservation_effective_cost, 0) - COALESCE(line_item_unblended_cost, 0) AS ri_discount,
    COALESCE(savings_plan_savings_plan_effective_cost, 0) - COALESCE(line_item_unblended_cost, 0) AS sp_discount
  )) AS x_Discounts,
  
  -- ========================================================================
  -- INTERNAL TRACKING (Optional - for reconciliation)
  -- ========================================================================
  
  -- Keep original line item ID for reconciliation
  identity_line_item_id AS x_LineItemId,
  
  -- Billing entity information
  bill_billing_entity AS x_BillingEntity,
  bill_invoicing_entity AS x_InvoicingEntity,
  
  -- Original line item type for debugging
  line_item_line_item_type AS x_LineItemType

FROM source_data
LEFT JOIN tag_extraction USING (identity_line_item_id)

-- Filter out zero-cost items if desired (comment out to keep all records)
-- WHERE COALESCE(line_item_unblended_cost, 0) != 0

-- ============================================================================
-- OPTIONAL: Create materialized table with partitioning and clustering
-- ============================================================================
--
-- For production use, create a materialized table instead of a view:
--
-- CREATE OR REPLACE TABLE `project.dataset.aws_cur_focus_materialized`
-- PARTITION BY DATE(BillingPeriodStart)
-- CLUSTER BY ServiceName, Region, SubAccountId
-- AS
-- SELECT * FROM `project.dataset.aws_cur_focus`;
--
-- ============================================================================
-- PERFORMANCE OPTIMIZATION TIPS
-- ============================================================================
--
-- 1. Partition by BillingPeriodStart (monthly partitions)
-- 2. Cluster by high-cardinality columns: ServiceName, Region, SubAccountId
-- 3. Use incremental refresh for new billing periods only
-- 4. Consider adding indexes on frequently queried columns
-- 5. Schedule materialized table refresh after CUR data ingestion
--
-- ============================================================================
-- DATA QUALITY CHECKS
-- ============================================================================
--
-- Run these queries after creating the view to validate data quality:
--
-- 1. Check for required fields:
-- SELECT COUNT(*) FROM `project.dataset.aws_cur_focus` WHERE BilledCost IS NULL;
--
-- 2. Reconcile total costs:
-- SELECT 
--   SUM(line_item_unblended_cost) AS aws_total,
--   (SELECT SUM(BilledCost) FROM `project.dataset.aws_cur_focus`) AS focus_total
-- FROM `project.dataset.aws_cur_raw`;
--
-- 3. Check ChargeCategory distribution:
-- SELECT ChargeCategory, COUNT(*), SUM(BilledCost) 
-- FROM `project.dataset.aws_cur_focus` 
-- GROUP BY ChargeCategory;
--
-- ============================================================================
