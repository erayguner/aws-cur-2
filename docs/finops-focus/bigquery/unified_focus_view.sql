-- ============================================================================
-- Unified Multi-Cloud FOCUS View
-- ============================================================================
-- Description: Combines AWS CUR v2 and GCP billing exports into a single
--              FOCUS-compliant view for unified multi-cloud cost analysis
-- Version: 1.0.0
-- Last Updated: 2025-11-17
-- Dependencies: aws_cur_focus, gcp_billing_focus
-- ============================================================================

-- ----------------------------------------------------------------------------
-- OPTION A: Simple UNION ALL View (Development/Small-Scale)
-- ----------------------------------------------------------------------------
-- Use this for development, testing, or when:
-- - Dataset is < 1TB combined
-- - Real-time data is required
-- - Storage costs are a concern
-- ----------------------------------------------------------------------------

CREATE OR REPLACE VIEW `your-project.finops.unified_focus` AS
SELECT 
  *,
  'AWS' AS ProviderName,
  CURRENT_TIMESTAMP() AS _ETL_Timestamp
FROM `your-project.finops.aws_cur_focus`

UNION ALL

SELECT 
  *,
  'GCP' AS ProviderName,
  CURRENT_TIMESTAMP() AS _ETL_Timestamp
FROM `your-project.finops.gcp_billing_focus`;

-- ----------------------------------------------------------------------------
-- OPTION B: Materialized Table (Production/Large-Scale)
-- ----------------------------------------------------------------------------
-- Use this for production environments when:
-- - Dataset is > 1TB combined
-- - Query performance is critical
-- - You can afford storage costs for query savings
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TABLE `your-project.finops.unified_focus_materialized`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY ProviderName, ServiceCategory, SubAccountId, Region
OPTIONS(
  description="Materialized unified multi-cloud FOCUS view with optimized partitioning and clustering",
  require_partition_filter=true,
  partition_expiration_days=null,
  labels=[("env", "production"), ("team", "finops"), ("data-source", "multi-cloud")]
)
AS
SELECT 
  -- FOCUS Core Dimensions
  ChargePeriodStart,
  ChargePeriodEnd,
  BilledCost,
  EffectiveCost,
  ListCost,
  ChargeCategory,
  ChargeClass,
  ChargeDescription,
  ChargeFrequency,
  ChargePeriodDuration,
  
  -- Provider Information
  'AWS' AS ProviderName,
  
  -- Account/Project Information
  SubAccountId,
  SubAccountName,
  SubAccountType,
  
  -- Service Information
  ServiceCategory,
  ServiceName,
  
  -- Resource Information
  ResourceId,
  ResourceName,
  ResourceType,
  
  -- Region/Location
  Region,
  AvailabilityZone,
  
  -- Pricing Information
  PricingCategory,
  PricingUnit,
  PricingQuantity,
  UsageQuantity,
  UsageUnit,
  
  -- Commitment Information
  CommitmentDiscountId,
  CommitmentDiscountName,
  CommitmentDiscountType,
  CommitmentDiscountStatus,
  ContractedCost,
  ContractedUnitPrice,
  
  -- Tags (JSON format for flexibility)
  Tags,
  
  -- Metadata
  InvoiceIssuerName,
  BillingCurrency,
  
  -- ETL Metadata
  CURRENT_TIMESTAMP() AS _ETL_Timestamp,
  'aws_cur_focus' AS _SourceTable,
  DATE(ChargePeriodStart) AS _PartitionDate
  
FROM `your-project.finops.aws_cur_focus`

UNION ALL

