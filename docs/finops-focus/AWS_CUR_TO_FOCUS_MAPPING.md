# AWS CUR 2.0 to FinOps FOCUS Format Mapping

**Version:** 1.0  
**Last Updated:** 2025-11-17  
**FOCUS Specification:** v1.2 (May 2025)  
**AWS CUR Version:** 2.0

## Executive Summary

This document provides a comprehensive mapping between AWS Cost and Usage Report (CUR) 2.0 and the FinOps Open Cost and Usage Specification (FOCUS) format. FOCUS is an open-source specification that standardizes cloud cost and usage data across multiple providers.

### Key Benefits of FOCUS Format

- **Multi-cloud standardization**: Consistent schema across AWS, Azure, GCP, and others
- **Simplified analytics**: Standardized column names and data types
- **Industry adoption**: Supported by major cloud providers and FinOps tools
- **Future-proof**: Maintained by the FinOps Foundation with regular updates

### Transformation Overview

- **FOCUS 1.0 Core Columns**: 43 standardized columns
- **AWS-Specific Extensions**: 5 additional `x_*` columns
- **Total Columns**: 48 columns in FOCUS 1.0 with AWS extensions
- **Primary Cost Metrics**: 4 standardized cost columns (ListCost, ContractedCost, BilledCost, EffectiveCost)

---

## Table of Contents

1. [Column Mapping Reference](#column-mapping-reference)
2. [Complex Transformations](#complex-transformations)
3. [Service Category Mapping](#service-category-mapping)
4. [Commitment Discount Mapping](#commitment-discount-mapping)
5. [Data Quality & Validation](#data-quality--validation)
6. [Implementation Notes](#implementation-notes)

---

## Column Mapping Reference

### Identity & Account Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **BillingAccountId** | `bill_payer_account_id` | STRING | Direct mapping | Payer account (management account) |
| **BillingAccountName** | `bill_payer_account_name` | STRING | Direct mapping | Payer account name |
| **SubAccountId** | `line_item_usage_account_id` | STRING | Direct mapping | Usage account (linked account) |
| **SubAccountName** | `line_item_usage_account_name` | STRING | Direct mapping | Usage account name |
| **InvoiceIssuerName** | Static: `'AWS'` | STRING | Constant | Always 'AWS' for AWS CUR |
| **ProviderName** | Static: `'AWS'` | STRING | Constant | Always 'AWS' |
| **PublisherName** | Static: `'AWS'` | STRING | Constant | Always 'AWS' |

### Billing Period Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **BillingPeriodStart** | `bill_billing_period_start_date` | TIMESTAMP | CAST as TIMESTAMP | Start of billing month |
| **BillingPeriodEnd** | `bill_billing_period_end_date` | TIMESTAMP | CAST as TIMESTAMP | End of billing month |
| **ChargePeriodStart** | `line_item_usage_start_date` | TIMESTAMP | CAST as TIMESTAMP | Usage start for this line item |
| **ChargePeriodEnd** | `line_item_usage_end_date` | TIMESTAMP | CAST as TIMESTAMP | Usage end for this line item |

### Core Cost Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **BilledCost** | `line_item_unblended_cost` | DECIMAL(18,6) | CAST as DECIMAL | Actual invoiced cost |
| **EffectiveCost** | Complex | DECIMAL(18,6) | See formula below | Amortized cost including commitments |
| **ListCost** | `pricing_public_on_demand_cost` | DECIMAL(18,6) | COALESCE with 0 | Public on-demand cost |
| **ContractedCost** | Complex | DECIMAL(18,6) | See formula below | Cost with contracted rates |
| **BillingCurrency** | `line_item_currency_code` | STRING | Direct mapping | Usually 'USD' |

#### EffectiveCost Formula

```sql
COALESCE(
  -- For Reserved Instances
  reservation_effective_cost,
  -- For Savings Plans
  savings_plan_savings_plan_effective_cost,
  -- For regular usage
  line_item_unblended_cost,
  0
) AS EffectiveCost
```

#### ContractedCost Formula

```sql
CASE
  WHEN reservation_reservation_a_r_n IS NOT NULL THEN reservation_effective_cost
  WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN savings_plan_savings_plan_effective_cost
  WHEN pricing_term = 'OnDemand' THEN line_item_unblended_cost
  ELSE line_item_unblended_cost
END AS ContractedCost
```

### Charge Classification Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **ChargeCategory** | `line_item_line_item_type` | STRING | CASE mapping | See [ChargeCategory Mapping](#chargecategory-mapping) |
| **ChargeClass** | Multiple | STRING | CASE mapping | Nullable; 'Correction' or NULL |
| **ChargeDescription** | `line_item_line_item_description` | STRING | Direct mapping | Human-readable description |
| **ChargeFrequency** | Complex | STRING | CASE mapping | 'Recurring', 'One-Time', 'Usage-Based' |

### Pricing & Quantity Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **PricingCategory** | `pricing_term` | STRING | CASE mapping | 'On-Demand', 'Reserved', 'Spot', 'Committed' |
| **PricingQuantity** | `line_item_usage_amount` | DECIMAL(18,9) | CAST as DECIMAL | Usage quantity |
| **PricingUnit** | `pricing_unit` | STRING | Normalize units | 'Hrs', 'GB', 'Requests', etc. |
| **ConsumedQuantity** | `line_item_usage_amount` | DECIMAL(18,9) | Same as PricingQuantity | Consumed usage |
| **ConsumedUnit** | `pricing_unit` | STRING | Same as PricingUnit | Consumed unit |
| **ContractedUnitPrice** | `line_item_unblended_rate` | DECIMAL(18,9) | CAST as DECIMAL | Rate per unit |
| **ListUnitPrice** | `pricing_public_on_demand_rate` | DECIMAL(18,9) | CAST as DECIMAL | Public rate per unit |

### Resource & Service Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **ResourceId** | `line_item_resource_id` | STRING | Direct mapping | ARN or resource identifier |
| **ResourceName** | Extract from tags or ARN | STRING | Complex extraction | From `resource_tags` or ARN parsing |
| **ServiceCategory** | `line_item_product_code` | STRING | Mapping table | See [Service Category Mapping](#service-category-mapping) |
| **ServiceName** | `line_item_product_code` | STRING | Direct mapping | AWS service code |
| **SkuId** | `product_sku` | STRING | Direct mapping | Product SKU |
| **SkuPriceId** | `pricing_rate_id` | STRING | Direct mapping | Rate ID |

### Geographic Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **Region** | `product_region_code` | STRING | Direct mapping | AWS region code |
| **RegionId** | `product_region_code` | STRING | Same as Region | Region identifier |
| **RegionName** | `product_location` | STRING | Map to friendly name | 'US East (N. Virginia)' |
| **AvailabilityZone** | `line_item_availability_zone` | STRING | Direct mapping | AZ identifier |

### Commitment Discount Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **CommitmentDiscountId** | Combined | STRING | See formula | RI ARN or SP ARN |
| **CommitmentDiscountName** | N/A | STRING | NULL or derived | Not in CUR 2.0 |
| **CommitmentDiscountType** | Multiple | STRING | CASE mapping | 'Reservation', 'Savings Plan' |
| **CommitmentDiscountStatus** | `reservation_modification_status` | STRING | Map to FOCUS values | 'Used', 'Unused' |
| **CommitmentDiscountCategory** | Derived | STRING | 'Spend' or 'Usage' | Based on commitment type |

#### CommitmentDiscountId Formula

```sql
COALESCE(
  reservation_reservation_a_r_n,
  savings_plan_savings_plan_a_r_n
) AS CommitmentDiscountId
```

#### CommitmentDiscountType Mapping

```sql
CASE
  WHEN reservation_reservation_a_r_n IS NOT NULL THEN 'Reservation'
  WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN 'Savings Plan'
  ELSE NULL
END AS CommitmentDiscountType
```

### Tag Columns

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **Tags** | `resource_tags` | JSON/STRUCT | JSON parsing | All resource tags as JSON object |

#### Tag Transformation Example

```sql
-- Parse resource_tags JSON string into structured format
CASE
  WHEN resource_tags IS NOT NULL 
    AND resource_tags != '' 
    AND resource_tags != '{}' 
  THEN PARSE_JSON(resource_tags)
  ELSE NULL
END AS Tags
```

### AWS-Specific Extension Columns (x_* prefix)

| FOCUS Column | AWS CUR 2.0 Source | Data Type | Transformation | Notes |
|--------------|-------------------|-----------|----------------|-------|
| **x_Operation** | `line_item_operation` | STRING | Direct mapping | AWS operation |
| **x_UsageType** | `line_item_usage_type` | STRING | Direct mapping | AWS usage type |
| **x_ServiceCode** | `line_item_product_code` | STRING | Direct mapping | AWS service code |
| **x_CostCategories** | `cost_category` | JSON | JSON parsing | Cost allocation categories |
| **x_Discounts** | Multiple discount columns | JSON | Aggregate discounts | All discount types |

---

## Complex Transformations

### ChargeCategory Mapping

The `ChargeCategory` column represents the highest-level classification of a charge.

```sql
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
  WHEN 'DiscountedUsage' THEN 'Usage'
  WHEN 'BundledDiscount' THEN 'Adjustment'
  WHEN 'EdpDiscount' THEN 'Adjustment'
  WHEN 'PrivateRateDiscount' THEN 'Adjustment'
  ELSE 'Usage'
END AS ChargeCategory
```

### ChargeClass Mapping

```sql
CASE
  WHEN bill_bill_type = 'Anniversary' THEN NULL  -- Regular billing
  WHEN bill_bill_type = 'Refund' THEN 'Correction'
  WHEN bill_bill_type = 'Purchase' THEN NULL
  -- Add logic for detecting corrections to previous billing periods
  WHEN line_item_line_item_type IN ('Credit', 'Refund') 
    AND line_item_usage_start_date < bill_billing_period_start_date 
  THEN 'Correction'
  ELSE NULL
END AS ChargeClass
```

### ChargeFrequency Mapping

```sql
CASE
  WHEN line_item_line_item_type IN ('RIFee', 'SavingsPlanUpfrontFee') THEN 'One-Time'
  WHEN line_item_line_item_type IN ('SavingsPlanRecurringFee') THEN 'Recurring'
  WHEN line_item_line_item_type IN ('Fee') 
    AND line_item_line_item_description LIKE '%monthly%' THEN 'Recurring'
  WHEN line_item_line_item_type IN ('Usage', 'SavingsPlanCoveredUsage', 'DiscountedUsage') 
  THEN 'Usage-Based'
  ELSE 'Usage-Based'
END AS ChargeFrequency
```

### PricingCategory Mapping

```sql
CASE
  WHEN reservation_reservation_a_r_n IS NOT NULL THEN 'Reserved'
  WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN 'Committed'
  WHEN pricing_term = 'OnDemand' THEN 'On-Demand'
  WHEN pricing_term = 'Spot' THEN 'Spot'
  WHEN line_item_line_item_type = 'Usage' THEN 'On-Demand'
  ELSE 'On-Demand'
END AS PricingCategory
```

### ResourceName Extraction

```sql
-- Extract resource name from tags or ARN
COALESCE(
  -- Try to get Name tag from resource_tags JSON
  JSON_EXTRACT_SCALAR(resource_tags, '$.Name'),
  JSON_EXTRACT_SCALAR(resource_tags, '$.name'),
  JSON_EXTRACT_SCALAR(resource_tags, '$.aws:Name'),
  -- Extract from ARN (last segment after /)
  CASE 
    WHEN line_item_resource_id LIKE 'arn:%' 
    THEN REGEXP_EXTRACT(line_item_resource_id, r'/([^/]+)$')
    ELSE line_item_resource_id
  END
) AS ResourceName
```

### Tags JSON Construction

```sql
-- Convert AWS resource_tags string to proper JSON
CASE
  WHEN resource_tags IS NOT NULL 
    AND resource_tags != '' 
    AND resource_tags != '{}' 
    AND JSON_VALID(resource_tags)
  THEN 
    -- Parse and restructure tags
    PARSE_JSON(resource_tags)
  ELSE 
    NULL
END AS Tags
```

---

## Service Category Mapping

The `ServiceCategory` column provides a high-level classification of AWS services. Below is the comprehensive mapping:

### Compute Services

```sql
CASE line_item_product_code
  WHEN 'AmazonEC2' THEN 'Compute'
  WHEN 'AmazonECS' THEN 'Compute'
  WHEN 'AmazonEKS' THEN 'Compute'
  WHEN 'AWSLambda' THEN 'Compute'
  WHEN 'AWSBatch' THEN 'Compute'
  WHEN 'ElasticMapReduce' THEN 'Compute'
  WHEN 'AmazonLightsail' THEN 'Compute'
```

### Storage Services

```sql
  WHEN 'AmazonS3' THEN 'Storage'
  WHEN 'AmazonEBS' THEN 'Storage'
  WHEN 'AmazonEFS' THEN 'Storage'
  WHEN 'AmazonFSx' THEN 'Storage'
  WHEN 'AmazonGlacier' THEN 'Storage'
  WHEN 'AWSBackup' THEN 'Storage'
  WHEN 'AWSStorageGateway' THEN 'Storage'
  WHEN 'AmazonS3GlacierDeepArchive' THEN 'Storage'
```

### Database Services

```sql
  WHEN 'AmazonRDS' THEN 'Database'
  WHEN 'AmazonDynamoDB' THEN 'Database'
  WHEN 'AmazonRedshift' THEN 'Database'
  WHEN 'AmazonElastiCache' THEN 'Database'
  WHEN 'AmazonDocumentDB' THEN 'Database'
  WHEN 'AmazonNeptune' THEN 'Database'
  WHEN 'AmazonKeyspaces' THEN 'Database'
  WHEN 'AmazonMemoryDB' THEN 'Database'
  WHEN 'AmazonRDSProxy' THEN 'Database'
  WHEN 'AmazonTimestream' THEN 'Database'
  WHEN 'AmazonQLDB' THEN 'Database'
```

### Networking Services

```sql
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
  WHEN 'AmazonCloudWAN' THEN 'Networking'
```

### Analytics Services

```sql
  WHEN 'AmazonAthena' THEN 'Analytics'
  WHEN 'AmazonEMR' THEN 'Analytics'
  WHEN 'AWSGlue' THEN 'Analytics'
  WHEN 'AmazonKinesis' THEN 'Analytics'
  WHEN 'AmazonMSK' THEN 'Analytics'
  WHEN 'AmazonOpenSearchService' THEN 'Analytics'
  WHEN 'AmazonQuickSight' THEN 'Analytics'
  WHEN 'AmazonDataZone' THEN 'Analytics'
  WHEN 'AmazonManagedStreamingforKafka' THEN 'Analytics'
  WHEN 'AWSLakeFormation' THEN 'Analytics'
  WHEN 'AWSDataExchange' THEN 'Analytics'
  WHEN 'AWSDataPipeline' THEN 'Analytics'
```

### AI/ML Services

```sql
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
  WHEN 'AmazonAugmentedAI' THEN 'AI/ML'
  WHEN 'AmazonCodeWhisperer' THEN 'AI/ML'
  WHEN 'AmazonDevOpsGuru' THEN 'AI/ML'
```

### Security & Identity Services

```sql
  WHEN 'AWSKeyManagementService' THEN 'Security'
  WHEN 'AWSSecretsManager' THEN 'Security'
  WHEN 'AmazonGuardDuty' THEN 'Security'
  WHEN 'AmazonInspector' THEN 'Security'
  WHEN 'AWSSecurityHub' THEN 'Security'
  WHEN 'AWSWAF' THEN 'Security'
  WHEN 'AWSShield' THEN 'Security'
  WHEN 'AmazonMacie' THEN 'Security'
  WHEN 'AWSCertificateManager' THEN 'Security'
  WHEN 'AWSFirewall' THEN 'Security'
  WHEN 'AmazonDetective' THEN 'Security'
  WHEN 'AWSIdentityandAccessManagement' THEN 'Security'
  WHEN 'AWSDirectoryService' THEN 'Security'
  WHEN 'AmazonCognito' THEN 'Security'
```

### Management & Governance Services

```sql
  WHEN 'AWSCloudTrail' THEN 'Management'
  WHEN 'AmazonCloudWatch' THEN 'Management'
  WHEN 'AWSConfig' THEN 'Management'
  WHEN 'AWSSystemsManager' THEN 'Management'
  WHEN 'AWSControlTower' THEN 'Management'
  WHEN 'AWSOrganizations' THEN 'Management'
  WHEN 'AWSServiceCatalog' THEN 'Management'
  WHEN 'AWSCloudFormation' THEN 'Management'
  WHEN 'AWSTrustedAdvisor' THEN 'Management'
  WHEN 'AWSLicenseManager' THEN 'Management'
  WHEN 'AWSHealth' THEN 'Management'
  WHEN 'AWSSupport' THEN 'Management'
  WHEN 'AWSBackupGateway' THEN 'Management'
```

### Application Integration Services

```sql
  WHEN 'AmazonSNS' THEN 'Application Integration'
  WHEN 'AmazonSQS' THEN 'Application Integration'
  WHEN 'AWSStepFunctions' THEN 'Application Integration'
  WHEN 'AmazonEventBridge' THEN 'Application Integration'
  WHEN 'AWSAppSync' THEN 'Application Integration'
  WHEN 'AmazonMQ' THEN 'Application Integration'
  WHEN 'AmazonAppFlow' THEN 'Application Integration'
```

### Container Services

```sql
  WHEN 'AmazonECR' THEN 'Containers'
  WHEN 'AmazonECS' THEN 'Containers'
  WHEN 'AmazonEKS' THEN 'Containers'
  WHEN 'AWSAppRunner' THEN 'Containers'
  WHEN 'AWSFargate' THEN 'Containers'
```

### Developer Tools

```sql
  WHEN 'AWSCodeBuild' THEN 'Developer Tools'
  WHEN 'AWSCodeCommit' THEN 'Developer Tools'
  WHEN 'AWSCodeDeploy' THEN 'Developer Tools'
  WHEN 'AWSCodePipeline' THEN 'Developer Tools'
  WHEN 'AWSCloud9' THEN 'Developer Tools'
  WHEN 'AWSCodeArtifact' THEN 'Developer Tools'
  WHEN 'AWSXRay' THEN 'Developer Tools'
  WHEN 'AmazonCodeGuru' THEN 'Developer Tools'
```

### End User Computing

```sql
  WHEN 'AmazonWorkSpaces' THEN 'End User Computing'
  WHEN 'AmazonAppStream' THEN 'End User Computing'
  WHEN 'AmazonWorkDocs' THEN 'End User Computing'
  WHEN 'AmazonWorkMail' THEN 'End User Computing'
  WHEN 'AmazonWorkLink' THEN 'End User Computing'
```

### IoT Services

```sql
  WHEN 'AWSIoTCore' THEN 'IoT'
  WHEN 'AWSIoTAnalytics' THEN 'IoT'
  WHEN 'AWSIoTGreengrass' THEN 'IoT'
  WHEN 'AWSIoTEvents' THEN 'IoT'
  WHEN 'AWSIoTSiteWise' THEN 'IoT'
  WHEN 'AWSIoTThingsGraph' THEN 'IoT'
```

### Media Services

```sql
  WHEN 'AmazonElasticTranscoder' THEN 'Media'
  WHEN 'AWSElementalMediaConvert' THEN 'Media'
  WHEN 'AWSElementalMediaLive' THEN 'Media'
  WHEN 'AWSElementalMediaPackage' THEN 'Media'
  WHEN 'AWSElementalMediaStore' THEN 'Media'
  WHEN 'AmazonKinesisVideoStreams' THEN 'Media'
```

### Migration & Transfer Services

```sql
  WHEN 'AWSMigrationHub' THEN 'Migration'
  WHEN 'AWSDatabaseMigrationService' THEN 'Migration'
  WHEN 'AWSServerMigrationService' THEN 'Migration'
  WHEN 'AWSSnowball' THEN 'Migration'
  WHEN 'AWSDataSync' THEN 'Migration'
  WHEN 'AWSTransferFamily' THEN 'Migration'
  WHEN 'AWSApplicationDiscoveryService' THEN 'Migration'
  WHEN 'AWSApplicationMigrationService' THEN 'Migration'
```

### Other/Unclassified

```sql
  ELSE 'Other'
END AS ServiceCategory
```

---

## Commitment Discount Mapping

### Reserved Instance (RI) Details

| FOCUS Concept | AWS CUR 2.0 Columns | Mapping Logic |
|---------------|-------------------|---------------|
| **Commitment ID** | `reservation_reservation_a_r_n` | Direct ARN |
| **Commitment Type** | Derived | 'Reservation' |
| **Commitment Status** | `reservation_modification_status` | 'Active', 'Retired', 'Modified' |
| **Amortized Cost** | `reservation_effective_cost` | RI amortized cost |
| **Upfront Fee** | `reservation_amortized_upfront_cost_for_usage` | Amortized upfront portion |
| **Recurring Fee** | `reservation_recurring_fee_for_usage` | Recurring hourly fee |
| **Unused Cost** | `reservation_unused_amortized_upfront_fee_for_billing_period` + `reservation_unused_recurring_fee` | Wasted commitment |

### Savings Plan (SP) Details

| FOCUS Concept | AWS CUR 2.0 Columns | Mapping Logic |
|---------------|-------------------|---------------|
| **Commitment ID** | `savings_plan_savings_plan_a_r_n` | Direct ARN |
| **Commitment Type** | Derived + `savings_plan_offering_type` | 'Compute Savings Plan' or 'EC2 Instance Savings Plan' |
| **Commitment Status** | Derived from dates | Compare current date to `savings_plan_start_time` / `savings_plan_end_time` |
| **Effective Cost** | `savings_plan_savings_plan_effective_cost` | SP amortized cost |
| **Commitment Amount** | `savings_plan_total_commitment_to_date` | Total commitment |
| **Used Amount** | `savings_plan_used_commitment` | Used portion |
| **Unused Amount** | `savings_plan_recurring_commitment_for_billing_period` - `savings_plan_used_commitment` | Wasted commitment |

### CommitmentDiscountCategory Mapping

```sql
CASE
  -- Savings Plans are always spend-based
  WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN 'Spend'
  
  -- Reserved Instances can be usage-based or spend-based
  WHEN reservation_reservation_a_r_n IS NOT NULL THEN
    CASE
      -- Standard and Convertible RIs are usage-based
      WHEN reservation_subscription_id IS NOT NULL THEN 'Usage'
      ELSE 'Usage'
    END
  
  ELSE NULL
END AS CommitmentDiscountCategory
```

### CommitmentDiscountStatus Mapping

```sql
CASE
  -- For Reserved Instances
  WHEN reservation_reservation_a_r_n IS NOT NULL THEN
    CASE
      WHEN reservation_unused_quantity > 0 THEN 'Unused'
      WHEN line_item_line_item_type = 'DiscountedUsage' THEN 'Used'
      WHEN line_item_line_item_type = 'RIFee' THEN 'Used'
      ELSE 'Used'
    END
  
  -- For Savings Plans
  WHEN savings_plan_savings_plan_a_r_n IS NOT NULL THEN
    CASE
      WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN 'Used'
      WHEN line_item_line_item_type IN ('SavingsPlanRecurringFee', 'SavingsPlanUpfrontFee') THEN 'Used'
      -- Unused is calculated separately, not in line items
      ELSE 'Used'
    END
  
  ELSE NULL
END AS CommitmentDiscountStatus
```

---

## Data Quality & Validation

### Required Field Validation

All FOCUS datasets MUST include these columns with non-null values:

```sql
-- Critical validation checks
SELECT
  COUNT(*) AS total_rows,
  COUNT(BilledCost) AS billed_cost_count,
  COUNT(ChargeDescription) AS charge_desc_count,
  COUNT(BillingCurrency) AS billing_currency_count,
  COUNT(BillingPeriodStart) AS billing_start_count,
  COUNT(BillingPeriodEnd) AS billing_end_count
FROM focus_dataset
HAVING 
  billed_cost_count != total_rows OR
  charge_desc_count != total_rows OR
  billing_currency_count != total_rows;
```

### Cost Reconciliation

Validate that total AWS cost equals total FOCUS cost:

```sql
-- Reconciliation query
WITH aws_totals AS (
  SELECT 
    SUM(line_item_unblended_cost) AS aws_total_cost,
    COUNT(*) AS aws_row_count
  FROM aws_cur_raw
),
focus_totals AS (
  SELECT 
    SUM(BilledCost) AS focus_total_cost,
    COUNT(*) AS focus_row_count
  FROM focus_transformed
)
SELECT
  aws_total_cost,
  focus_total_cost,
  aws_total_cost - focus_total_cost AS cost_difference,
  ROUND(ABS(aws_total_cost - focus_total_cost) / NULLIF(aws_total_cost, 0) * 100, 4) AS percent_difference
FROM aws_totals, focus_totals;
```

**Acceptable Variance**: < 0.01% due to rounding

### Null Field Handling

| Field Type | Null Handling Strategy |
|------------|----------------------|
| **Required Fields** | COALESCE with default values; log errors |
| **Optional Fields** | Allow NULL values |
| **Cost Fields** | COALESCE with 0.0 |
| **String Fields** | COALESCE with empty string or 'Unknown' |
| **Date Fields** | Must not be NULL for billing periods |

### Data Type Validation

```sql
-- Validate data types
SELECT
  -- Check BilledCost is numeric
  CASE WHEN SAFE_CAST(BilledCost AS FLOAT64) IS NULL THEN 'Invalid' ELSE 'Valid' END AS billed_cost_type,
  
  -- Check dates are valid timestamps
  CASE WHEN SAFE_CAST(BillingPeriodStart AS TIMESTAMP) IS NULL THEN 'Invalid' ELSE 'Valid' END AS billing_start_type,
  
  -- Check currency is valid ISO code
  CASE WHEN LENGTH(BillingCurrency) = 3 THEN 'Valid' ELSE 'Invalid' END AS currency_code_type
  
FROM focus_dataset
WHERE 
  SAFE_CAST(BilledCost AS FLOAT64) IS NULL OR
  SAFE_CAST(BillingPeriodStart AS TIMESTAMP) IS NULL OR
  LENGTH(BillingCurrency) != 3;
```

### Duplicate Detection

```sql
-- Detect duplicate records
SELECT
  identity_line_item_id,
  COUNT(*) AS duplicate_count
FROM focus_dataset
GROUP BY identity_line_item_id
HAVING COUNT(*) > 1;
```

### Data Completeness Score

```sql
-- Calculate completeness score
SELECT
  'ResourceId' AS field_name,
  COUNT(ResourceId) * 100.0 / COUNT(*) AS completeness_pct
FROM focus_dataset
UNION ALL
SELECT
  'Tags',
  COUNT(Tags) * 100.0 / COUNT(*)
FROM focus_dataset
UNION ALL
SELECT
  'CommitmentDiscountId',
  COUNT(CommitmentDiscountId) * 100.0 / COUNT(*)
FROM focus_dataset;
```

---

## Implementation Notes

### Transformation Performance

**Recommended Approach:**
1. Create materialized views for frequently accessed data
2. Partition by `BillingPeriodStart` (monthly partitions)
3. Cluster by `ServiceName`, `Region`, `SubAccountId`
4. Use incremental updates for new billing periods only

### BigQuery Optimization

```sql
-- Create optimized table
CREATE TABLE `project.dataset.focus_cur`
PARTITION BY DATE(BillingPeriodStart)
CLUSTER BY ServiceName, Region, SubAccountId
AS
SELECT * FROM `project.dataset.focus_transformed_view`;
```

### Incremental Loading Strategy

```sql
-- Process only new data
INSERT INTO `project.dataset.focus_cur`
SELECT * FROM `project.dataset.focus_transformed_view`
WHERE BillingPeriodStart >= (
  SELECT MAX(BillingPeriodStart) FROM `project.dataset.focus_cur`
);
```

### Known Limitations & Gaps

1. **ChargeClass**: AWS CUR 2.0 doesn't explicitly mark corrections; requires custom logic
2. **ResourceName**: Not directly available; must extract from tags or ARN
3. **CommitmentDiscountName**: Not provided in CUR; use ARN or ID instead
4. **PricingCurrency**: Added in FOCUS 1.2; may need separate currency mapping
5. **Tags Normalization**: AWS tags vary in structure; standardization required

### Migration Checklist

- [ ] Validate source CUR 2.0 table structure and columns
- [ ] Test transformation on sample dataset (1 month)
- [ ] Run cost reconciliation queries
- [ ] Validate all required FOCUS columns are present
- [ ] Check data type compatibility
- [ ] Test with BI tools (Looker, QuickSight, Power BI)
- [ ] Set up automated refresh schedule
- [ ] Document any custom transformations or business logic
- [ ] Train stakeholders on FOCUS schema differences
- [ ] Establish monitoring and alerting for data quality

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-17 | Initial comprehensive mapping document |

### References

- [FOCUS Specification v1.2](https://focus.finops.org/focus-specification/v1-2/)
- [AWS Data Exports FOCUS Documentation](https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-0-aws.html)
- [FinOps Foundation](https://www.finops.org/)
- [AWS CUR 2.0 Documentation](https://docs.aws.amazon.com/cur/latest/userguide/)

---

**Document Maintained By**: FinOps Engineering Team  
**Last Review Date**: 2025-11-17  
**Next Review Date**: 2025-12-17