SELECT 
  -- FOCUS Core Dimensions
  ChargePeriodStart,
  ChargePeriodEnd,
  BilledCost,
  EffectiveCost,
  ListCost,
  ChargeCategory,
  ChargeClass,
  ChargeDescription,
  ChargeFrequency,
  ChargePeriodDuration,
  
  -- Provider Information
  'GCP' AS ProviderName,
  
  -- Account/Project Information
  SubAccountId,
  SubAccountName,
  SubAccountType,
  
  -- Service Information
  ServiceCategory,
  ServiceName,
  
  -- Resource Information
  ResourceId,
  ResourceName,
  ResourceType,
  
  -- Region/Location
  Region,
  AvailabilityZone,
  
  -- Pricing Information
  PricingCategory,
  PricingUnit,
  PricingQuantity,
  UsageQuantity,
  UsageUnit,
  
  -- Commitment Information
  CommitmentDiscountId,
  CommitmentDiscountName,
  CommitmentDiscountType,
  CommitmentDiscountStatus,
  ContractedCost,
  ContractedUnitPrice,
  
  -- Tags (JSON format for flexibility)
  Tags,
  
  -- Metadata
  InvoiceIssuerName,
  BillingCurrency,
  
  -- ETL Metadata
  CURRENT_TIMESTAMP() AS _ETL_Timestamp,
  'gcp_billing_focus' AS _SourceTable,
  DATE(ChargePeriodStart) AS _PartitionDate
  
FROM `your-project.finops.gcp_billing_focus`;

-- ----------------------------------------------------------------------------
-- Service Mapping Table
-- ----------------------------------------------------------------------------
-- Maps provider-specific service names to standardized names
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TABLE `your-project.finops.service_mapping` (
  ProviderName STRING NOT NULL OPTIONS(description="Cloud provider name"),
  OriginalServiceName STRING NOT NULL OPTIONS(description="Original service name from provider"),
  ServiceCategory STRING OPTIONS(description="FOCUS-compliant service category"),
  NormalizedServiceName STRING OPTIONS(description="Standardized cross-cloud service name"),
  ServiceDescription STRING OPTIONS(description="Human-readable service description"),
  ServiceFamily STRING OPTIONS(description="Service family grouping (e.g., Compute, Storage)"),
  LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP() OPTIONS(description="Last update timestamp")
)
CLUSTER BY ProviderName, OriginalServiceName
OPTIONS(
  description="Service name mapping for multi-cloud standardization"
);

-- Populate service mapping table with common mappings
INSERT INTO `your-project.finops.service_mapping` 
  (ProviderName, OriginalServiceName, ServiceCategory, NormalizedServiceName, ServiceDescription, ServiceFamily)
VALUES
  -- AWS Compute Services
  ('AWS', 'Amazon Elastic Compute Cloud', 'Compute', 'Compute - Virtual Machines', 'EC2 Virtual Machines', 'Compute'),
  ('AWS', 'AWS Lambda', 'Compute', 'Compute - Serverless Functions', 'Lambda Serverless Functions', 'Compute'),
  ('AWS', 'Amazon Elastic Container Service', 'Compute', 'Compute - Containers', 'ECS Container Service', 'Compute'),
  ('AWS', 'Amazon Elastic Kubernetes Service', 'Compute', 'Compute - Kubernetes', 'EKS Kubernetes Service', 'Compute'),
  
  -- GCP Compute Services
  ('GCP', 'Compute Engine', 'Compute', 'Compute - Virtual Machines', 'GCE Virtual Machines', 'Compute'),
  ('GCP', 'Cloud Functions', 'Compute', 'Compute - Serverless Functions', 'Cloud Functions', 'Compute'),
  ('GCP', 'Cloud Run', 'Compute', 'Compute - Containers', 'Cloud Run Container Service', 'Compute'),
  ('GCP', 'Google Kubernetes Engine', 'Compute', 'Compute - Kubernetes', 'GKE Kubernetes Service', 'Compute'),
  
  -- AWS Storage Services
  ('AWS', 'Amazon Simple Storage Service', 'Storage', 'Storage - Object Storage', 'S3 Object Storage', 'Storage'),
  ('AWS', 'Amazon Elastic Block Store', 'Storage', 'Storage - Block Storage', 'EBS Block Storage', 'Storage'),
  ('AWS', 'Amazon Elastic File System', 'Storage', 'Storage - File Storage', 'EFS File Storage', 'Storage'),
  
  -- GCP Storage Services
  ('GCP', 'Cloud Storage', 'Storage', 'Storage - Object Storage', 'GCS Object Storage', 'Storage'),
  ('GCP', 'Compute Engine', 'Storage', 'Storage - Block Storage', 'Persistent Disk', 'Storage'),
  ('GCP', 'Cloud Filestore', 'Storage', 'Storage - File Storage', 'Filestore', 'Storage'),
  
  -- AWS Database Services
  ('AWS', 'Amazon Relational Database Service', 'Database', 'Database - Relational', 'RDS Managed Database', 'Database'),
  ('AWS', 'Amazon DynamoDB', 'Database', 'Database - NoSQL', 'DynamoDB NoSQL Database', 'Database'),
  ('AWS', 'Amazon ElastiCache', 'Database', 'Database - Cache', 'ElastiCache In-Memory Cache', 'Database'),
  
  -- GCP Database Services
  ('GCP', 'Cloud SQL', 'Database', 'Database - Relational', 'Cloud SQL Managed Database', 'Database'),
  ('GCP', 'Cloud Firestore', 'Database', 'Database - NoSQL', 'Firestore NoSQL Database', 'Database'),
  ('GCP', 'Cloud Bigtable', 'Database', 'Database - NoSQL', 'Bigtable Wide-Column Store', 'Database'),
  ('GCP', 'Cloud Memorystore', 'Database', 'Database - Cache', 'Memorystore In-Memory Cache', 'Database'),
  
  -- AWS Networking Services
  ('AWS', 'Amazon Virtual Private Cloud', 'Networking', 'Network - Virtual Network', 'VPC Networking', 'Networking'),
  ('AWS', 'Amazon CloudFront', 'Networking', 'Network - CDN', 'CloudFront CDN', 'Networking'),
  ('AWS', 'Elastic Load Balancing', 'Networking', 'Network - Load Balancer', 'ELB Load Balancing', 'Networking'),
  
  -- GCP Networking Services
  ('GCP', 'Compute Engine', 'Networking', 'Network - Virtual Network', 'VPC Networking', 'Networking'),
  ('GCP', 'Cloud CDN', 'Networking', 'Network - CDN', 'Cloud CDN', 'Networking'),
  ('GCP', 'Cloud Load Balancing', 'Networking', 'Network - Load Balancer', 'Cloud Load Balancing', 'Networking'),
  
  -- AWS Analytics Services
  ('AWS', 'Amazon Redshift', 'Analytics', 'Analytics - Data Warehouse', 'Redshift Data Warehouse', 'Analytics'),
  ('AWS', 'Amazon Athena', 'Analytics', 'Analytics - Query Service', 'Athena Query Service', 'Analytics'),
  ('AWS', 'Amazon EMR', 'Analytics', 'Analytics - Big Data', 'EMR Hadoop/Spark', 'Analytics'),
  
  -- GCP Analytics Services
  ('GCP', 'BigQuery', 'Analytics', 'Analytics - Data Warehouse', 'BigQuery Data Warehouse', 'Analytics'),
  ('GCP', 'BigQuery', 'Analytics', 'Analytics - Query Service', 'BigQuery Query Service', 'Analytics'),
  ('GCP', 'Dataproc', 'Analytics', 'Analytics - Big Data', 'Dataproc Hadoop/Spark', 'Analytics');

-- ----------------------------------------------------------------------------
-- Daily Summary Aggregation Table
-- ----------------------------------------------------------------------------
-- Pre-aggregated daily metrics for dashboard performance
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TABLE `your-project.finops.unified_focus_daily_summary`
PARTITION BY ChargeDate
CLUSTER BY ProviderName, ServiceCategory, SubAccountId
OPTIONS(
  description="Daily aggregated cost metrics for dashboard performance",
  require_partition_filter=true
)
AS
SELECT
  DATE(ChargePeriodStart) AS ChargeDate,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName,
  ChargeCategory,
  ChargeClass,
  
  -- Aggregated Cost Metrics
  SUM(BilledCost) AS DailyBilledCost,
  SUM(EffectiveCost) AS DailyEffectiveCost,
  SUM(ListCost) AS DailyListCost,
  SUM(ListCost - EffectiveCost) AS DailySavings,
  AVG(BilledCost) AS AvgLineItemCost,
  MAX(BilledCost) AS MaxLineItemCost,
  
  -- Usage Metrics
  SUM(UsageQuantity) AS DailyUsageQuantity,
  AVG(UsageQuantity) AS AvgUsageQuantity,
  
  -- Resource Metrics
  COUNT(DISTINCT ResourceId) AS UniqueResources,
  COUNT(*) AS LineItemCount,
  
  -- Metadata
  CURRENT_TIMESTAMP() AS _ETL_Timestamp
  
FROM `your-project.finops.unified_focus_materialized`
GROUP BY
  ChargeDate,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName,
  ChargeCategory,
  ChargeClass;

-- ----------------------------------------------------------------------------
-- Monthly Summary Aggregation Table
-- ----------------------------------------------------------------------------
-- Pre-aggregated monthly metrics for trend analysis
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TABLE `your-project.finops.unified_focus_monthly_summary`
PARTITION BY DATE(ChargeMonth)
CLUSTER BY ProviderName, ServiceCategory
OPTIONS(
  description="Monthly aggregated cost metrics for trend analysis"
)
AS
SELECT
  DATE_TRUNC(DATE(ChargePeriodStart), MONTH) AS ChargeMonth,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName,
  
  -- Monthly Cost Metrics
  SUM(BilledCost) AS MonthlyBilledCost,
  SUM(EffectiveCost) AS MonthlyEffectiveCost,
  SUM(ListCost) AS MonthlyListCost,
  SUM(ListCost - EffectiveCost) AS MonthlySavings,
  
  -- Daily Averages
  SUM(BilledCost) / COUNT(DISTINCT DATE(ChargePeriodStart)) AS AvgDailyBilledCost,
  SUM(EffectiveCost) / COUNT(DISTINCT DATE(ChargePeriodStart)) AS AvgDailyEffectiveCost,
  
  -- Usage Metrics
  SUM(UsageQuantity) AS MonthlyUsageQuantity,
  COUNT(DISTINCT ResourceId) AS UniqueResources,
  COUNT(DISTINCT DATE(ChargePeriodStart)) AS DaysWithCharges,
  
  -- Metadata
  CURRENT_TIMESTAMP() AS _ETL_Timestamp
  
FROM `your-project.finops.unified_focus_materialized`
GROUP BY
  ChargeMonth,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName;

-- ----------------------------------------------------------------------------
-- Unified View with Service Mapping (Enhanced)
-- ----------------------------------------------------------------------------
-- Join unified FOCUS data with service mapping for normalized names
-- ----------------------------------------------------------------------------

CREATE OR REPLACE VIEW `your-project.finops.unified_focus_enhanced` AS
SELECT
  uf.*,
  sm.NormalizedServiceName,
  sm.ServiceDescription,
  sm.ServiceFamily
FROM `your-project.finops.unified_focus` uf
LEFT JOIN `your-project.finops.service_mapping` sm
  ON uf.ProviderName = sm.ProviderName
  AND uf.ServiceName = sm.OriginalServiceName;

-- ----------------------------------------------------------------------------
-- Incremental Refresh Procedure
-- ----------------------------------------------------------------------------
-- Stored procedure for daily incremental refresh of materialized table
-- ----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE `your-project.finops.refresh_unified_focus`()
BEGIN
  -- Step 1: Delete last 7 days (to handle retroactive AWS CUR updates)
  DELETE FROM `your-project.finops.unified_focus_materialized`
  WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
  
  -- Step 2: Insert refreshed data for last 7 days
  INSERT INTO `your-project.finops.unified_focus_materialized`
  SELECT * FROM `your-project.finops.unified_focus`
  WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
  
  -- Step 3: Refresh daily summary (last 7 days)
  DELETE FROM `your-project.finops.unified_focus_daily_summary`
  WHERE ChargeDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
  
  INSERT INTO `your-project.finops.unified_focus_daily_summary`
  SELECT
    DATE(ChargePeriodStart) AS ChargeDate,
    ProviderName,
    ServiceCategory,
    ServiceName,
    Region,
    SubAccountId,
    SubAccountName,
    ChargeCategory,
    ChargeClass,
    SUM(BilledCost) AS DailyBilledCost,
    SUM(EffectiveCost) AS DailyEffectiveCost,
    SUM(ListCost) AS DailyListCost,
    SUM(ListCost - EffectiveCost) AS DailySavings,
    AVG(BilledCost) AS AvgLineItemCost,
    MAX(BilledCost) AS MaxLineItemCost,
    SUM(UsageQuantity) AS DailyUsageQuantity,
    AVG(UsageQuantity) AS AvgUsageQuantity,
    COUNT(DISTINCT ResourceId) AS UniqueResources,
    COUNT(*) AS LineItemCount,
    CURRENT_TIMESTAMP() AS _ETL_Timestamp
  FROM `your-project.finops.unified_focus_materialized`
  WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  GROUP BY
    ChargeDate, ProviderName, ServiceCategory, ServiceName,
    Region, SubAccountId, SubAccountName, ChargeCategory, ChargeClass;
  
  -- Step 4: Refresh monthly summary (current and previous month)
  DELETE FROM `your-project.finops.unified_focus_monthly_summary`
  WHERE DATE(ChargeMonth) >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH);
  
  INSERT INTO `your-project.finops.unified_focus_monthly_summary`
  SELECT
    DATE_TRUNC(DATE(ChargePeriodStart), MONTH) AS ChargeMonth,
    ProviderName,
    ServiceCategory,
    ServiceName,
    Region,
    SubAccountId,
    SubAccountName,
    SUM(BilledCost) AS MonthlyBilledCost,
    SUM(EffectiveCost) AS MonthlyEffectiveCost,
    SUM(ListCost) AS MonthlyListCost,
    SUM(ListCost - EffectiveCost) AS MonthlySavings,
    SUM(BilledCost) / COUNT(DISTINCT DATE(ChargePeriodStart)) AS AvgDailyBilledCost,
    SUM(EffectiveCost) / COUNT(DISTINCT DATE(ChargePeriodStart)) AS AvgDailyEffectiveCost,
    SUM(UsageQuantity) AS MonthlyUsageQuantity,
    COUNT(DISTINCT ResourceId) AS UniqueResources,
    COUNT(DISTINCT DATE(ChargePeriodStart)) AS DaysWithCharges,
    CURRENT_TIMESTAMP() AS _ETL_Timestamp
  FROM `your-project.finops.unified_focus_materialized`
  WHERE DATE_TRUNC(DATE(ChargePeriodStart), MONTH) >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
  GROUP BY
    ChargeMonth, ProviderName, ServiceCategory, ServiceName,
    Region, SubAccountId, SubAccountName;
END;

-- ----------------------------------------------------------------------------
-- Usage Instructions
-- ----------------------------------------------------------------------------
-- 
-- 1. Initial Setup:
--    - Create the unified_focus view for development
--    - Validate data quality
--    - Test query patterns
--
-- 2. Production Deployment:
--    - Create unified_focus_materialized table
--    - Create daily and monthly summary tables
--    - Schedule daily refresh procedure:
--      CALL `your-project.finops.refresh_unified_focus`();
--
-- 3. Query Patterns:
--    - Use unified_focus for real-time ad-hoc queries
--    - Use unified_focus_materialized for dashboards
--    - Use summary tables for trend analysis
--
-- 4. Maintenance:
--    - Monitor partition sizes
--    - Review clustering effectiveness
--    - Optimize based on query patterns
--
-- ----------------------------------------------------------------------------
